//
//  MaibTabBarViewController.m
//  Dining
//
//  Created by Polaris on 12/13/15.
//  Copyright (c) 2015 Polaris. All rights reserved.
//

#import "MainTabBarViewController.h"

@interface MainTabBarViewController () <UITabBarControllerDelegate>

@end

@implementation MainTabBarViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    
    [commonUtils customizeTabBar:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
