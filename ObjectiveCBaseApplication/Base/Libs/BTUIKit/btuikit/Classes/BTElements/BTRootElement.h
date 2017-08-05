//
//  BTRootElement.h
//  BeeTalk
//
//  Created by Lee Sing Jie on 28/2/13.
//  Copyright (c) 2013 Garena. All rights reserved.
//

#import "BTElement.h"

@interface BTRootElement : BTElement

@property (nonatomic, strong) NSArray *sections;

- (NSInteger)numberOfSections;

- (NSInteger)numberOfRowsInSection:(NSInteger)section;

- (NSString *)titleForHeaderInSection:(NSInteger)section;
- (NSString *)titleForFooterInSection:(NSInteger)section;

/**
Find the first section/row element with given key
*/
- (BTElement *)elementForKey:(NSString *)key;

@end
