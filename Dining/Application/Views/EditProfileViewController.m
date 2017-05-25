//
//  EditProfileViewController.m
//  Dining
//
//  Created by Polaris on 1/12/16.
//  Copyright (c) 2016 Polaris. All rights reserved.
//

#import "EditProfileViewController.h"

@interface EditProfileViewController () <UIScrollViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

@property (strong, nonatomic) IBOutlet UIImageView *imgUserPhoto;

@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtBirthday;
@property (strong, nonatomic) IBOutlet UITextField *txtSchool;
@property (strong, nonatomic) IBOutlet UITextField *txtProfession;

@property (strong, nonatomic) IBOutlet UIButton *btnUpdate;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [commonUtils setRoundedRectView:_btnUpdate withCornerRadius:18];
    
    _txtName.delegate = self;
    _txtBirthday.delegate = self;
    _txtSchool.delegate = self;
    _txtProfession.delegate = self;
    
    _txtName.text = appController.current_user[@"user_fullname"];
    _txtEmail.text = appController.current_user[@"user_email"];
    _txtBirthday.text = appController.current_user[@"user_birthday"];
    _txtSchool.text = appController.current_user[@"user_school"];
    _txtProfession.text = appController.current_user[@"user_profession"];

    [_imgUserPhoto setImageWithURL:[NSURL URLWithString:[appController.current_user objectForKey:@"user_photoURL"]]];
    
    [_txtEmail setEnabled:NO];
    
    [commonUtils cropCircleImage:_imgUserPhoto];
    
//    [self performSelectorOnMainThread:@selector(read_LikePostData) withObject:nil waitUntilDone:YES];
    
}
- (IBAction)onUpdateBtn:(id)sender {
    PFQuery *query = [PFUser query];
    PFUser *userAgain = (PFUser *)[query getObjectWithId:[appController.current_user objectForKey:@"user_objectID"]];
    
    userAgain[@"fullname"] = _txtName.text;
    userAgain[@"birthdate"] = _txtBirthday.text;
    userAgain[@"school"] = _txtSchool.text;
    userAgain[@"profession"] = _txtProfession.text;
    
    // This will throw an exception, since the PFUser is not authenticated
    [appController.vAlert doAlert:@"Notice" body:@"Your information will be changed" duration:1.0f done:^(DoAlertView *alertView) {
        
    }];
    
    [userAgain save];
    
    [appController.current_user setValue:_txtName.text forKey:@"user_fullname"];
    [appController.current_user setValue:_txtBirthday.text forKey:@"user_birthday"];
    [appController.current_user setValue:_txtSchool.text forKey:@"user_school"];
    [appController.current_user  setValue:_txtProfession.text forKey:@"user_profession"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)read_LikePostData {
    
//    PFQuery *query = [PFQuery queryWithClassName:@"FoodLike"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *err){
//        
//    }];

    
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
    
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    float offset;
    if (textField == _txtBirthday) {
        offset = 30;
    } else if (textField == _txtSchool) {
        offset = 50.0;
    } else if (textField == _txtProfession){
        offset = 100.0;
    }
    
    [_scrollview setContentOffset:CGPointMake(0, offset) animated:YES];
    
    return YES;
}

@end
