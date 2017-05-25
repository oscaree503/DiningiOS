//
//  AppController.h
//  Marqoo
//
//  Created by admin on 12/1/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AppController : NSObject

@property (nonatomic, strong) NSMutableDictionary *currentUser, *refUser, *refPost, *refReport, *apnsMessage;
@property (nonatomic, strong) NSMutableArray *categories, *myPosts, *myLikesPosts, *myFollows, *myFollowing;
@property (nonatomic, strong) NSMutableArray *featuredPosts, *recentPosts, *followersPosts, *myActivities, *refFollows, *tempFollows, *currentPosts, *searchResults;

@property (nonatomic, assign) BOOL isCustomLayoutSet, isFromHome, isMyProfileChanged, isFromPostPushed, isFollowersPage, isPostComment, isFromPostShare, reportMode, isSearchPage, isFromPostShareSucceeded;

@property (nonatomic, assign) NSUInteger popupStatus, postTablePage, postsType, barStatus;

@property (nonatomic, strong) NSString *currentCategoryId, *refUserId, *uploadedMediaPath;

// Utility Variables
@property (nonatomic, strong) UIColor *appMainColor, *appTextColor;
@property (nonatomic, strong) DoAlertView *vAlert, *vAlertSecond;

@property (nonatomic) int choose,homeSeleted,myvideosSelected,categoriTag;


@property (nonatomic, retain) NSMutableArray *allUser_data;

@property (nonatomic, retain) NSMutableArray *collectionArray;

@property (nonatomic, retain) NSMutableArray *foodItemArray, *foodTopTagName, *addFood, *mytags, *myFoods;

@property (nonatomic, assign) int sel_item;

@property (nonatomic, assign) int isSignUp;

@property (nonatomic, retain) NSMutableDictionary *current_user;
@property (nonatomic, retain) NSMutableDictionary *foodbytag;


@property (nonatomic, assign) NSString *verifiedcode;

@property (nonatomic, retain) NSDictionary *findFriends_info, *notification_info;

@property (nonatomic, retain) NSMutableArray *foodTags;
@property (nonatomic, retain) NSMutableArray *yelpArray, *totalFood;
@property (nonatomic, retain) NSMutableArray *tag_count;
@property (nonatomic, retain) NSMutableArray *tag_name;
@property (nonatomic, assign) int nindex;

@property (nonatomic) float myLatitude, myLongitude;

@property (nonatomic) NSString *user_foodName, *user_foodReview;


@property (nonatomic, retain) NSMutableArray *searchFilter;

+ (AppController *)sharedInstance;

@end