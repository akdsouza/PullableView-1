//
//  ViewController.m
//  PullableView
//
//  Created by Ahmed Henawey on 19/12/2014.
//  Copyright (c) 2014 Ahmed Henawey. All rights reserved.
//

#import "ViewController.h"
#import "PullableView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *pullableViewHeader;
@property (weak, nonatomic) IBOutlet PullableView *slideView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.slideView.minVisiblePoint = CGPointMake(0,self.pullableViewHeader.frame.size.height);

    self.slideView.maxVisiblePoint = CGPointMake(0,self.slideView.frame.size.height);

    self.slideView.headerView = self.pullableViewHeader;

}

@end
