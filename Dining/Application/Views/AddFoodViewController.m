//
//  AddFoodViewController.m
//  Dining
//
//  Created by Polaris on 12/25/15.
//  Copyright (c) 2015 Polaris. All rights reserved.
//

#import "AddFoodViewController.h"
#import "AddFoodTableViewCell.h"

@interface AddFoodViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableViewAddFood;
@property (strong, nonatomic) IBOutlet UITextField *txtUserFoodName;

@end

@implementation AddFoodViewController{
    NSString *inputTag;
    NSMutableArray *foodCategory;
    NSMutableArray *foodPrice;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _txtUserFoodName.delegate = self;
    
    _tableViewAddFood.dataSource = self;
    _tableViewAddFood.delegate = self;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Food"];
    
    foodCategory = [[NSMutableArray alloc] init];
    foodPrice = [[NSMutableArray alloc] init];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *err){
        if (!err){
            for (PFObject *object in objects){
                [foodCategory addObject:[@"#" stringByAppendingString:object[@"FoodName"]]];
                [foodPrice addObject:[@"$" stringByAppendingString:[NSString stringWithFormat:@"%@", object[@"FoodPrice"]]]];
            }
            [_tableViewAddFood reloadData];
        }
    }];
    
    inputTag = @"";
}
- (IBAction)onBackBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [foodCategory count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AddFoodTableViewCell *cell = (AddFoodTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%@", cell.lblFoodName.text);
//    inputTag = [@"#" stringByAppendingString:cell.lblFoodName.text];
    inputTag = cell.lblFoodName.text;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddFoodTableViewCell *cell = (AddFoodTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"addFoodCell"];

    if ([foodCategory count] != 0){
    
        cell.lblFoodName.text = [foodCategory objectAtIndex:indexPath.row];

        cell.lblFoodPrice.text = [foodPrice objectAtIndex:indexPath.row];
    }
    return cell;
    
}
- (IBAction)onAddNewBtn:(id)sender {
    if (![_txtUserFoodName.text isEqualToString:@""]){
        inputTag = [@"#" stringByAppendingString:_txtUserFoodName.text];
    }
    
    if ([inputTag isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please input or select your food name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        [alert show];
        return;
    }

    
    appController.user_foodName = inputTag;
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
    [textField resignFirstResponder];
    return YES;
}

@end
