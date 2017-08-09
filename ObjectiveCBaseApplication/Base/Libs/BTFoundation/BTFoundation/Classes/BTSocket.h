//
//  BTSocket.h
//  BTFoundation
//
//  Created by Andrew Eng on 12/10/15.
//  Copyright © 2015 garena. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const BTSocketErrorDomain;
extern NSString *const BTSocketStreamErrorKey;

typedef NS_ENUM(NSInteger, BTSocketErrorCode)
{
    BTSocketErrorCodeSocketAlreadyOpened  = 1,
    BTSocketErrorCodeInvalidHost          = 2,
    BTSocketErrorCodeSSLSettingsFailed    = 3,

    BTSocketErrorCodeSocketNotOpened      = 4,

    BTSocketErrorCodeStreamReadFailed     = 5,
    BTSocketErrorCodeStreamWriteFailed    = 6,
    BTSocketErrorCodeStreamEndEncountered = 7,
    BTSocketErrorCodeStreamErrorOccurred  = 8,
    BTSocketErrorCodeStreamSSLBadCert     = 9,
};

typedef NS_ENUM(NSInteger, BTSocketState)
{
    BTSocketStateNotConnected = 0,
    BTSocketStateConnecting = 1,
    BTSocketStateConnected = 2,
};

@class BTSocket;
@protocol BTSocketDelegate <NSObject>

/** Called when socket is opened. */
- (void)socketDidConnect:(BTSocket *)socket;

/** Called when socket is closed. */
- (void)socketDidDisconnect:(BTSocket *)socket withError:(NSError *)error;

/** Called when socket receives data. */
- (void)socket:(BTSocket *)socket didReceiveData:(NSData *)data;


@optional;
/**
 @note Only use manual trust verfication if using self-signed CA.
    Use sslSettings property if using known CA.
 */
/** Called once when socket receives trust. */
- (void)socket:(BTSocket *)socket shouldAttachAnchorCertificate:(SecTrustRef)trust;
/** Called when socket receives data. */
- (BOOL)socket:(BTSocket *)socket shouldValidateTrust:(SecTrustRef)trust;

@end

@interface BTSocket : NSObject

@property (nonatomic, assign) BTSocketState state;

/** A dictionary of SSL settings.
 * @note To enable TLS or SSL, set the following key-value:
 * @code @{ NSStreamSocketSecurityLevelKey : NSStreamSocketSecurityLevelNegotiatedSSL } @endcode
 * @see https://developer.apple.com/library/mac/documentation/NetworkingInternetWeb/Conceptual/NetworkingOverview/SecureNetworking/SecureNetworking.html
 * @see kCFStreamPropertySSLSettings */
@property (nonatomic, strong) NSDictionary *sslSettings;

/** Enable logs. */
@property (nonatomic, assign) BOOL debugMode;

- (id)initWithDelegate:(id<BTSocketDelegate>)delegate;

/** @param host <ip/domain>:<port> */
- (void)connectToHost:(NSString *)host error:(NSError **)error;

/** Use to send data after socket is opened. */
- (void)send:(NSData *)data error:(NSError **)error;

/** Disconnect the socket */
- (void)stop;

/** Connected IP address. Only available after socket is connected. */
- (NSString *)connectedIP;

/** Connected port. Only available after socket is connected. */
- (NSString *)connectedPort;

@end
