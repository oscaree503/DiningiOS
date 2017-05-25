//
//  UQSessionManager.m
//  UniQulture
//
//  Created by Yingcheng Li on 9/26/14.
//  Copyright (c) 2014 ss. All rights reserved.
//

#import "SessionManager.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation SessionManager
static SessionManager *currentSession;

+ (SessionManager*) currentSession {
    if (currentSession == nil) {
        currentSession = [[SessionManager alloc] init];
    }
    
    return currentSession;
}

- (void) initSessionWithObject:(NSDictionary*) resObj {
    self.isLogedIn = YES;
    self.userId = [resObj objectForKey:@"user_id"];
    self.userName = [resObj objectForKey:@"user_name"];
    self.profilePhotoUrl = [resObj objectForKey:@"user_photo_url"];
}

- (void) clearSession {
    _isLogedIn = NO;
    _userId = @"";
    _userName = @"";
    _profilePhotoUrl = @"";
    
    [[FBSession activeSession] closeAndClearTokenInformation];
    [FBSession setActiveSession:nil];
}

@end
