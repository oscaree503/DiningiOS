//
//  FindFrinedsViewController.m
//  Dining
//
//  Created by Polaris on 12/23/15.
//  Copyright (c) 2015 Polaris. All rights reserved.
//

#import "FindFrinedsViewController.h"
#import "FindFriendTableViewCell.h"

@interface FindFrinedsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableviewFindFriends;

@end

@implementation FindFrinedsViewController{
//    NSArray *all_users;
//    NSMutableArray *following, *follow_count;
    NSMutableArray *follow_table;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableviewFindFriends.dataSource = self;
    _tableviewFindFriends.delegate = self;
    
    follow_table = [[NSMutableArray alloc] init];
//    following = [[NSMutableArray alloc] init];
//    follow_count = [[NSMutableArray alloc] init];
    
    [self loadFollow];

}
-(void)loadFollow{
    
    PFQuery *follow_query = [PFQuery queryWithClassName:@"Follow"];
    follow_table = [follow_query findObjects];
    
//    for (PFObject *item in follow_table) {
//        if ([[item objectForKey:@"ToID"] isEqualToString:[appController.current_user objectForKey:@"user_objectID"]]) {
//            [following addObject:@"1"];
//            break;
//        }
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [appController.allUser_data count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FindFriendTableViewCell *cell = (FindFriendTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"findFriendCell"];
    
    PFUser *item_user;
        
    item_user = [appController.allUser_data objectAtIndex:indexPath.row];
        
    [cell.imgFriends setImageWithURL:[NSURL URLWithString:item_user[@"photo"]]];
    cell.lblFriendName.text = item_user[@"fullname"];
    
    NSString *following_state = @"0";
    
    for (PFObject *item in follow_table) {
        if ([[item objectForKey:@"ToID"] isEqualToString:[appController.current_user objectForKey:@"user_objectID"]] && [[item objectForKey:@"FromID"] isEqualToString:item_user.objectId]) {
            following_state = @"1";
            break;
        }
    }
    
    if ([following_state isEqualToString:@"0"]) {
        cell.btnFollow.imageView.image = [UIImage imageNamed:@"follow"];
        [cell.btnFollow setTitle:@"  FOLLOW" forState:UIControlStateNormal];
        [cell.btnFollow setBackgroundColor:RGBA(165, 213, 78, 0)];
        [commonUtils setRoundedRectBorderButton:cell.btnFollow withBorderWidth:2 withBorderColor:RGBA(255, 129, 98, 1) withBorderRadius:15];
    } else {
        [cell.btnFollow setImage:[UIImage imageNamed:@"follow_select"] forState:UIControlStateNormal];
        [cell.btnFollow setTitle:@"  FOLLOWING" forState:UIControlStateNormal];
        [cell.btnFollow setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
        [cell.btnFollow setBackgroundColor:RGBA(165, 213, 78, 1)];
        [commonUtils setRoundedRectBorderButton:cell.btnFollow withBorderWidth:2 withBorderColor:RGBA(165, 213, 78, 1) withBorderRadius:15];
    }
    
    int following_count = 0;
    
    for (PFObject *item in follow_table) {
        if ([[item objectForKey:@"ToID"] isEqualToString:item_user.objectId]) {
            following_count ++;
        }
    }

    cell.lblFollowCount.text = [@"Follower   " stringByAppendingString:[NSString stringWithFormat:@"%d", following_count]];
    
    
    [cell.btnFollow setTag:indexPath.row];
    
    return cell;
}

- (IBAction)onFollow:(id)sender {
    
    PFObject *followFriend = [PFObject objectWithClassName:@"Follow"];
    followFriend[@"FromID"] = [appController.current_user objectForKey:@"user_objectID"];
    PFUser *followUser = [appController.allUser_data objectAtIndex:[sender tag]];
    
    followFriend[@"ToID"] = followUser.objectId;
    
    NSString *alert = [@"You followed " stringByAppendingString:followUser[@"fullname"]];
    
    [followFriend saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
            [appController.vAlert doAlert:@"Notice" body:alert duration:1.3f done:^(DoAlertView *alertView) {
            }];
            
        } else {
            [appController.vAlert doAlert:@"Notice" body:@"Connection error!" duration:1.3f done:^(DoAlertView *alertView) {
            }];
        }
    }];
}


- (IBAction)onBackBtn:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

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
