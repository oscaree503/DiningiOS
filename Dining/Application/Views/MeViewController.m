//
//  MeViewController.m
//  Dining
//
//  Created by Polaris on 12/27/15.
//  Copyright (c) 2015 Polaris. All rights reserved.
//

#import "MeViewController.h"
#import "ProfileTableViewCell.h"
#import "FoodCollectionViewCell.h"

#import <MapKit/MapKit.h>
#import "Place.h"
#import "PlaceMark.h"

@interface MeViewController ()<UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imgUserPhoto;
@property (strong, nonatomic) IBOutlet UIButton *btnSettings;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UILabel *lblUserLocation;

@property (strong, nonatomic) IBOutlet UIButton *btnFollow;
@property (strong, nonatomic) IBOutlet UIButton *btnMessage;

@property (strong, nonatomic) IBOutlet UILabel *lblNPosts;
@property (strong, nonatomic) IBOutlet UILabel *lblNFollowers;
@property (strong, nonatomic) IBOutlet UILabel *lblNFollowing;

@property (strong, nonatomic) IBOutlet UIButton *lblLiked;
@property (strong, nonatomic) IBOutlet UIButton *lblEaten;
@property (strong, nonatomic) IBOutlet UIButton *lblLocation;
@property (strong, nonatomic) IBOutlet UIButton *lblProfile;
@property (strong, nonatomic) IBOutlet UILabel *lblUnderLine;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewLiked;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewEaten;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) IBOutlet UITableView *tableviewProfile;

@property (strong, nonatomic) IBOutlet UIView *viewContents;

@property (strong, nonatomic) IBOutlet UIView *viewContainer;
@property (strong, nonatomic) IBOutlet UIView *viewLiked;
@property (strong, nonatomic) IBOutlet UIView *viewEaten;
@property (strong, nonatomic) IBOutlet UIView *viewMap;
@property (strong, nonatomic) IBOutlet UIView *viewProfile;

@property (nonatomic, strong) NSMutableArray *points;

@end

@implementation MeViewController{
    NSMutableArray *restaurantCity;
    NSMutableArray *likeFood, *eatenFood;
    NSMutableArray *follow_table;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [commonUtils cropCircleImage:_imgUserPhoto];
    [commonUtils setRoundedRectBorderButton:_btnFollow withBorderWidth:1 withBorderColor:RGBA(255, 129, 98, 1) withBorderRadius:22];
    [commonUtils setRoundedRectBorderButton:_btnMessage withBorderWidth:2 withBorderColor:RGBA(255, 129, 98, 1) withBorderRadius:22];
    
    _scrollView.delegate = self;
    _mapView.delegate = self;
    
    _collectionViewLiked.dataSource = self;
    _collectionViewLiked.delegate = self;

    _collectionViewEaten.dataSource = self;
    _collectionViewEaten.delegate = self;

    _tableviewProfile.dataSource = self;
    _tableviewProfile.delegate = self;
    
    [_tableviewProfile setScrollEnabled:NO];
    [_tableviewProfile setRowHeight:50.0f];
    
    [self initUI];
    _lblUserName.text = [appController.current_user objectForKey:@"user_fullname"];
    [_lblUserLocation setHidden:YES];
    
    likeFood = [[NSMutableArray alloc] init];
    eatenFood = [[NSMutableArray alloc] init];
    for (NSDictionary *food_item in appController.yelpArray) {
        if ([[food_item objectForKey:@"PostUserID"] isEqualToString:[appController.current_user objectForKey:@"user_objectID"]]) {
            [likeFood addObject:food_item];
            [eatenFood addObject:food_item];
        }
    }
    
    PFQuery *follow_query = [PFQuery queryWithClassName:@"Follow"];
    follow_table = [follow_query findObjects];
    [self following];
}
-(void)following{
    
    int nPost = 0;
    for (PFObject *item_food in appController.totalFood) {
        if ([[item_food objectForKey:@"PostUserID"] isEqualToString:[appController.current_user objectForKey:@"user_objectID"]]) {
            nPost ++;
        }
    }
    _lblNPosts.text = [NSString stringWithFormat:@"%d", nPost];
    
    int follower = 0, following = 0;
    for (PFObject *item in follow_table) {
        if ([[item objectForKey:@"FromID"] isEqualToString:[appController.current_user objectForKey:@"user_objectID"]]) {
            follower ++;
        }
        if ([[item objectForKey:@"ToID"] isEqualToString:[appController.current_user objectForKey:@"user_objectID"]]) {
            following ++;
        }
    }
    _lblNFollowers.text = [NSString stringWithFormat:@"%d", follower];
    _lblNFollowing.text = [NSString stringWithFormat:@"%d", following];
}
-(void)viewWillAppear:(BOOL)animated{
    
    _points = [[NSMutableArray alloc] init];
    restaurantCity = [[NSMutableArray alloc] init];
    
    for (PFObject *foodinfo in appController.totalFood) {
        NSMutableDictionary *food_location = [[NSMutableDictionary alloc] init];
        [food_location setValue:[foodinfo objectForKey:@"FoodLatitude"] forKey:@"latitude"];
        [food_location setValue:[foodinfo objectForKey:@"FoodLongitude"] forKey:@"longitude"];
        [_points addObject:food_location];
        NSString *foodcity;
        foodcity = [NSString stringWithFormat:@"%@,  %@", [foodinfo objectForKey:@"RestaurantName"], [foodinfo objectForKey:@"FoodCity"]];
        [restaurantCity addObject:foodcity];
    }
    
    for (int i = 0; i < [_points count]; i++) {
        Place *home = [[Place alloc] init];
        home.name = [restaurantCity objectAtIndex:i];
        home.latitude = [[[_points objectAtIndex:i] valueForKey:@"latitude"]floatValue];
        home.longitude = [[[_points objectAtIndex:i] valueForKey:@"longitude"]floatValue];
        PlaceMark *from = [[PlaceMark alloc] initWithPlace:home];
        
        if(i == 0) {
            from.isMain = 1;
        }
        [self.mapView addAnnotation:from];
    }
    
    [self zoomMapViewToFitAnnotations:_mapView animated:animated];
    
    _mapView.showsUserLocation = YES;

}

//size the mapView region to fit its annotations
- (void)zoomMapViewToFitAnnotations:(MKMapView *)mapView animated:(BOOL)animated {
    NSArray *annotations = mapView.annotations;
    int count = (int)[self.mapView.annotations count];
    if ( count == 0) { return; } //bail if no annotations
    
    //convert NSArray of id <MKAnnotation> into an MKCoordinateRegion that can be used to set the map size
    //can't use NSArray with MKMapPoint because MKMapPoint is not an id
    MKMapPoint points[count]; //C array of MKMapPoint struct
    for( int i=0; i<count; i++ ) //load points C array by converting coordinates to points
    {
        CLLocationCoordinate2D coordinate = [(id <MKAnnotation>)[annotations objectAtIndex:i] coordinate];
        points[i] = MKMapPointForCoordinate(coordinate);
    }
    //create MKMapRect from array of MKMapPoint
    MKMapRect mapRect = [[MKPolygon polygonWithPoints:points count:count] boundingMapRect];
    //convert MKCoordinateRegion from MKMapRect
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    
    //add padding so pins aren't scrunched on the edges
    region.span.latitudeDelta  *= ANNOTATION_REGION_PAD_FACTOR;
    region.span.longitudeDelta *= ANNOTATION_REGION_PAD_FACTOR;
    //but padding can't be bigger than the world
    if( region.span.latitudeDelta > MAX_DEGREES_ARC ) { region.span.latitudeDelta  = MAX_DEGREES_ARC; }
    if( region.span.longitudeDelta > MAX_DEGREES_ARC ){ region.span.longitudeDelta = MAX_DEGREES_ARC; }
    
    //and don't zoom in stupid-close on small samples
    if( region.span.latitudeDelta  < MINIMUM_ZOOM_ARC ) { region.span.latitudeDelta  = MINIMUM_ZOOM_ARC; }
    if( region.span.longitudeDelta < MINIMUM_ZOOM_ARC ) { region.span.longitudeDelta = MINIMUM_ZOOM_ARC; }
    //and if there is a sample of 1 we want the max zoom-in instead of max zoom-out
    if( count == 1 )
    {
        region.span.latitudeDelta = MINIMUM_ZOOM_ARC;
        region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
    }
    [mapView setRegion:region animated:animated];
}


- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if (annotation == self.mapView.userLocation)
        return nil;
    MKPinAnnotationView *pin = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier: @"Bark"];
    if (pin == nil)
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier: @"Bark"];
    else
        pin.annotation = annotation;
    pin.userInteractionEnabled = NO;
    //    UIButton *disclosureButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //    [disclosureButton setFrame:CGRectMake(0, 0, 30, 30)];
    //    pin.rightCalloutAccessoryView = disclosureButton;
    //    pin.pinColor = MKPinAnnotationColorRed;
    pin.animatesDrop = YES;
//    PlaceMark *ann = (PlaceMark *)annotation;
    NSString *pinImageStr = @"sport_pin"; //(ann.isMain == 1 ? @"map_originpin" : @"map_rebarkpin");
    pin.image = [UIImage imageNamed:pinImageStr];
    [pin setEnabled:NO];
    [pin setCanShowCallout:YES];
    
    return pin;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) initUI{
    
    int kCellsPerRow = 2;
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)_collectionViewLiked.collectionViewLayout;

    CGFloat availableWidthForCells = CGRectGetWidth(_collectionViewLiked.frame) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (kCellsPerRow - 1);
    CGFloat cellWidth = availableWidthForCells / (float)kCellsPerRow;
    flowLayout.itemSize = CGSizeMake(cellWidth, cellWidth);
    
    flowLayout = (UICollectionViewFlowLayout*)_collectionViewEaten.collectionViewLayout;
    availableWidthForCells = CGRectGetWidth(_collectionViewEaten.frame) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (kCellsPerRow - 1);
    cellWidth = availableWidthForCells / (float)kCellsPerRow;
    flowLayout.itemSize = CGSizeMake(cellWidth, cellWidth);
    
}
-(void)viewDidLayoutSubviews{
    CGRect frame;
    frame = CGRectMake(0, 0, _scrollView.frame.size.width * 4, _scrollView.frame.size.height);
    _viewContainer.frame = frame;
    
    frame.size = _scrollView.frame.size;
    _scrollView.contentSize = frame.size;

    frame.origin.x = 0;
    [_viewLiked setFrame:frame];
    
    frame.origin.x = frame.size.width;
    [_viewEaten setFrame:frame];
    
    frame.origin.x = frame.size.width * 2;
    [_viewMap setFrame:frame];
    
    frame.origin.x = frame.size.width * 3;
    [_viewProfile setFrame:frame];
    
}
- (IBAction)onMenuBtn:(id)sender {
    
    int x_offset = [sender tag] * _scrollView.frame.size.width;
    
    [ UIView animateWithDuration:.25 animations:^{
        [ _scrollView setContentOffset:CGPointMake(x_offset, 0)];
        
        _lblUnderLine.frame = CGRectMake(x_offset/4, _lblUnderLine.frame.origin.y, _lblUnderLine.frame.size.width  ,_lblUnderLine.frame.size.height);
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int x_offset = _scrollView.contentOffset.x/4;
    _lblUnderLine.frame = CGRectMake(x_offset, _lblUnderLine.frame.origin.y, _lblUnderLine.frame.size.width  ,_lblUnderLine.frame.size.height);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ProfileTableViewCell *cell = (ProfileTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"profileCell"];
    
//    NSArray *keys = [appController.current_user allKeys];
//    
//    cell.lblProfileItem.text = [keys objectAtIndex:indexPath.row];
//    cell.lblProfileContents.text = [appController.profile objectForKey:[keys objectAtIndex:indexPath.row]];
    
    switch (indexPath.row) {
        case 0:
            cell.lblProfileItem.text = @"BIRTHDAY";
            cell.lblProfileContents.text = [appController.current_user objectForKey:@"user_birthday"];
            break;
        case 1:
            cell.lblProfileItem.text = @"PROFESSION";
            cell.lblProfileContents.text = [appController.current_user objectForKey:@"user_profession"];
            break;
        case 2:
            cell.lblProfileItem.text = @"SCHOOL/COMPANY";
            cell.lblProfileContents.text = [appController.current_user objectForKey:@"user_school"];
            break;
        case 3:
            cell.lblProfileItem.text = @"FAVOURITE FOOD";
            cell.lblProfileContents.text = @"Fried Chicken";//[appController.current_user objectForKey:@"user_profession"];
            break;
        case 4:
            cell.lblProfileItem.text = @"TOP RESTAURANTS";
            cell.lblProfileContents.text = @"Joe's Ristorante";//[appController.current_user objectForKey:@"user_profession"];
            break;
        default:
            break;
    }
    
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [likeFood count];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FoodCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"foodCell" forIndexPath:indexPath];
    if (collectionView == _collectionViewEaten){
        [cell.food_imageView setImageWithURL:[NSURL URLWithString:[[likeFood objectAtIndex:indexPath.row] objectForKey:@"FoodImageURL"]]];
//        cell.food_imageView.image =[UIImage imageNamed:[[appController collectionArray] objectAtIndex:indexPath.row]];
    } else {
        
        [cell.food_imageView setImageWithURL:[NSURL URLWithString:[[likeFood objectAtIndex:indexPath.row] objectForKey:@"FoodImageURL"]]];
    }
    return cell;
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
