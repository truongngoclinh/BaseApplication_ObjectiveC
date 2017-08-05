//
//  BTSocket.m
//  BTFoundation
//
//  Created by Andrew Eng on 12/10/15.
//  Copyright © 2015 garena. All rights reserved.
//

#import "BTSocket.h"

#import <netinet/tcp.h>
#import <netinet/in.h>
#import <arpa/inet.h>

#define BTSOCKET_STRINGIFY(v) #v
#define BTSOCKET_CASE(x) case x : return @BTSOCKET_STRINGIFY(x);

static NSString *streamStatusFromCode(NSInteger code)
{
    switch (code) {
            BTSOCKET_CASE(NSStreamStatusNotOpen);
            BTSOCKET_CASE(NSStreamStatusOpening);
            BTSOCKET_CASE(NSStreamStatusOpen);
            BTSOCKET_CASE(NSStreamStatusReading);
            BTSOCKET_CASE(NSStreamStatusWriting);
            BTSOCKET_CASE(NSStreamStatusAtEnd);
            BTSOCKET_CASE(NSStreamStatusClosed);
            BTSOCKET_CASE(NSStreamStatusError);
    }
    return nil;
}

static NSString *eventStringFromCode(NSInteger code)
{
    switch (code) {
            BTSOCKET_CASE(NSStreamEventNone);
            BTSOCKET_CASE(NSStreamEventOpenCompleted);
            BTSOCKET_CASE(NSStreamEventHasBytesAvailable);
            BTSOCKET_CASE(NSStreamEventHasSpaceAvailable);
            BTSOCKET_CASE(NSStreamEventErrorOccurred);
            BTSOCKET_CASE(NSStreamEventEndEncountered);
    }
    return nil;
}

typedef NS_OPTIONS(NSUInteger, BTSocketFlag)
{
    BTSocketFlagInputOpen         = 1 << 0,
    BTSocketFlagOutputOpen        = 1 << 1,
    BTSocketFlagHasSpaceAvailable = 1 << 2,
};

/** https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/Streams/Articles/WritingOutputStreams.html
 The best approach is to use some reasonable buffer size, such as 512 bytes,
 one kilobyte (as in the example above), or a page size (four kilobytes) */
static NSInteger const kBufferSize = 512;

NSString *const BTSocketErrorDomain = @"com.garena.btfoundation.btsocket";
NSString *const BTSocketStreamErrorKey = @"BTSocketStreamErrorKey";

@interface BTSocket () <NSStreamDelegate>

@property (nonatomic, weak) id <BTSocketDelegate> delegate;

@property (nonatomic, strong) NSInputStream *inputStream;
@property (nonatomic, strong) NSOutputStream *outputStream;

@property (nonatomic, assign) BTSocketFlag flags;
@property (nonatomic, strong) NSMutableData *outputPacket;

@property (nonatomic, assign) BOOL hasAttachedAnchorCertificates;

@end


@implementation BTSocket

- (id)initWithDelegate:(id<BTSocketDelegate>)delegate
{
    self = [super init];
    
    if (self) {
        self.delegate = delegate;
        self.hasAttachedAnchorCertificates = NO;
    }
    
    return self;
}

- (void)dealloc
{
    self.inputStream.delegate = nil;
    self.outputStream.delegate = nil;
    
    [self logData:@"%@", NSStringFromSelector(_cmd)];
}

- (void)connectToHost:(NSString *)host error:(NSError **)error
{
    NSParameterAssert([NSThread isMainThread]);
    [self logData:@"%@ - %@", NSStringFromSelector(_cmd), host];
    
    
    // Extract hostname and port
    NSArray *components = [host componentsSeparatedByString:@":"];
    
    if (components.count != 2) {
        NSParameterAssert(NO);
        if (error) {
            *error = [self errorWithCode:BTSocketErrorCodeInvalidHost];
        }
        return;
    }
    NSString *hostname = components[0];
    NSString *port = components[1];
    
    
    // Create Streams
    BTSocketState inputState = [self connectionStateForStream:self.inputStream];
    BTSocketState outputState = [self connectionStateForStream:self.outputStream];
    if (inputState != BTSocketStateNotConnected || outputState != BTSocketStateNotConnected) {
        NSParameterAssert(NO);
        if (error) {
            *error = [self errorWithCode:BTSocketErrorCodeSocketAlreadyOpened];
        }
        return;
    }
    
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    [self cf_createStreamPairWithHostname:hostname
                                     port:port
                              inputStream:&inputStream
                             outputStream:&outputStream];
    
    self.inputStream = inputStream;
    self.outputStream = outputStream;
    self.inputStream.delegate = self;
    self.outputStream.delegate = self;
    [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self.inputStream open];
    [self.outputStream open];
    self.hasAttachedAnchorCertificates = NO;
    
    self.outputPacket = [NSMutableData data];
    
    
    // Apply SSL Settings
    if ([self.sslSettings count]) {
        BOOL success = [self cf_applySSLSettings:self.sslSettings
                                  forInputStream:self.inputStream
                                    outputStream:self.outputStream];
        if (!success) {
            [self stop];
            NSParameterAssert(NO);
            if (error) {
                *error = [self errorWithCode:BTSocketErrorCodeSSLSettingsFailed];
            }
            return;
        }
    }
    
    [self logData:@"Connecting to %@", host];
}

- (void)send:(NSData *)data error:(NSError *__autoreleasing *)error
{
    [self logData:@"%@", NSStringFromSelector(_cmd)];

    BTSocketState inputState = [self connectionStateForStream:self.inputStream];
    BTSocketState outputState = [self connectionStateForStream:self.outputStream];
    if (inputState == BTSocketStateNotConnected || outputState == BTSocketStateNotConnected) {
        NSParameterAssert(NO);
        if (error) {
            *error = [self errorWithCode:BTSocketErrorCodeSocketNotOpened];
        }
        return;
    }
    
    [self.outputPacket appendData:data];
    
    [self processQueue];
}

- (void)stop
{
    [self logData:@"%@", NSStringFromSelector(_cmd)];
    
    self.flags = 0;
    self.outputPacket.length = 0;

    // Destroy Streams
    self.inputStream.delegate = nil;
    self.outputStream.delegate = nil;
    [self.inputStream close];
    [self.outputStream close];
    [self.inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self.outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    self.inputStream = nil;
    self.outputStream = nil;
}

- (void)processQueue
{
    [self logData:@"%@", NSStringFromSelector(_cmd)];
    [self logData:@"Has space available!!!?!?:%d", self.outputStream.hasSpaceAvailable];
    
    if ((self.flags & BTSocketFlagHasSpaceAvailable) == 0) {
        return;
    }
    
    if (self.outputPacket.length <= 0) {
        return;
    }
    
    self.flags &= ~BTSocketFlagHasSpaceAvailable;
    
    NSInteger written = [self.outputStream write:self.outputPacket.bytes
                                       maxLength:MIN(kBufferSize, self.outputPacket.length)];
    if (written <= 0) {
        [self onDisconnectedWithError:[self errorWithCode:BTSocketErrorCodeStreamWriteFailed]];
        return;
    }
    
    [self.outputPacket replaceBytesInRange:NSMakeRange(0, written) withBytes:NULL length:0];
    
    [self logData:@"Written:%zd bytes", written];
}

#pragma mark - Information

- (NSString *)connectedIP
{
    if (!self.inputStream) {
        NSParameterAssert(NO);
        return nil;
    }

    char p[INET6_ADDRSTRLEN];

    struct sockaddr_storage pSockAddr = [self cf_socketAddressForInputStream:self.inputStream];

    if (pSockAddr.ss_family == AF_INET6) {
        struct sockaddr_in6 *socket = (struct sockaddr_in6*)&pSockAddr;
        inet_ntop(socket->sin6_family, &(socket->sin6_addr), p, sizeof p);
    } else {
        struct sockaddr_in *socket = (struct sockaddr_in *)&pSockAddr;
        inet_ntop(socket->sin_family, &(socket->sin_addr), p, sizeof p);
    }

    return [NSString stringWithUTF8String:p];
}

- (NSString *)connectedPort
{
    if (!self.inputStream) {
        NSParameterAssert(NO);
        return nil;
    }

    struct sockaddr_storage pSockAddr = [self cf_socketAddressForInputStream:self.inputStream];

    uint16_t port = 0;
    if (pSockAddr.ss_family == AF_INET6) {
        struct sockaddr_in6 *socket = (struct sockaddr_in6*)&pSockAddr;
        port = socket->sin6_port;
    } else {
        struct sockaddr_in *socket = (struct sockaddr_in *)&pSockAddr;
        port = socket->sin_port;
    }

    return [NSString stringWithFormat:@"%@", @(ntohs(port))];
}

#pragma mark - Events

- (void)onReceiveData:(NSData *)data
{
    NSParameterAssert([NSThread isMainThread]);
    
    [self logData:@"%@", NSStringFromSelector(_cmd)];
    [self logData:@"Received :%zd bytes", data.length];
    
    [self.delegate socket:self didReceiveData:data];
}

- (void)onConnected
{
    NSParameterAssert([NSThread isMainThread]);
    
    [self logData:@"%@", NSStringFromSelector(_cmd)];
    
    [self cf_applySocketSettingsForInputStream:self.inputStream outputStream:self.outputStream];
    [self.delegate socketDidConnect:self];
}

- (void)onDisconnectedWithError:(NSError *)error
{
    NSParameterAssert([NSThread isMainThread]);

    [self logData:@"%@, error:%@", NSStringFromSelector(_cmd), error];

    [self stop];
    [self.delegate socketDidDisconnect:self withError:error];
}

#pragma mark - NSStreamDelegate

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    NSParameterAssert([NSThread isMainThread]);
    [self logData:@"================="];
    [self logData:@"%@", NSStringFromSelector(_cmd)];
    [self logData:@"code:%@", eventStringFromCode(eventCode)];
    [self logData:@"status:%@", streamStatusFromCode(aStream.streamStatus)];
    [self logData:@"================="];
    
    if (aStream != self.inputStream && aStream != self.outputStream) {
        NSParameterAssert(NO);
        NSLog(@"SIMILJ IS THIS STREAM!? %@", aStream);
        return;
    }

    if (eventCode == NSStreamEventHasBytesAvailable || eventCode == NSStreamEventHasSpaceAvailable) {
        SecTrustRef trust = (__bridge SecTrustRef)[self.inputStream propertyForKey: (__bridge NSString *)kCFStreamPropertySSLPeerTrust];
        if (![self evaluateTrust:trust]){
            [self onDisconnectedWithError:[self errorWithCode:BTSocketErrorCodeStreamSSLBadCert]];
            return;
        }
    }
    
    switch (eventCode) {
        case NSStreamEventOpenCompleted:
            
            if (aStream == self.inputStream) {
                self.flags |= BTSocketFlagInputOpen;
            }
            if (aStream == self.outputStream) {
                self.flags |= BTSocketFlagOutputOpen;
            }
            
            BTSocketFlag isOpen = BTSocketFlagInputOpen|BTSocketFlagOutputOpen;

            if ((self.flags & isOpen) == isOpen) {
                [self onConnected];
            }
            break;
            
        case NSStreamEventHasSpaceAvailable:
            self.flags |= BTSocketFlagHasSpaceAvailable;
            [self processQueue];
            break;
            
        case NSStreamEventHasBytesAvailable:
        {
            NSMutableData *allData = [NSMutableData data];
            while ([self.inputStream hasBytesAvailable]) {
                NSMutableData *incomingData = [NSMutableData dataWithLength:kBufferSize];
                
                NSInteger readBytes = [self.inputStream read:(uint8_t *)incomingData.bytes
                                                   maxLength:kBufferSize];
                
                [self logData:@"Read Bytes:%zd", readBytes];
                
                if (readBytes <= 0) {
                    [self onDisconnectedWithError:[self errorWithCode:BTSocketErrorCodeStreamReadFailed]];
                    return;
                }
                
                incomingData.length = readBytes;
                
                [allData appendData:incomingData];
            }
            
            if (allData.length) {
                [self onReceiveData:allData];
            }
            break;
        }
            
        case NSStreamEventEndEncountered:
            [self onDisconnectedWithError:[self errorWithCode:BTSocketErrorCodeStreamEndEncountered]];
            break;
            
        case NSStreamEventErrorOccurred:
        {
            NSDictionary *userInfo;
            if (aStream.streamError) {
                userInfo = @{ BTSocketStreamErrorKey : aStream.streamError };
            }
            [self onDisconnectedWithError:[self errorWithCode:BTSocketErrorCodeStreamErrorOccurred userInfo:userInfo]];
            break;
        }
            
        case NSStreamEventNone:
            break;
            
        default:
            break;
    }
}

- (BOOL)evaluateTrust:(SecTrustRef)trust
{
    BOOL shouldAttach = [self.delegate respondsToSelector:@selector(socket:shouldAttachAnchorCertificate:)];
    if (!self.hasAttachedAnchorCertificates && shouldAttach){
        [self.delegate socket:self shouldAttachAnchorCertificate:trust];
        self.hasAttachedAnchorCertificates = YES;
    }

    BOOL shouldEvaluate = [self.delegate respondsToSelector:@selector(socket:shouldValidateTrust:)];
    if (shouldEvaluate){
        BOOL success = [self.delegate socket:self shouldValidateTrust:trust];
        if (!success){
            return NO;
        }
    }
    return YES;
}

#pragma mark - Utilities

- (void)logData:(NSString *)formatString, ...
{
    if (!self.debugMode) {
        return;
    }
    
    va_list vaArguments;
    va_start(vaArguments, formatString);
    NSString *logString = [[NSString alloc] initWithFormat:formatString arguments:vaArguments];
    va_end(vaArguments);
    
    NSLog(@"[%@]: %@", self, logString);
}

- (NSError *)errorWithCode:(BTSocketErrorCode)code
{
    return [self errorWithCode:code userInfo:nil];
}

- (NSError *)errorWithCode:(BTSocketErrorCode)code userInfo:(NSDictionary *)userInfo
{
    return [NSError errorWithDomain:BTSocketErrorDomain code:code userInfo:userInfo];
}

- (BTSocketState)state
{
    BTSocketState inputState = [self connectionStateForStream:self.inputStream];
    BTSocketState outputState = [self connectionStateForStream:self.outputStream];
    NSParameterAssert(inputState == outputState);

    if (inputState == BTSocketStateNotConnected || outputState == BTSocketStateNotConnected){
        return BTSocketStateNotConnected;
    }

    if (inputState == BTSocketStateConnecting || outputState == BTSocketStateConnecting){
        return BTSocketStateConnecting;
    }

    if (inputState == BTSocketStateConnected && outputState == BTSocketStateConnected){
        return BTSocketStateConnected;
    }

    NSParameterAssert(NO);
    return BTSocketStateNotConnected;
}

- (BTSocketState)connectionStateForStream:(NSStream *)stream
{
    if (stream == nil){
        return BTSocketStateNotConnected;
    }

    switch (stream.streamStatus) {
        case NSStreamStatusOpening:
            return BTSocketStateConnecting;
        case NSStreamStatusOpen:
        case NSStreamStatusReading:
        case NSStreamStatusWriting:
        case NSStreamStatusAtEnd:
            return BTSocketStateConnected;
        case NSStreamStatusNotOpen:
        case NSStreamStatusClosed:
        case NSStreamStatusError:
            return BTSocketStateNotConnected;
    }
}

#pragma mark - Core Foundation Wrapper (Facilitate Testing)

- (void)cf_createStreamPairWithHostname:(NSString *)hostname
                                   port:(NSString *)port
                            inputStream:(NSInputStream **)inputStream
                           outputStream:(NSOutputStream **)outputStream
{
    NSParameterAssert(hostname.length && port.length && inputStream && outputStream);

    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    uint32_t portValue = (uint32_t)[port integerValue];
    
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)hostname, portValue, &readStream, &writeStream);
    CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
    CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);

    *inputStream = (__bridge_transfer NSInputStream *)readStream;
    *outputStream = (__bridge_transfer NSOutputStream *)writeStream;
}

- (BOOL)cf_applySSLSettings:(NSDictionary *)SSLSettings
             forInputStream:(NSInputStream *)inputStream
               outputStream:(NSOutputStream *)outputStream
{
    NSParameterAssert(SSLSettings && inputStream && outputStream);

    BOOL r1 = CFReadStreamSetProperty((__bridge CFReadStreamRef)inputStream,
                                      kCFStreamPropertySSLSettings,
                                      (__bridge CFTypeRef)(SSLSettings));
    
    BOOL r2 = CFWriteStreamSetProperty((__bridge CFWriteStreamRef)outputStream,
                                       kCFStreamPropertySSLSettings,
                                       (__bridge CFTypeRef)(SSLSettings));
    return r1 && r2;
}

- (void)cf_applySocketSettingsForInputStream:(NSInputStream *)inputStream
                                outputStream:(NSOutputStream *)outputStream
{
    NSParameterAssert(inputStream && outputStream);
    {
        CFSocketNativeHandle socket;
        CFDataRef socketData = CFReadStreamCopyProperty((__bridge CFReadStreamRef)(inputStream),
                                                        kCFStreamPropertySocketNativeHandle);
        CFDataGetBytes(socketData, CFRangeMake(0, sizeof(CFSocketNativeHandle)), (UInt8 *)&socket);
        CFRelease(socketData);
        
        if (setsockopt(socket, SOL_SOCKET, SO_KEEPALIVE, &(int){ 1 }, sizeof(int)) == -1) {
            [self logData:@"setsockopt (SO_KEEPALIVE) failed: %s", strerror(errno)];
        }
    }
    
    {
        CFSocketNativeHandle socket;
        CFDataRef socketData = CFWriteStreamCopyProperty((__bridge CFWriteStreamRef)(outputStream),
                                                         kCFStreamPropertySocketNativeHandle);
        CFDataGetBytes(socketData, CFRangeMake(0, sizeof(CFSocketNativeHandle)), (UInt8 *)&socket);
        CFRelease(socketData);
        
        if (setsockopt(socket, IPPROTO_TCP, TCP_NODELAY, &(int){ 1 }, sizeof(int)) == -1) {
            [self logData:@"setsockopt (TCP_NODELAY) failed: %s", strerror(errno)];
        }
    }
}

- (struct sockaddr_storage)cf_socketAddressForInputStream:(NSInputStream *)inputStream
{
    NSParameterAssert(inputStream);
    
    CFSocketNativeHandle socket;
    
    CFDataRef socketData = CFReadStreamCopyProperty((__bridge CFReadStreamRef)(inputStream),
                                                    kCFStreamPropertySocketNativeHandle);
    CFDataGetBytes(socketData, CFRangeMake(0, sizeof(CFSocketNativeHandle)), (UInt8 *)&socket);
    
    CFSocketRef s = CFSocketCreateWithNative(NULL, socket, 0, NULL, NULL);
    CFDataRef address = CFSocketCopyPeerAddress(s);
    
    struct sockaddr_storage *pSockAddr = (struct sockaddr_storage *)CFDataGetBytePtr(address);
    
    CFRelease(address);
    CFRelease(s);
    CFRelease(socketData);
    
    return *pSockAddr;
}

@end
