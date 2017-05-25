//
//  BaseViewController.h
//  Marqoo
//
//  Created by admin on 11/30/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (IBAction)onClickHome:(id)sender;
- (IBAction)onClickSearch:(id)sender;
- (IBAction)onClickMyvideos:(id)sender;
- (IBAction)onClickProfile:(id)sender;
- (IBAction)menuBackClicked:(id)sender;
//-(IBAction)goMainTabView:(id)sender;

-(void)goMainTabView;
-(void)goPushView:(NSString*)viewid;


- (void)initBaseUI;

@property (nonatomic, assign) BOOL isLoadingUserBase;

@end
