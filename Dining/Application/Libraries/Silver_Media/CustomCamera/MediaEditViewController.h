//
//  MediaEditViewController.h
//  VIND
//
//  Created by Vinay Raja on 24/08/14.
//
//

#import <UIKit/UIKit.h>
#import "SCRecorder.h"

@interface MediaEditViewController : UIViewController

@property (nonatomic, assign) BOOL isMediaTypeImage;
@property (nonatomic, strong) NSString *mediaPath;
@property (nonatomic, strong) SCRecordSession *recordSession;

@end
