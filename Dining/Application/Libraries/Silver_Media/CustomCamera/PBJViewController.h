//
//  PBJViewController.h
//  Vision
//
//  Created by Patrick Piemonte on 7/23/13.
//  Copyright (c) 2013 Patrick Piemonte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBJViewController : UIViewController
{
    NSTimer *timer;
}
@property (nonatomic, assign) float maxDuration;
@property (nonatomic,retain) NSTimer *durationTimer;
@property (nonatomic,assign) float duration;

@end
