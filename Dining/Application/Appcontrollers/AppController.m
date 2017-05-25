//
//  AppController.m


#import "AppController.h"
#import <CoreLocation/CoreLocation.h>

static AppController *_appController;

@implementation AppController

+ (AppController *)sharedInstance {
    static dispatch_once_t predicate;
    if (_appController == nil) {
        dispatch_once(&predicate, ^{
            _appController = [[AppController alloc] init];
        });
    }
    return _appController;
}

- (id)init {
    
    self = [super init];
    if (self) {
        
        _nindex = 0;
        
//        _user_data = [[NSDictionary alloc] init];
        _allUser_data = [[NSMutableArray alloc] init];
        
        _user_foodName = @"";
        _user_foodReview = @"";
        
        _current_user = [[NSMutableDictionary alloc] init];
        _foodbytag = [[NSMutableDictionary alloc] init];
        
        _yelpArray = [NSMutableArray alloc];
        _totalFood = [NSMutableArray alloc];
        
        _tag_count = [[NSMutableArray alloc] init];
        _tag_name = [[NSMutableArray alloc] init];
        
        _collectionArray = [[NSMutableArray alloc] initWithObjects:@"food1", @"food2",  @"food3", @"food4", @"food5", @"food6",nil];
        
//        _foodTags = [[NSMutableArray alloc] init];
        
        _foodTopTagName = [[NSMutableArray alloc] initWithObjects:@"#DESERT", @"#CLAMS", @"JAPANESE_FOOD", nil];
        
        _mytags = [[NSMutableArray alloc] init];
        _myFoods = [[NSMutableArray alloc] init];
        
        _foodItemArray = [[NSMutableArray alloc] initWithObjects:
                          
                           @{@"foodname" : @"Miso Ramen",
                             @"foodprice" : @"20",
                             @"foodimage1" : @"MisoRamen1",
                             @"foodimage2" : @"MisoRamen2",
                             @"foodimage3" : @"MisoRamen3"},
                           
                           @{@"foodname" : @"Edamame",
                             @"foodprice" : @"14",
                             @"foodimage1" : @"Edamame1",
                             @"foodimage2" : @"Edamame2",
                             @"foodimage3" : @"Edamame3"},
                          
                           @{@"foodname" : @"Fride Rice Cake",
                             @"foodprice" : @"18",
                             @"foodimage1" : @"FriedRiceCake1",
                             @"foodimage2" : @"FriedRiceCake2",
                             @"foodimage3" : @"FriedRiceCake3"}, nil];
        
        _addFood = [[NSMutableArray alloc] initWithObjects:
                    @{@"foodname" : @"SPICY FISH",
                      @"foodprice": @20},
                    @{@"foodname" : @"SPICY FORK",
                      @"foodprice": @32},
                    @{@"foodname" : @"SPICY CHICKEN",
                      @"foodprice": @21}, nil];
        
        _notification_info = @{ @"userPhoto" : @"userphoto",
                                @"userName"  : @"MARINE LEGRAND",
                                @"pastTime"  : @15,
                                @"notification" : @"Lorem ipsum dolor sit amet, consectetur John adipisicing elit, sed Dave do eiusmod."
                                };
        
        _findFriends_info = @{ @"frined_image" : @"userphoto",
                               @"friends_name" : @"BARTHELEMY CHALVET",
                               @"countFollower" : @1200,
                               @"follow_state" : @1
                              };
        
        _searchFilter = [NSMutableArray arrayWithObjects:@"0", @"0", @"50", nil];
        
//        _myLocation = CLLocationCoordinate2DMake(40.657229, -73.958109);
        
        _myLatitude = 40.657229;
        _myLongitude = -73.958109;
        
        
        
        
        // Data Array
        _myFollows = [[NSMutableArray alloc] init];
        _myFollowing = [[NSMutableArray alloc] init];
        _myPosts = [[NSMutableArray alloc] init];
        _myLikesPosts = [[NSMutableArray alloc] init];
        _featuredPosts = [[NSMutableArray alloc] init];
        _recentPosts = [[NSMutableArray alloc] init];
        _followersPosts = [[NSMutableArray alloc] init];
        _myActivities = [[NSMutableArray alloc] init];
        
        
        _currentUser = [[NSMutableDictionary alloc] init];
        _refFollows = [[NSMutableArray alloc] init];
        _searchResults = [[NSMutableArray alloc] init];
        _tempFollows = [[NSMutableArray alloc] init];
        
        
        
        // Nav Temporary Data
        _currentUser = [[NSMutableDictionary alloc] init];
        
        _popupStatus = 0;
        _isCustomLayoutSet = NO;
        _isFromPostPushed = NO;
        _isFromHome = NO;
        _isMyProfileChanged = NO;
        _isFollowersPage = YES;
        _isPostComment = NO;
        _isFromPostShare = NO;
        _isSearchPage = NO;
        _isFromPostShareSucceeded = NO;
        _uploadedMediaPath = @"";
        _postTablePage = 0;
        _postsType = 0;
        _barStatus = 0;
        
        _currentPosts = [[NSMutableArray alloc] init];
        
        _refUserId = @"0";
        [self initBaseData];
        
        _refPost = [[NSMutableDictionary alloc] init];
        
        _reportMode = NO;
        _refReport = [[NSMutableDictionary alloc] init];
        
        // Menu Items
        // Bottom
        _categories = [[NSMutableArray alloc] init];
        
        // Utility Data
        _appMainColor = RGBA(254, 137, 92, 1.0f);
        _appTextColor = RGBA(255, 255, 255, 1.0f);
        
        _vAlert = [[DoAlertView alloc] init];
        _vAlert.nAnimationType = 2;  // there are 5 type of animation
        _vAlert.dRound = 7.0;
        _vAlert.bDestructive = NO;  // for destructive mode
        //        _vAlert.iImage = [UIImage imageNamed:@"logo_top"];
        //        _vAlert.nContentMode = DoContentImage;
        
        _vAlertSecond = [[DoAlertView alloc] init];
        _vAlertSecond.nAnimationType = 2;  // there are 5 type of animation
        _vAlertSecond.dRound = 7.0;
        _vAlertSecond.bDestructive = NO;  // for destructive mode
        //        _vAlert.iImage = [UIImage imageNamed:@"logo_top"];
        //        _vAlert.nContentMode = DoContentImage;
        
        
    }
    return self;
}


#pragma mark - Set Base Data
- (void)initBaseData {
    
    _refUser = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:@"4" forKey:@"user_id"];
    [userInfo setObject:@"103583495793" forKey:@"user_facebook_id"];
    [userInfo setObject:@"Keenan" forKey:@"user_first_name"];
    [userInfo setObject:@"Smith" forKey:@"user_last_name"];
    [userInfo setObject:@"keenan23523@gmail.com" forKey:@"user_email"];
    
    [userInfo setObject:@"Keenan Smith" forKey:@"user_full_name"];
    [userInfo setObject:@"Mike123" forKey:@"user_name"];
    [userInfo setObject:@"2016 Olympian. I run in circles half naked." forKey:@"user_bio"];
    [userInfo setObject:@"user_02" forKey:@"user_photo_url"];
    
    [userInfo setObject:@"0" forKey:@"user_closed"];
    [userInfo setObject:@"2015-07-25 08:48:50" forKey:@"user_signup_date"];
    [userInfo setObject:@"2015-07-28 16:10:20" forKey:@"user_last_updated_date"];
    [userInfo setObject:@"8" forKey:@"user_posts_count"];
    [userInfo setObject:@"18" forKey:@"user_likes_count"];
    [userInfo setObject:@"308" forKey:@"user_followers_count"];
    [userInfo setObject:@"46" forKey:@"user_following_count"];
    
    [userInfo setObject:@"0" forKey:@"is_following"];
    
    _refUser = [userInfo mutableCopy];
    
}

@end
