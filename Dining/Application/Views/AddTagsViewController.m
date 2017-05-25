//
//  AddTagsViewController.m
//  Dining
//
//  Created by Polaris on 12/25/15.
//  Copyright (c) 2015 Polaris. All rights reserved.
//

#import "AddTagsViewController.h"

@interface AddTagsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableviewTags;

@end

@implementation AddTagsViewController{
    NSString *inputTag;
    NSMutableArray *foodCategory;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableviewTags.dataSource = self;
    _tableviewTags.delegate = self;
    
    PFQuery *query = [PFQuery queryWithClassName:@"FoodTag"];
    foodCategory = [[NSMutableArray alloc] init];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *err){
        if (!err){
            for (PFObject *object in objects)
                [foodCategory addObject:[@"#" stringByAppendingString:object[@"TagName"]]];
            [_tableviewTags reloadData];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onBackBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [foodCategory count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *tableID = @"TagItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableID];
    
    if ([foodCategory count] != 0){
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableID];
        }
    
        cell.textLabel.text = [foodCategory objectAtIndex:indexPath.row];
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = (UITableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%@", cell.textLabel.text);
    inputTag = cell.textLabel.text;

}
- (IBAction)onAddNewBtn:(id)sender {
    int state = 0;
    for (NSString *itemString in appController.mytags) {
        if ([inputTag isEqualToString:itemString] ) {
            state = 1;
        }
    }
    
    if (state == 0) {
        [appController.mytags addObject:inputTag];
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
