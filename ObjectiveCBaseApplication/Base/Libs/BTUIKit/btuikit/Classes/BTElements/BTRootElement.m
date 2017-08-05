//
//  BTRootElement.m
//  BeeTalk
//
//  Created by Lee Sing Jie on 28/2/13.
//  Copyright (c) 2013 Garena. All rights reserved.
//

#import "BTRootElement.h"

#import "BTSectionElement.h"

@implementation BTRootElement

- (NSInteger)numberOfSections
{
    return [self.sections count];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return [self.sections[section] numberOfRows];
}

- (NSString *)titleForHeaderInSection:(NSInteger)section
{
    BTSectionElement *sectionElement = self.sections[section];

    return sectionElement.headerText;
}

- (NSString *)titleForFooterInSection:(NSInteger)section
{
    BTSectionElement *sectionElement = self.sections[section];
    
    return sectionElement.footerText;
}

- (void)setSections:(NSArray *)sections
{
    _sections = sections;

    self.rootElement = self;

    for (BTSectionElement *section in sections) {
        section.rootElement = self;
        for (BTElement *row in section.rows) {
            row.rootElement = self;
            for (BTElement *child in row.children) {
                child.rootElement = self;
            }
        }
    }
}

- (BTElement *)elementForKey:(NSString *)key
{
    for (BTSectionElement *section in self.sections) {

        if ([section.key isEqualToString:key]) {
            return section;
        }

        BTElement *element = [section elementForKey:key];

        if (element) {
            return element;
        }
    }

    NSLog(@"No element with key found:%@", key);

    return nil;
}

@end
