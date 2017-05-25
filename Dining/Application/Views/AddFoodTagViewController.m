//
//  AddFoodTagViewController.m
//  Dining
//
//  Created by Polaris on 12/24/15.
//  Copyright (c) 2015 Polaris. All rights reserved.
//

#import "AddFoodTagViewController.h"
#import "DWTagList.h"

@interface AddFoodTagViewController ()

@property (strong, nonatomic) IBOutlet UIView *viewTags;

@property (strong, nonatomic) IBOutlet UILabel *lblFoodName;

@end

@implementation AddFoodTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    
    DWTagList *tagList;
    
    tagList = [[DWTagList alloc] initWithFrame:_viewTags.frame];
    
    [tagList setTags:appController.mytags];
    [_viewTags addSubview:tagList];
    
    _lblFoodName.text = appController.user_foodName;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onBackBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self goMainTabView:@"shareMain"];
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
