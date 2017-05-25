//
//  DiscoverViewController.m
//  Dining
//
//  Created by Polaris on 12/21/15.
//  Copyright (c) 2015 Polaris. All rights reserved.
//

#import "DiscoverViewController.h"
#import "FoodDetailTableViewCell.h"
#import "TagTableViewCell.h"

@interface DiscoverViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableNearBy;
@property (strong, nonatomic) IBOutlet UITableView *tableFollowing;
@property (strong, nonatomic) IBOutlet UITableView *tableTopTag;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIView *viewNearBy;
@property (strong, nonatomic) IBOutlet UIView *viewFollowing;
@property (strong, nonatomic) IBOutlet UIView *viewTopTags;
@property (strong, nonatomic) IBOutlet UIView *viewContent;

@property (strong, nonatomic) IBOutlet UILabel *lblUnderLine;
@end

@implementation DiscoverViewController{
    NSMutableArray *arrange_Yelp;
    NSMutableArray *arrange_Yelp1;

    NSMutableArray *arrange_distance;
    NSMutableArray *arrange_distance1;

    NSMutableArray *follows;
    
    NSMutableArray *top_tags;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _scrollView.delegate = self;
    
    _tableNearBy.dataSource = self;
    _tableNearBy.delegate = self;
    
    _tableFollowing.dataSource = self;
    _tableFollowing.delegate = self;
    
    _tableTopTag.dataSource = self;
    _tableTopTag.delegate = self;
    
    arrange_Yelp = [[NSMutableArray alloc] init];
    arrange_Yelp1 = [[NSMutableArray alloc] init];
    arrange_distance = [[NSMutableArray alloc] init];
    arrange_distance1 = [[NSMutableArray alloc] init];
    follows = [[NSMutableArray alloc] init];
    
    // top tag
    PFQuery *tag_query = [PFQuery queryWithClassName:@"FoodTag"];
    [tag_query orderByDescending:@"countTag"];
    appController.tag_name = [tag_query findObjects];
    
    for (PFObject *obj in appController.tag_name) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (PFObject *pfobj in appController.totalFood) {
            
            if ([[pfobj objectForKey:@"FoodCategory"] isEqualToString:[obj objectForKey:@"TagName"]]){
                [array addObject:pfobj];
            }
            [appController.foodbytag setObject:array forKey:[obj objectForKey:@"TagName"]];
        }
    }
        
    
    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
    [query whereKey:@"ToID" equalTo:[appController.current_user objectForKey:@"user_objectID"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            for (PFObject *object in objects)
                [follows addObject:object[@"FromID"]];
        }
        
        [self tableview_getfollowdata];
        [_tableNearBy reloadData];
        [_tableFollowing reloadData];
    }];
    
    [self tableview_dataload];
    [self tableview_getfollowdata];
    
    

}

-(void)tableview_dataload{
    
    arrange_Yelp = appController.totalFood;
    
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:appController.myLatitude longitude:appController.myLongitude];
    
    for (NSMutableDictionary *item_yelp in appController.yelpArray){
        
        double res_latitude = [[item_yelp objectForKey:@"FoodLatitude"] doubleValue];
        double res_longitude = [[item_yelp objectForKey:@"FoodLongitude"] doubleValue];
        
        CLLocation *locB = [[CLLocation alloc] initWithLatitude:res_latitude  longitude:res_longitude];
        CLLocationDistance distance = [locA distanceFromLocation:locB];
        
        float me_TO_Res = [[NSString stringWithFormat:@"%.1f miles", distance/1609.34] floatValue];
        
        [arrange_distance addObject:[NSNumber numberWithFloat:me_TO_Res]];
    }
    
    NSMutableDictionary *temp_yelp = [[NSMutableDictionary alloc] init];
    
    for (int i=0; i<[arrange_distance count]-1; i++){
        for (int j=i+1; j<[arrange_distance count]; j++) {
            
            float a = [arrange_distance[i] floatValue];
            float b = [arrange_distance[j] floatValue];
            
            if (a > b) {
                
                arrange_distance[i] = [NSNumber numberWithFloat:b];
                arrange_distance[j] = [NSNumber numberWithFloat:a];
                
                temp_yelp = arrange_Yelp[i];
                arrange_Yelp[i] = arrange_Yelp[j];
                arrange_Yelp[j] = temp_yelp;
            }
        }
    }
}

- (void)tableview_getfollowdata{
    
        for (NSString *postUser in follows) {
            for (NSDictionary *item in appController.yelpArray) {
                if ([postUser isEqualToString:[item objectForKey:@"PostUserID"]]) {
                    [arrange_Yelp1 addObject:item];
                }
            }
        }
    
        CLLocation *locA = [[CLLocation alloc] initWithLatitude:appController.myLatitude longitude:appController.myLongitude];

        for (NSMutableDictionary *item_yelp in arrange_Yelp1){
        
            double res_latitude = [[item_yelp objectForKey:@"FoodLatitude"] doubleValue];
            double res_longitude = [[item_yelp objectForKey:@"FoodLongitude"] doubleValue];
        
            CLLocation *locB = [[CLLocation alloc] initWithLatitude:res_latitude  longitude:res_longitude];
            CLLocationDistance distance = [locA distanceFromLocation:locB];
        
            float me_TO_Res = [[NSString stringWithFormat:@"%.1f miles", distance/1609.34] floatValue];
        
            [arrange_distance1 addObject:[NSNumber numberWithFloat:me_TO_Res]];
        }
    
}

- (void)viewWillLayoutSubviews{
    
        CGRect frame;

        frame = CGRectMake(0, 0, _scrollView.frame.size.width * 3, _scrollView.frame.size.height);
        _viewContent.frame = frame;
    
        _scrollView.contentSize = _viewContent.frame.size;
    
        [_scrollView setScrollEnabled:YES];
        [_scrollView setPagingEnabled:YES];
    
    
        frame.size = _scrollView.frame.size;
        frame.origin.x = 0;
    
        [_viewNearBy setFrame:frame];
    
        frame.origin.x = _viewNearBy.frame.size.width;
        [_viewFollowing setFrame:frame];
    
        frame.origin.x = _viewNearBy.frame.size.width * 2;
        [_viewTopTags setFrame:frame];

}

- (IBAction)onTagBtn:(id)sender {
    int x_offset = [sender tag] * _scrollView.frame.size.width;
    
    [ UIView animateWithDuration:.25 animations:^{
        [ _scrollView setContentOffset:CGPointMake(x_offset, 0)];
        
        _lblUnderLine.frame = CGRectMake(x_offset/3, _lblUnderLine.frame.origin.y, _lblUnderLine.frame.size.width  ,_lblUnderLine.frame.size.height);
    }];
}

#pragma mark  -  scrollview Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int x_offset = _scrollView.contentOffset.x/3;
    _lblUnderLine.frame = CGRectMake(x_offset, _lblUnderLine.frame.origin.y, _lblUnderLine.frame.size.width  ,_lblUnderLine.frame.size.height);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger return_value = 0;
    
    if (tableView == _tableNearBy) {
        return_value = [arrange_Yelp count];
    } else if (tableView == _tableFollowing){
        return_value = [arrange_Yelp1 count];
    } else if (tableView == _tableTopTag){

        
        PFQuery *query = [PFQuery queryWithClassName:@"FoodTag"];
        return_value = [query countObjects];
        
    }
    return return_value;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *tempcell;
    
    if (tableView == _tableTopTag){
        
        NSMutableArray *dafsd = appController.tag_name;
        
        TagTableViewCell *tag_cell = (TagTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"tagCell"];        
        tag_cell.lblTag.text = [[appController.tag_name objectAtIndex:indexPath.row] objectForKey:@"TagName"];
        
        appController.nindex = indexPath.row;
        
        tempcell = tag_cell;
        
    } else {
        
        FoodDetailTableViewCell *cell = (FoodDetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"fooddetailCell"];
        
        NSMutableArray *use_data = [[NSMutableArray alloc] init];
        NSMutableArray *use_distance = [[NSMutableArray alloc] init];
        
        if (tableView == _tableNearBy){
            use_data = arrange_Yelp;
            use_distance = arrange_distance;
        } else {
            use_data = arrange_Yelp1;
            use_distance = arrange_distance1;
        }
        
        if ([use_data count] != 0){
        NSDictionary *yelpInfo = [use_data objectAtIndex:indexPath.row];
        
        PFQuery *query = [PFUser query];
        [query whereKey:@"objectId" equalTo:[yelpInfo objectForKey:@"PostUserID"]];
        NSArray *users = [query findObjects];
        PFUser *user = [users objectAtIndex:0];
        
        [cell.imgSellerPhoto setImageWithURL:[NSURL URLWithString:user[@"photo"]]];
        cell.lblSellerName.text = user[@"fullname"];
        
        cell.lblSellerRange.text =  [NSString stringWithFormat:@"%dm", (int)([arrange_distance[indexPath.row] floatValue] * 1609.34)];

        cell.lblFoodName.text = yelpInfo[@"FoodName"];
        cell.lblCity.text = [[[yelpInfo objectForKey:@"RestaurantName"] stringByAppendingString:@", "] stringByAppendingString:[yelpInfo objectForKey:@"FoodCity"]];
        [cell.imgFooddetail setImageWithURL:[NSURL URLWithString:yelpInfo[@"FoodImageURL"]]];
        
        NSString *imgName = @"heart";
        
        if ([yelpInfo[@"PostUserID"] isEqualToString:[appController.current_user objectForKey:@"user_objectID"]]){
                imgName = [imgName stringByAppendingString:@"_select"];
        }
        
        cell.imgLike.image = [UIImage imageNamed:imgName];
        
        cell.lblLikeCount.text = @"LIKES(50)";

        imgName = @"comment";

        if ([yelpInfo[@"PostUserID"] isEqualToString:[appController.current_user objectForKey:@"user_objectID"]]){
                imgName = [imgName stringByAppendingString:@"_select"];
        }
        
        cell.imgComment.image = [UIImage imageNamed:imgName];
        
        cell.lblComment.text = @"COMMENTS(1)";//[NSString stringWithFormat:@"COMMENTS(%@)" , yelpInfo[@"review_count"]];
    //        [appController.foodDetailCell_info objectForKey:@"commentCount"]];
        
        imgName = @"shares";
        
        if ([yelpInfo[@"PostUserID"] isEqualToString:[appController.current_user objectForKey:@"user_objectID"]]){
                imgName = [imgName stringByAppendingString:@"_select"];
        }
        
        cell.imgShare.image = [UIImage imageNamed:imgName];
        
        }
        
        [cell.btnLike setTag:indexPath.row];
        [cell.btnShare setTag:indexPath.row];
        [cell.btnComment setTag:indexPath.row];

        tempcell = cell;

    }
    return tempcell;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onShareBtn:(id)sender {
    
    PFObject *likeFood = [PFObject objectWithClassName:@"FoodLikeSharePost"];
    likeFood[@"UserID"] = [appController.current_user objectForKey:@"user_objectID"];
    likeFood[@"FoodID"] = [[arrange_Yelp objectAtIndex:[sender tag]] objectForKey:@"objID"];
    NSInteger like = 1;
    likeFood[@"Status"] = [NSNumber numberWithInteger:like];
    
    NSString *alert = [[appController.yelpArray objectAtIndex:[sender tag]] objectForKey:@"FoodName"];
    alert = [@"You shared " stringByAppendingString:alert];
    alert = [alert stringByAppendingString:@"."];
    
    [likeFood saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
            [appController.vAlert doAlert:@"Notice" body:alert duration:1.3f done:^(DoAlertView *alertView) {
            }];
            
        } else {
            [appController.vAlert doAlert:@"Notice" body:@"Connection error!" duration:1.3f done:^(DoAlertView *alertView) {
            }];
        }
    }];
    
}
- (IBAction)onLikeBtn:(id)sender {
    
//    FoodDetailTableViewCell *cell = (FoodDetailTableViewCell*)[[[sender superview] superview] superview];
    
    PFObject *likeFood = [PFObject objectWithClassName:@"FoodLikeSharePost"];
    likeFood[@"UserID"] = [appController.current_user objectForKey:@"user_objectID"];
    likeFood[@"FoodID"] = [[arrange_Yelp objectAtIndex:[sender tag]] objectForKey:@"objID"];
    NSInteger like = 0;
    likeFood[@"Status"] = [NSNumber numberWithInteger:like];

    NSString *alert = [[appController.yelpArray objectAtIndex:[sender tag]] objectForKey:@"FoodName"];
    alert = [@"You liked " stringByAppendingString:alert];
    alert = [alert stringByAppendingString:@"."];
    
    [likeFood saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
            [appController.vAlert doAlert:@"Notice" body:alert duration:1.3f done:^(DoAlertView *alertView) {
            }];
            
        } else {
            [appController.vAlert doAlert:@"Notice" body:@"Connection error!" duration:1.3f done:^(DoAlertView *alertView) {
            }];
        }
    }];
    

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
