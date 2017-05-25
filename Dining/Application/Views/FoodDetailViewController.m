//
//  FoodDetailViewController.m
//  Dining
//
//  Created by Polaris on 12/15/15.
//  Copyright (c) 2015 Polaris. All rights reserved.
//

#import "FoodDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface FoodDetailViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imgCustomer;
@property (strong, nonatomic) IBOutlet UIImageView *imgOrder;

@property (strong, nonatomic) IBOutlet UIImageView *imgFood;

@property (strong, nonatomic) IBOutlet UIButton *btnShare;

@property (strong, nonatomic) IBOutlet UILabel *lblFoodName;
@property (strong, nonatomic) IBOutlet UILabel *lblCategory;

@property (strong, nonatomic) IBOutlet UILabel *lblnLikes;

@property (strong, nonatomic) IBOutlet UILabel *lblReview;
@property (strong, nonatomic) IBOutlet UILabel *lblPostManName;
@end

@implementation FoodDetailViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [commonUtils cropCircleImage:_imgCustomer];
    [commonUtils cropCircleImage:_imgOrder];
    [commonUtils setRoundedRectBorderButton:_btnShare withBorderWidth:1 withBorderColor:RGBA(223, 108, 63, 1) withBorderRadius:18];
    
    NSDictionary *yelpInfo = [appController.yelpArray objectAtIndex:appController.sel_item];
    
//    PFQuery *query = [PFQuery queryWithClassName:@"User"];
//    [query whereKey:@"objectId" equalTo:[yelpInfo objectForKey:@"PostUserID"]];
//    
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
//        if (!error) {
//            PFObject *obj = [objects objectAtIndex:0];
//            [_imgCustomer setImageWithURL:[NSURL URLWithString:obj[@"photo"]]];
//        } else {
//            [_imgCustomer setImage:[UIImage imageNamed:@"user"]];
//        }
//    }];
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" equalTo:[yelpInfo objectForKey:@"PostUserID"]];
    NSArray *users = [query findObjects];
    PFUser *user = [users objectAtIndex:0];
    
    [_imgCustomer setImageWithURL:[NSURL URLWithString:user[@"photo"]]];
     _lblPostManName.text = user[@"fullname"];
    
    [_imgFood setImageWithURL:[NSURL URLWithString:yelpInfo[@"FoodImageURL"]]];
    [_lblFoodName setText:yelpInfo[@"FoodName"]];
    
    _lblCategory.text = [[[yelpInfo objectForKey:@"RestaurantName"] stringByAppendingString:@", "] stringByAppendingString:[yelpInfo objectForKey:@"FoodCity"]];
    
    _lblnLikes.text = @"50"; //[yelpInfo[@"review_count"] stringValue];
    _lblReview.text = [yelpInfo objectForKey:@"FoodReview"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
