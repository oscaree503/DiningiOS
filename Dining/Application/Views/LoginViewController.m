//
//  LoginViewController.m
//  Dining
//
//  Created by Polaris on 12/11/15.
//  Copyright (c) 2015 Polaris. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController () <UIScrollViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UITextField *txtFirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;

@property (strong, nonatomic) IBOutlet UIButton *btnFacebook;
@property (strong, nonatomic) IBOutlet UIButton *btnInstagram;
@property (strong, nonatomic) IBOutlet UIButton *btnEmail;
@property (strong, nonatomic) IBOutlet UIButton *btnPhone;

@property (strong, nonatomic) IBOutlet UIButton *btnEmailLogin;

@property (strong, nonatomic) IBOutlet UIView *viewSignUp;
@property (strong, nonatomic) IBOutlet UIView *viewSignin;

@property (strong, nonatomic) IBOutlet UIButton *btnSignUp;
@property (strong, nonatomic) IBOutlet UIButton *btnSignIn;

@property (strong, nonatomic) IBOutlet UITextField *txtLoginEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtLoginPassword;

@property (strong, nonatomic) IBOutlet UIButton *btnNext;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _scrollView.delegate = self;
    
    _txtFirstName.delegate = self;
    _txtLastName.delegate = self;
    _txtEmail.delegate = self;
    _txtPassword.delegate = self;
    _txtLoginPassword.delegate = self;
    
    [commonUtils setRoundedRectView:_btnFacebook withCornerRadius:20];
    [commonUtils setRoundedRectView:_btnInstagram withCornerRadius:20];
    
    
    [commonUtils setRoundedRectBorderButton:_btnEmail withBorderWidth:2 withBorderColor:RGBA(200, 200, 200, 1) withBorderRadius:20];
    
    
    [commonUtils setRoundedRectBorderButton:_btnEmailLogin withBorderWidth:2 withBorderColor:RGBA(200, 200, 200, 1) withBorderRadius:20];
    
    [commonUtils setRoundedRectBorderButton:_btnPhone withBorderWidth:2 withBorderColor:RGBA(200, 200, 200, 1) withBorderRadius:20];
    

    
    if (appController.isSignUp == 1){
        [_viewSignin setHidden:NO];
        [_viewSignUp setHidden:YES];
        [_btnSignIn setAlpha:1];
        [_btnSignUp setAlpha:0.3];

    }
}
- (IBAction)onPrevBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onNextBtn:(id)sender {
    
    NSString *pass, *email;
    pass = _txtPassword.text;
    email = _txtEmail.text;
    
    if ([pass isEqualToString:@""] || [email isEqualToString:@""]){
        [appController.vAlert doAlert:@"Notice" body:@"Please fill your Email and Password!" duration:1.3f done:^(DoAlertView *alertView){
            self.isLoadingUserBase = NO;
            [commonUtils hideActivityIndicator];
        }];
    } else {
    
        UINavigationController *pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"createaccount"];
        [self.navigationController pushViewController:pageViewController animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSignBtn:(id)sender {
    
    if ([sender tag] == 0){
        [_viewSignUp setHidden:NO];
        [_viewSignin setHidden:YES];
        [_btnSignIn setAlpha:0.3];
        [_btnNext setHidden:NO];
    } else {
        [_viewSignUp setHidden:YES];
        [_viewSignin setHidden:NO];
        [_btnSignUp setAlpha:0.3];
        [_btnNext setHidden:YES];

    }
    
    [sender setAlpha:1];
    
}



- (IBAction)onEmailSignUpBtn:(id)sender {
    
    if (!self.isLoadingUserBase){
        self.isLoadingUserBase = YES;
        [commonUtils showActivityIndicatorColored:self.view];
        
        NSString *user_email, *user_password;
        
        user_email = _txtEmail.text;
        user_password = _txtPassword.text;
        
        if ( [user_email isEqualToString:@""] || [user_password isEqualToString:@""] ){
            
            [appController.vAlert doAlert:@"Notice" body:@"Please fill your Email and Password!" duration:1.3f done:^(DoAlertView *alertView){
                self.isLoadingUserBase = NO;
                [commonUtils hideActivityIndicator];
            }];
            
        } else {
            
            NSString *user_fullname = [NSString stringWithFormat:@"%@ %@", _txtFirstName.text, _txtLastName.text];
            
//            appController.user_input = @{ @"username" : _txtEmail.text,
//                                          @"password" : _txtPassword.text,
//                                          @"email" : _txtEmail.text,
//                                          @"fullname" : user_fullname
//                                          };
            
            [appController.current_user setValue:_txtPassword.text forKey:@"user_password"];
            [appController.current_user setValue:_txtEmail.text forKey:@"user_email"];
            [appController.current_user setValue:user_fullname forKey:@"user_fullname"];
         
            UIViewController *pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"createaccount"];
            [self.navigationController pushViewController:pageViewController animated:YES];
            
        }
    } 
}

- (IBAction)onEmailSignInBtn:(id)sender {
    
    if (!self.isLoadingUserBase){
        
        self.isLoadingUserBase = YES;
        [commonUtils showActivityIndicatorColored:self.view];

        NSString *user_email, *user_password;
    
        user_email = _txtLoginEmail.text;
        user_password = _txtLoginPassword.text;
        
        if ( [user_email isEqualToString:@""] || [user_password isEqualToString:@""] ){
            
            [appController.vAlert doAlert:@"Notice" body:@"Please fill your Email and Password!" duration:1.3f done:^(DoAlertView *alertView){
                self.isLoadingUserBase = NO;
                [commonUtils hideActivityIndicator];
            }];
            
        } else {
            
            [PFUser logInWithUsernameInBackground:user_email password:user_password
                                    block:^(PFUser *user, NSError *error) {
                                        
                                        self.isLoadingUserBase = NO;
                                        [commonUtils hideActivityIndicator];
                                        
                                        if (user) {
                                            
                                            [appController.current_user setValue:user.objectId forKey:@"user_objectID"];
                                            [appController.current_user setValue:user[@"photo"] forKey:@"user_photoURL"];
                                            [appController.current_user setValue:user.username forKey:@"user_email"];
                                            [appController.current_user setValue:user[@"fullname"] forKey:@"user_fullname"];
                                            [appController.current_user setValue:user[@"photo"] forKey:@"user_photoURL"];
                                            [appController.current_user setValue:user[@"birthdate"] forKey:@"user_birthday"];
                                            [appController.current_user setValue:user[@"gender"] forKey:@"user_gender"];
                                            [appController.current_user setValue:user[@"profession"] forKey:@"user_profession"];
                                            [appController.current_user setValue:user[@"school"] forKey:@"user_school"];
                                            
                                            [appController.vAlert doAlert:@"Notice" body:@"Success Sign In" duration:1.3f done:^(DoAlertView *alertView) {
                                            }];
                                            
                                            
                                            [self goMainTabView];
                                            
                                        } else {
                                            
                                            [appController.vAlert doAlert:@"Notice" body:@"Failure Sign In" duration:1.3f done:^(DoAlertView *alertView) {
                                            }];

                                        }
                                    }];
        }
    }
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark --- textfield Delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    if (textField == _txtEmail){
        [_scrollView setContentOffset:CGPointMake(0, 60) animated:YES];
    }
    if (textField == _txtPassword){
        [_scrollView setContentOffset:CGPointMake(0, 170) animated:YES];
    }
    
//    if (textField == _txtLoginPassword) {
//        [_scrollView setContentOffset:CGPointMake(0, 100) animated:YES];
//    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}





@end
