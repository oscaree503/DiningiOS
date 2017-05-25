//
//  EmailSignUpViewController.m
//  Dining
//
//  Created by Polaris on 12/11/15.
//  Copyright (c) 2015 Polaris. All rights reserved.
//

#import "EmailSignUpViewController.h"

@interface EmailSignUpViewController ()<UITextFieldDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    BOOL noCamera, isUserPhotoChanged;
}

@property (strong, nonatomic) IBOutlet UIView *contentEditPhotoView;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIButton *btnCreateAccount;
@property (strong, nonatomic) IBOutlet UIImageView *imgUserPhoto;
@property (strong, nonatomic) IBOutlet UIImageView *imgCamera;

@property (strong, nonatomic) IBOutlet UITextField *txtGender;
@property (strong, nonatomic) IBOutlet UITextField *txtBirthday;
@property (strong, nonatomic) IBOutlet UITextField *txtSchool;
@property (strong, nonatomic) IBOutlet UITextField *txtProfession;

@end

@implementation EmailSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    _scrollView.delegate = self;
    
    _txtGender.delegate = self;
    _txtBirthday.delegate = self;
    _txtSchool.delegate = self;
    _txtProfession.delegate = self;
    
    [commonUtils setRoundedRectView:_btnCreateAccount withCornerRadius:23];
    
    _imgUserPhoto.layer.cornerRadius = _imgUserPhoto.frame.size.height/2.0f;
    _imgUserPhoto.layer.masksToBounds = YES;
    _imgUserPhoto.layer.borderWidth = 1;
    _imgUserPhoto.layer.borderColor = [RGBA(255, 0, 0, 1) CGColor];
    
    noCamera = NO;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        noCamera = YES;
    }


    
}
- (IBAction)onCreateAccount:(id)sender {
    
//    appController.user_input setValue: forKey:<#(NSString *)#>
    if (!self.isLoadingUserBase){
        
        self.isLoadingUserBase = YES;
        [commonUtils showActivityIndicatorColored:self.view];

        [appController.current_user setValue:_txtBirthday.text forKey:@"user_birthday"];
        [appController.current_user setValue:_txtGender.text forKey:@"user_gender"];
        [appController.current_user  setValue:_txtProfession.text forKey:@"user_profession"];
        [appController.current_user setValue:_txtSchool.text forKey:@"user_school"];
        
        PFUser *user;
        user = [PFUser user];
        
        user.username = [appController.current_user objectForKey:@"user_email"];
        user.password = [appController.current_user objectForKey:@"user_password"];
        user.email = [appController.current_user objectForKey:@"user_email"];
        user[@"fullname"] = [appController.current_user objectForKey:@"user_fullname"];
        
        _txtGender.text = [_txtGender.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if ([[_txtGender.text lowercaseString] isEqualToString:@"male"] || [[_txtGender.text lowercaseString] isEqualToString:@"female"]){
            user[@"gender"] = _txtGender.text;
        } else {
            [appController.vAlert doAlert:@"Notice" body:@"Please input your gender correctly.   Male or Female" duration:1.3f done:^(DoAlertView *alertView){
                self.isLoadingUserBase = NO;
                [commonUtils hideActivityIndicator];
            }];
            return;
        }
        
        user[@"birthdate"] = _txtBirthday.text;
        user[@"school"] = _txtSchool.text;
        user[@"profession"] = _txtProfession.text;

        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMdd_hhmmss"];
        NSString *photoFileName = [NSString stringWithFormat:@"uPhoto_%@", [dateFormatter stringFromDate:[NSDate date]]];
        
        
        photoFileName = [photoFileName stringByAppendingString:@".png"];
//        NSLog(@"%@", photoFileName);
        
        // Save the image to Parse

        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {


            if (!error) {
                
                NSData* data = UIImagePNGRepresentation(_imgUserPhoto.image);
                PFFile *imageFile = [PFFile fileWithName:photoFileName data:data];
                
                [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        user[@"photo"] = imageFile.url;
                        [user saveInBackgroundWithBlock:^(BOOL succeded, NSError *error)
                         {
                             
                             [appController.vAlert doAlert:@"Notice" body:@"Success Sign Up" duration:1.3f done:^(DoAlertView *alertView) {
                                 
                                 [appController.current_user setValue:user.objectId forKey:@"user_objectID"];
                                 [appController.current_user setValue:user[@"photo"] forKey:@"user_photoURL"];
                                 
                                 self.isLoadingUserBase = NO;
                                 [commonUtils hideActivityIndicator];

                             }];
                             [self goPushView:@"confirmemail"];
                             
                         }];
                        NSLog(@"Saved");
                    } else{
                        // Error
                        [appController.vAlert doAlert:@"Notice" body:@"Failure Sign Up. Network connection error!" duration:1.3f done:^(DoAlertView *alertView) {
                            
                            self.isLoadingUserBase = NO;
                            [commonUtils hideActivityIndicator];
                            
                        }];
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
                

                
                
            } else {
                [appController.vAlert doAlert:@"Notice" body:@"Failure Sign Up" duration:1.3f done:^(DoAlertView *alertView) {
                    
                }];
            }
        }];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onPrevBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    
    if (textField == _txtGender){
        [_scrollView setContentOffset:CGPointMake(0, 60) animated:YES];
    }
    if (textField == _txtBirthday){
        [_scrollView setContentOffset:CGPointMake(0, 90) animated:YES];
    }
    if (textField == _txtSchool){
        [_scrollView setContentOffset:CGPointMake(0, 120) animated:YES];
    }
    if (textField == _txtProfession){
        [_scrollView setContentOffset:CGPointMake(0, 150) animated:YES];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)onClickEditPhoto:(id)sender {
//    if(self.isLoadingBase) return;
    
    [self presentSemiView:self.contentEditPhotoView withOptions:@{
                                KNSemiModalOptionKeys.pushParentBack : @(NO),
                                KNSemiModalOptionKeys.parentAlpha : @(0.4),
                                KNSemiModalOptionKeys.animationDuration : @(0.3)
                                                                  }];
}
- (IBAction)onClickEditPhotoChooseLibrary:(id)sender {
    if(self.isLoadingUserBase) return;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)onClickEditPhotoTakePhoto:(id)sender {
    if(self.isLoadingUserBase) return;
    
    if(noCamera) {
        [commonUtils showAlert:@"Warning" withMessage:@"Your device has no camera"];
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}
- (IBAction)onClickEditPhotoCancel:(id)sender {
    [self dismissSemiModalView];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
//    appController.editProfileImage = info[UIImagePickerControllerEditedImage];
    isUserPhotoChanged = YES;
    [picker dismissViewControllerAnimated:NO completion:NULL];
    [self dismissSemiModalView];
    
    [_imgCamera setHidden:YES];
//    [self setTopView];
    
    [self.imgUserPhoto setImage:info[UIImagePickerControllerEditedImage]];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
