//
//  BLoginNavigationController.m
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.
//

#import "BLoginNavigationController.h"
#import "BLoginNavigationAnimator.h"
#import "BLoginNavigationAnimationProtocol.h"

@interface BLoginNavigationController () <UINavigationControllerDelegate>

@property (strong, nonatomic) BLoginNavigationAnimator *animator;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation BLoginNavigationController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.animator = [[BLoginNavigationAnimator alloc] init];
    self.delegate = self;
    self.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    
    if (![fromVC conformsToProtocol:@protocol(BLoginNavigationAnimationProtocol)] || ![toVC conformsToProtocol:@protocol(BLoginNavigationAnimationProtocol)]) {
        return nil;
    }
    
    if (operation == UINavigationControllerOperationPush ||
        operation == UINavigationControllerOperationPop) {
        self.animator.isPush = (operation == UINavigationControllerOperationPush);
        return self.animator;
    }
    
    return nil;
}

@end
