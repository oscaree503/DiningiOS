//
//  UQSessionManager.h
//  UniQulture
//
//  Created by Yingcheng Li on 9/26/14.
//  Copyright (c) 2014 ss. All rights reserved.
//

#import <Foundation/Foundation.h>


#define LOGIN_TYPE_EMAIL    1001
#define LOGIN_TYPE_FACEBOOK 1002

@interface SessionManager : NSObject

+ (SessionManager*) currentSession;

- (void) initSessionWithObject:(NSDictionary*) resObj;
- (void) clearSession;

@property (nonatomic) BOOL isLogedIn;
@property (nonatomic) BOOL isFacebookLogin;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *profilePhotoUrl;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *deviceToken;

@end
