//
//  BLog.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.
//

#import "BLog.h"
#import "UIColor+BAdditions.h"
#import "DDTTYLogger.h"
#import "DDASLLogger.h"

@implementation BLog

+ (void)load
{
#if defined DEBUG
    [DDLog addLogger:[DDTTYLogger sharedInstance] withLevel:BLogLevelAll];
    [DDLog addLogger:[DDASLLogger sharedInstance] withLevel:BLogLevelAll];
    
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor blackColor]
                                     backgroundColor:[UIColor redColor]
                                             forFlag:BLogFlagError];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor blackColor]
                                     backgroundColor:[UIColor orangeColor]
                                             forFlag:BLogFlagWarning];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor brownColor]
                                     backgroundColor:nil
                                             forFlag:BLogFlagInfo];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor blackColor]
                                     backgroundColor:[UIColor b_colorWithHex:@"0081ef"]
                                             forFlag:BLogFlagDebug];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor b_colorWithHex:@"e347ff"] // Dark pink
                                     backgroundColor:nil
                                             forFlag:BLogFlagVerbose];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor b_colorWithHex:@"0ca0b0"] // Dirty blue
                                     backgroundColor:nil
                                             forFlag:BLogFlagNetwork];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor orangeColor]
                                     backgroundColor:nil
                                             forFlag:BLogFlagVCLifeCycle];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor b_colorWithHex:@"ff65ef"] // Light pink
                                     backgroundColor:nil
                                             forFlag:BLogFlagTB];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor b_colorWithHex:@"33a233"] // Dark green
                                     backgroundColor:nil
                                             forFlag:BLogFlagPrinter];
#elif defined INTRELEASE
    [DDLog addLogger:[DDASLLogger sharedInstance] withLevel:BLogLevelAll];
#endif
}

@end
