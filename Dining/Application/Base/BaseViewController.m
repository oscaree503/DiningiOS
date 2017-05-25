//
//  BaseViewController.m
//  Marqoo
//
//  Created by admin on 11/30/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import "BaseViewController.h"


@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initBaseUI];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init
- (void)initBaseUI {
    // if(!appController.isCustomLayoutSet) {
    [commonUtils customizeTabBar:self];
//    appController.isCustomLayoutSet = YES;
    // }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Button Events
-(IBAction)onClickHome:(id)sender{
    
//    HomeViewController *homeVC = [ self.storyboard instantiateViewControllerWithIdentifier:@"homeID"];
//    [ self.navigationController setViewControllers:[[NSArray alloc] initWithObjects: homeVC,nil]];
    
    // Alarm * alarm =   [Alarm objectFromDictionary:notification.userInfo];
    
//    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    UINavigationController * navController = [storyBoard instantiateViewControllerWithIdentifier:@"FirstNavigationController"];
//    
//    TimeSetViewController * timesetController = [storyBoard instantiateViewControllerWithIdentifier:@"timesetID"];
//    timesetController.showMovieFlag = YES;
//    // timesetController.showAlarm = alarm;
//    [navController setViewControllers:@[timesetController]];
//    [self.window setRootViewController:navController];
    
}
-(IBAction)onClickMyvideos:(id)sender{
//    MyVideosViewController *myvideosVC = [ self.storyboard instantiateViewControllerWithIdentifier:@"myvideosID"];
//    [ self.navigationController setViewControllers:[[NSArray alloc] initWithObjects: myvideosVC,nil]];
    
}
-(IBAction)onClickProfile:(id)sender{
//    ProfileViewController *profileVC = [ self.storyboard instantiateViewControllerWithIdentifier:@"profileID"];
//    [ self.navigationController setViewControllers:[[NSArray alloc] initWithObjects: profileVC,nil]];

    
}
-(IBAction)onClickSearch:(id)sender{
//    SearchViewController *searchVC = [ self.storyboard instantiateViewControllerWithIdentifier:@"searchID"];
//    [ self.navigationController setViewControllers:[[NSArray alloc] initWithObjects: searchVC,nil]];

}

- (IBAction)menuBackClicked:(id)sender {
//    if(self.isLoadingBase) return;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)goPushView:(NSString*)viewid {
    
    UIViewController *pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:viewid];
    [self.navigationController pushViewController:pageViewController animated:YES];
}

-(void)goMainTabView {
    
    UIViewController *mainTabController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainNav"];
    [self.navigationController presentViewController:mainTabController animated:YES completion:nil];
}
@end
