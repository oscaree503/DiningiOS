//
//  PreLoadHeader.h
//  InstaChurch
//
//  Created by Yingcheng Li on 3/9/15.
//  Copyright (c) 2015 Dave. All rights reserved.
//

#define IS_IPHONE       ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPhone" ] )
#define IS_IPOD         ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPod touch" ] )
#define IS_IOS7         ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_IPHONE_5     ([[UIScreen mainScreen] bounds].size.height == 568.0)
#define IS_IPHONE_5_ABOVE     ([[UIScreen mainScreen] bounds].size.height > 568.0)
#define IS_IPHONE_4     ([[UIScreen mainScreen] bounds].size.height == 480.0)


#define TRMinVideoLength 3
#define TRMaxVideoLength 8