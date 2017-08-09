//
//  main.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

double CPAppStartupTime = 0.0;

int main(int argc, char * argv[]) {
    
    CPAppStartupTime = CACurrentMediaTime();

    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
