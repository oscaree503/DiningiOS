//
//  EnterCodeViewController.m
//  Dining
//
//  Created by Polaris on 12/20/15.
//  Copyright (c) 2015 Polaris. All rights reserved.
//

#import "EnterCodeViewController.h"
#import <MessageUI/MFMessageComposeViewController.h>

@interface EnterCodeViewController ()<UITextFieldDelegate, MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *btnContinue;

@property (strong, nonatomic) IBOutlet UITextField *txtFirst;
@property (strong, nonatomic) IBOutlet UITextField *txtSecond;
@property (strong, nonatomic) IBOutlet UITextField *txtThird;
@property (strong, nonatomic) IBOutlet UITextField *txtFourth;

@property (strong, nonatomic) IBOutlet UILabel *lblUnderlineFirst;
@property (strong, nonatomic) IBOutlet UILabel *lblUnerlineSecond;
@property (strong, nonatomic) IBOutlet UILabel *lblUnderlineThird;
@property (strong, nonatomic) IBOutlet UILabel *lblUnderlineFourth;

@property (strong, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@end

@implementation EnterCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [commonUtils setRoundedRectView:_btnContinue withCornerRadius:22];
    
    _txtFirst.delegate = self;
    _txtSecond.delegate = self;
    _txtThird.delegate = self;
    _txtFourth.delegate = self;
    
    [_txtFirst becomeFirstResponder];
    
    [_lblUnderlineFirst setBackgroundColor:RGBA(200, 200, 200, 1)];
    [self sendSMS];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)sendSMS{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = @"3579";
        controller.recipients = [NSArray arrayWithObject:_txtPhoneNumber.text];
        controller.messageComposeDelegate = self;
        [self presentModalViewController:controller animated:YES];
    }
}


- (IBAction)onContinueBtn:(id)sender {
    if ([_txtPhoneNumber.text isEqualToString:@""] || ([_txtPhoneNumber.text length] < 8) ) {
        [appController.vAlert doAlert:@"Notice" body:@"Please fill Phone Number correctly." duration:1.3f done:^(DoAlertView *alertView) {
            
        }];
    } else {
    
        NSInteger verifyCode;
        verifyCode = [_txtFirst.text intValue]*1000+[_txtSecond.text intValue]*100+[_txtThird.text intValue]*10+[_txtFourth.text intValue];
        if (verifyCode == 3579){

            [self goMainTabView];
        } else {
            [commonUtils showAlert:@"Error!" withMessage:@"Please input your code from SMS correctly!"];
            self.txtFirst.text = @"";
            self.txtSecond.text = @"";
            self.txtThird.text = @"";
            self.txtFourth.text = @"";
            
            [self.txtFirst becomeFirstResponder];
        }
        
    }
}

#pragma mark  MFMessageComposeViewControllerDelegate
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    [self dismissModalViewControllerAnimated:YES];
    
    if (result == MessageComposeResultCancelled){
        NSLog(@"Message cancelled");
    }
    else if (result == MessageComposeResultSent){
        NSLog(@"Message sent");
    }
    else {
        NSLog(@"Message failed");
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

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField == _txtFirst) {
//        [_lblUnderlineFirst setBackgroundColor:RGBA(223, 108, 63, 1)];
    } else if (textField == _txtSecond) {
        [_lblUnerlineSecond setBackgroundColor:RGBA(223, 108, 63, 1)];
    } else if (textField == _txtThird) {
        [_lblUnderlineThird setBackgroundColor:RGBA(223, 108, 63, 1)];
    } else if (textField == _txtFourth) {
        [_lblUnderlineFourth setBackgroundColor:RGBA(223, 108, 63, 1)];
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ((textField == _txtFirst) && [string length] == 1){
        [_lblUnderlineFirst setBackgroundColor:RGBA(223, 108, 63, 1)];
    }
    if ((textField == _txtFirst) && ([_txtFirst.text length] == 1))  {
//        [_lblUnderlineFirst setBackgroundColor:RGBA(223, 108, 63, 1)];
        [_txtSecond becomeFirstResponder];
    } else if ((textField == _txtSecond) && ([_txtSecond.text length] == 1))  {
//        [_lblUnerlineSecond setBackgroundColor:RGBA(223, 108, 63, 1)];
        [_txtThird becomeFirstResponder];
    } else if ((textField == _txtThird) && ([_txtThird.text length] == 1))  {
//        [_lblUnderlineThird setBackgroundColor:RGBA(223, 108, 63, 1)];
        [_txtFourth becomeFirstResponder];
    } else if ((textField == _txtFourth) && ([_txtFourth.text length] == 0))  {
//        [_lblUnderlineFourth setBackgroundColor:RGBA(223, 108, 63, 1)];
        [textField resignFirstResponder];
    }
    
    if ([_txtFourth.text length] > 0) {
        [_lblUnderlineFourth setBackgroundColor:RGBA(223, 108, 63, 1)];
        [textField resignFirstResponder];
    }
    return YES;
}
//
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    return YES;
//}

@end
