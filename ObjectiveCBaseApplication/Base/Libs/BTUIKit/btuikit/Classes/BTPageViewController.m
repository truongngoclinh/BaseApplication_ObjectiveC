//
//  BTPageViewController.m
//  btuikit
//
//  Created by Ziwei Peng on 25/11/14.
//  Copyright (c) 2014 garena. All rights reserved.
//

#import "BTPageViewController.h"

#import "BTPagedScrollView.h"
#import "BTPageHostSample.h"

@interface BTPageViewController ()

@property (nonatomic, strong) BTPagedScrollView *scrollView;

@end

@implementation BTPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"Paged Scroll View";

    self.scrollView = [[BTPagedScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView.backgroundColor = [UIColor lightGrayColor];
    self.scrollView.insets = UIEdgeInsetsMake(20, 20, 100, 20);
    [self.view addSubview:self.scrollView];

    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        BTPageHostSample *h = [[BTPageHostSample alloc] init];
        h.title = [NSString stringWithFormat:@"This is page %d", i];
        [arr addObject:h];
    }
    self.scrollView.pageHosts = [arr copy];

    self.view.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
