//
//  FactsNavigationController.m
//  Facts
//
//  Created by Javier Berlana on 06/10/14.
//  Copyright (c) 2014 Javier Berlana. All rights reserved.
//

#import "FactsNavigationController.h"

@interface FactsNavigationController ()

@end

@implementation FactsNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self makeNavigationControllerTransparent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)makeNavigationControllerTransparent
{
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.translucent = YES;
    self.view.backgroundColor      = [UIColor clearColor];
    self.navigationBar.tintColor   = [UIColor whiteColor];
}

@end
