//
//  BTFileService.m
//  BTFoundation
//
//  Created by garena on 5/11/14.
//  Copyright (c) 2014 garena. All rights reserved.
//

#import "BTFileService.h"

@interface BTFileService()

@property (nonatomic, strong) dispatch_queue_t fileQueue;
@property (nonatomic, strong, readwrite) NSString *directory;

@end

@implementation BTFileService

- (id)init
{
    self = [super init];
    if (self) {
        //Concurrent queue to allow single writer and multiple reads
        //https://www.mikeash.com/pyblog/friday-qa-2011-10-14-whats-new-in-gcd.html
        self.fileQueue = dispatch_queue_create("com.btfoundation.filesystem.write", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (id)initWithDirectory:(NSString *)directory
{
    self = [self init];
    if (self) {
        self.directory = directory;
    }
    return self;
}

+ (instancetype)defaultInstance
{
    static BTFileService *fileService;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fileService = [[BTFileService alloc] init];
    });

    return fileService;
}

- (NSString *)directoryPathForPath:(NSString *)path
{
    if (self.directory.length == 0) {
        return path;
    }

    return [self.directory stringByAppendingPathComponent:path];
}

- (NSString *)baseDocumentDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSString *)baseCacheDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSString *)documentDirectory
{
    if (self.directory.length == 0) {
        return [self baseDocumentDirectory];
    }

    return [[self baseDocumentDirectory] stringByAppendingPathComponent:self.directory];
}

- (NSString *)cacheDirectory
{
    if (self.directory.length == 0) {
        return [self baseCacheDirectory];
    }

    return [[self baseCacheDirectory] stringByAppendingPathComponent:self.directory];
}

- (NSString *)documentPathForPath:(NSString *)path
{
    return [[self documentDirectory] stringByAppendingPathComponent:path];
}

- (NSString *)cachePathForPath:(NSString *)path
{
    return [[self cacheDirectory] stringByAppendingPathComponent:path];
}

//Sync writing
- (BOOL)writeToPath:(NSString *)path data:(NSData *)content
{
    __block BOOL success;
    dispatch_barrier_sync(self.fileQueue, ^{
        success = [self syncWriteToFile:path data:content];
    });
    return success;
}

//Async writing
- (void)scheduleWriteToPath:(NSString *)path data:(NSData *)content completion:(BTFileServiceCompletion)completion
{
    dispatch_barrier_async(self.fileQueue, ^{

        BOOL success = [self syncWriteToFile:path data:content];

        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                NSError *error;
                if (!success) {
                    error = [NSError errorWithDomain:@"com.btfoundation.fileservice" code:99 userInfo:nil];
                }
                completion(error);
            }
        });
    });
}

//Sync reading
- (NSData *)loadFromPath:(NSString *)path
{
    __block NSData *data;
    dispatch_sync(self.fileQueue, ^{
        data = [NSData dataWithContentsOfFile:path];
    });

    return data;
}

//Async reading
- (void)loadFromPath:(NSString *)path completion:(BTFileServiceReadCompletion)completion
{
    dispatch_async(self.fileQueue, ^{
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(data, nil);
            }
        });
    });
}

// Sync deleting
- (BOOL)deleteFromPath:(NSString *)path
{
    __block NSError *error;
    dispatch_barrier_sync(self.fileQueue, ^{
        error = [self syncDeleteFromPath:path];
    });
    
    return (error == nil);
}

//Async Deleting
- (void)deleteFromPath:(NSString *)path completion:(BTFileServiceCompletion)completion
{
    dispatch_barrier_async(self.fileQueue, ^{
        NSError *error = [self syncDeleteFromPath:path];

        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(error);
            }
        });
    });
}

#pragma private methods

- (BOOL)syncWriteToFile:(NSString *)path data:(NSData *)content
{
    //If no content, we try to delete the path
    if (!content) {
        [self syncDeleteFromPath:path];
        return YES;
    }

    NSString *pathWithoutFile = [path stringByDeletingLastPathComponent];

    BOOL directoryExists = [[NSFileManager defaultManager] fileExistsAtPath:pathWithoutFile];

    if (!directoryExists) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:pathWithoutFile
                                  withIntermediateDirectories:YES
                                                   attributes:nil error:&error];
        if (error) {
            NSAssert(NO,@"Error writing to file.Unable to create directory:%@",error);
            return NO;
        }
    }

    BOOL success = [content writeToFile:path atomically:NO];
    return success;
}

- (NSError *)syncDeleteFromPath:(NSString *)path
{
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];

    if (error) {
        NSLog(@"Error deletingPath:%@ error:%@", path, error);
    }
    return error;
}

@end
