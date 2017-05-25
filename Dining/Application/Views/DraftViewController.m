//
//  DraftViewController.m
//  Dining
//
//  Created by Polaris on 1/12/16.
//  Copyright (c) 2016 Polaris. All rights reserved.
//

#import "DraftViewController.h"

@interface DraftViewController ()

@property (strong, nonatomic) IBOutlet UITextView *txtViewFoodReview;
@end

@implementation DraftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                     action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}
- (IBAction)onBackBtn:(id)sender {
    appController.user_foodReview = _txtViewFoodReview.text;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dismissKeyboard {
    [_txtViewFoodReview resignFirstResponder];
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
