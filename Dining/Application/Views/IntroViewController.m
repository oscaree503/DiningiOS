//
//  IntroFirstViewController.m
//  Dining
//
//  Created by Polaris on 12/11/15.
//  Copyright (c) 2015 Polaris. All rights reserved.
//

#import "IntroViewController.h"

@interface IntroViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *btnDirectEnter;
@property (strong, nonatomic) IBOutlet UIButton *btnSignUp;
@property (strong, nonatomic) IBOutlet UIButton *btnLogIn;

@property (strong, nonatomic) IBOutlet UIView *viewFirst;
@property (strong, nonatomic) IBOutlet UIView *viewSecond;
@property (strong, nonatomic) IBOutlet UIView *viewThird;
@property (strong, nonatomic) IBOutlet UIView *viewFourth;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [commonUtils setRoundedRectView:_btnDirectEnter withCornerRadius:30];
    [commonUtils setRoundedRectBorderButton:_btnSignUp withBorderWidth:2 withBorderColor:RGBA(255, 255, 255, 1) withBorderRadius:27];
    [commonUtils setRoundedRectBorderButton:_btnLogIn withBorderWidth:2 withBorderColor:RGBA(255, 255, 255, 1) withBorderRadius:27];
    
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width*4, _scrollView.frame.size.height);
    
    CGRect frame;
    frame.size = _scrollView.frame.size;
    frame.origin.x = 0 ;
    _viewFirst.frame = frame;
    frame.origin.x = _scrollView.frame.size.width;
    _viewSecond.frame = frame;
    frame.origin.x = _scrollView.frame.size.width*2;
    _viewThird.frame = frame;
    frame.origin.x = _scrollView.frame.size.width*3;
    _viewFourth.frame = frame;

    _scrollView.pagingEnabled = YES;
    [_pageControl setHidden:YES];
    
//    NSLog(@"%f", _scrollView.contentOffset.x);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onSignUpBtn:(id)sender {
    appController.isSignUp = 0;
    
    [_btnSignUp setBackgroundColor:RGBA(200, 200, 200, 1)];
    [_btnLogIn setBackgroundColor:[UIColor clearColor]];
}

- (IBAction)onLoginBtn:(id)sender {
    appController.isSignUp = 1;
    [_btnLogIn setBackgroundColor:RGBA(200, 200, 200, 1)];
    [_btnSignUp setBackgroundColor:[UIColor clearColor]];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    NSLog(@"%f", _scrollView.contentOffset.x);

    if (_scrollView.contentOffset.x > _scrollView.frame.size.width - 10){
        [_pageControl setHidden:NO];
    }
    
    if (_scrollView.contentOffset.x == _scrollView.frame.size.width * 3){
        [_pageControl setCurrentPage:2];
    } else if (_scrollView.contentOffset.x == _scrollView.frame.size.width * 2){
        [_pageControl setCurrentPage:1];
    } else if (_scrollView.contentOffset.x == _scrollView.frame.size.width){
        [_pageControl setCurrentPage:0];
    } else if (_scrollView.contentOffset.x < _scrollView.frame.size.width){
        [_pageControl setHidden:YES];
    }
    if (_scrollView.contentOffset.x > _scrollView.frame.size.width * 3) {
        UINavigationController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

@end
