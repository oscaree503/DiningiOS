//
//  ActivityViewController.m
//  Dining
//
//  Created by Polaris on 12/25/15.
//  Copyright (c) 2015 Polaris. All rights reserved.
//

#import "ActivityViewController.h"
#import "NotificationTableViewCell.h"

@interface ActivityViewController ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblUnderline;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UITableView *tableviewNotification;

@property (strong, nonatomic) IBOutlet UIButton *btnMenuMessages;
@property (strong, nonatomic) IBOutlet UIButton *btnMenuNotification;

@property (strong, nonatomic) IBOutlet UIView *viewContent;
@property (strong, nonatomic) IBOutlet UIView *viewMessage;
@property (strong, nonatomic) IBOutlet UIView *viewNotification;

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _scrollView.delegate = self;
    
    _tableviewNotification.dataSource = self;
    _tableviewNotification.delegate = self;
    
}

-(void)viewDidLayoutSubviews{
    
    CGRect frame;
    
    frame = CGRectMake(0, 0, _scrollView.frame.size.width * 3, _scrollView.frame.size.height);
    _viewContent.frame = frame;
    
    _scrollView.contentSize = _viewContent.frame.size;
    
    [_scrollView setPagingEnabled:YES];
    
    frame.size = _scrollView.frame.size;
    frame.origin.x = 0;
    [_viewMessage setFrame:frame];
    
    frame.origin.x = _scrollView.frame.size.width;
    [_viewNotification setFrame:frame];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger nCount;
//    if (tableView == _tableviewNotification){
        nCount = 10;
//    }
    
    return nCount;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *temp_cell;
    
    if (tableView == _tableviewNotification){
        
        NotificationTableViewCell *cell = (NotificationTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"notificationCell"];
        
        [cell.imgPhoto setImage:[UIImage imageNamed:[appController.notification_info objectForKey:@"userPhoto"]]];
        cell.lblUserName.text = [appController.notification_info objectForKey:@"userName"];
        cell.lblPastTime.text = [[[appController.notification_info objectForKey:@"pastTime"] stringValue] stringByAppendingString:@"MIN AGO"];
        cell.lblNotificationContent.text = [appController.notification_info objectForKey:@"notification"];
        
        return cell;
    }
    
    return temp_cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onMenuNotificationBtn:(id)sender {
    [_btnMenuMessages setTitleColor:RGBA(150, 150, 150, 1) forState:UIControlStateNormal];
    [_btnMenuNotification setTitleColor:RGBA(0, 0, 0, 1) forState:UIControlStateNormal];
}
- (IBAction)onMenuMessagesBtn:(id)sender {
    [_btnMenuMessages setTitleColor:RGBA(0, 0, 0, 1) forState:UIControlStateNormal];
    [_btnMenuNotification setTitleColor:RGBA(150, 150, 150, 1) forState:UIControlStateNormal];
}

- (IBAction)onMenuBtn:(id)sender {
    
    int x_offset = [sender tag] * _scrollView.frame.size.width;
    
    [UIView animateWithDuration:.25f animations:^{
        [ _scrollView setContentOffset:CGPointMake(x_offset, 0)];
    }];
    
    if ([sender tag] == 0) {
        
        [UIView animateWithDuration:0.25f animations:^{
            _lblUnderline.frame = CGRectMake(_btnMenuMessages.frame.origin.x-_lblUnderline.frame.size.width/15, _lblUnderline.frame.origin.y, _lblUnderline.frame.size.width  ,_lblUnderline.frame.size.height);
        }];
    } else {
        [UIView animateWithDuration:0.25f animations:^{
            _lblUnderline.frame = CGRectMake(_btnMenuNotification.frame.origin.x-_lblUnderline.frame.size.width/7, _lblUnderline.frame.origin.y, _lblUnderline.frame.size.width  ,_lblUnderline.frame.size.height);
        }];
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

@end
