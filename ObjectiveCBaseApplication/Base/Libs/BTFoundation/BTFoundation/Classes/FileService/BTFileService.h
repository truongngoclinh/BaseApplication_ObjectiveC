//
//  BTFileService.h
//  BTFoundation
//
//  Created by garena on 5/11/14.
//  Copyright (c) 2014 garena. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BTFileServiceCompletion)(NSError *error);
typedef void(^BTFileServiceReadCompletion)(NSData *data, NSError *error);

@interface BTFileService : NSObject

@property (nonatomic, strong,readonly) NSString *directory;

/**
This class can be used as Singleton but it is also safe to instantiate multiple instances of it for different Directories
The defaultInstance will use directory=nil
*/
+ (instancetype)defaultInstance;

/**
All items saved will be in this subDirectory of the respective directories
eg. ~/Documents/{SubDirectory}/{file}
    ~/Library/Cache/{SubDirectory}/{file}
subDirectory can be nil
*/
- (id)initWithDirectory:(NSString *)directory;

- (NSString *)documentDirectory;
- (NSString *)cacheDirectory;

- (NSString *)documentPathForPath:(NSString *)path;
- (NSString *)cachePathForPath:(NSString *)path;

//Sync writing
- (BOOL)writeToPath:(NSString *)path data:(NSData *)content;

//Async writing
- (void)scheduleWriteToPath:(NSString *)path data:(NSData *)content completion:(BTFileServiceCompletion)completion;

//Sync reading
- (NSData *)loadFromPath:(NSString *)path;

//Async reading
- (void)loadFromPath:(NSString *)path completion:(BTFileServiceReadCompletion)completion;

// Sync Delete
- (BOOL)deleteFromPath:(NSString *)path;

//Async Deleting
- (void)deleteFromPath:(NSString *)path completion:(BTFileServiceCompletion)completion;


@end
