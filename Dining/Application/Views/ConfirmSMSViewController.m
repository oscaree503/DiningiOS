//
//  ConfirmSMSViewController.m
//  Dining
//
//  Created by Polaris on 12/20/15.
//  Copyright (c) 2015 Polaris. All rights reserved.
//

#import "ConfirmSMSViewController.h"

@interface ConfirmSMSViewController ()

@property (strong, nonatomic) IBOutlet UIButton *btnEnterCode;
@property (strong, nonatomic) IBOutlet UIButton *btnResendemail;

@end

@implementation ConfirmSMSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [commonUtils setRoundedRectView:_btnEnterCode withCornerRadius:22];
    [commonUtils setRoundedRectBorderButton:_btnResendemail withBorderWidth:2 withBorderColor:RGBA(150, 150, 150, 1) withBorderRadius:22];
}
//- (IBAction)onEnterCodeBtn:(id)sender {
//    [self goMainTabView:@"entercode"];
//}

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
