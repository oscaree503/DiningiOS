//
//  MediaEditViewController.m
//  VIND
//
//  Created by Vinay Raja on 24/08/14.
//
//

#import "MediaEditViewController.h"
#import "SCAssetExportSession.h"
#import "SCVideoPlayerView.h"
#import "SCFilterSwitcherView.h"
#import "SCRecorder.h"
#import "ActivityIndicator.h"

//#import "PostShareViewController.h"
#import "PreLoadHeader.h"

@interface MediaEditViewController () <SCPlayerDelegate, UITextFieldDelegate>
{
    SCPlayer *_player;
    NSArray *ciFilters;
    
    NSInteger selectedFilterIndex;
}

@property (weak, nonatomic) IBOutlet SCFilterSwitcherView *filterSwitcherView;
@property (weak, nonatomic) IBOutlet UIButton *overlayButton;
@property (weak, nonatomic) IBOutlet UIButton *textButton;
@property (weak, nonatomic) IBOutlet UIButton *addFilterButton;
@property (weak, nonatomic) IBOutlet UIScrollView *filterSelecter;
@property (weak, nonatomic) IBOutlet UIButton *colorChooser;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIView *colorPickerView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIView *sizePickerView;
@property (weak, nonatomic) IBOutlet UIButton *sizePickerButton;
@property (weak, nonatomic) IBOutlet UIButton *normalSizePickerButton;
@property (weak, nonatomic) IBOutlet UIButton *largerSizePickerButton;
@property (weak, nonatomic) IBOutlet UIButton *smallerSizePickerButton;
@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UITextField *overlayTextField;
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
@property (weak, nonatomic) IBOutlet UIView *smallerOverlayView;
@property (weak, nonatomic) IBOutlet UITextField *smallerOverlayTextField;
@property (weak, nonatomic) IBOutlet UIImageView *smallerLogoImageView;
@property (weak, nonatomic) IBOutlet UIView *largerOverlayView;
@property (weak, nonatomic) IBOutlet UITextField *largerOverlayTextField;
@property (weak, nonatomic) IBOutlet UIImageView *largerLogoImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) UIView *selectedSizeView;
@property (weak, nonatomic) UIImageView *selectedSizeImageView;
@property (weak, nonatomic) UITextField *selectedSizeTextField;
@property (strong, nonatomic) NSString *selectedSizeLogoName;

@end

@implementation MediaEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _overlayButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    _overlayButton.layer.borderWidth = 2;
    
    _textButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    _textButton.layer.borderWidth = 2;
    
    _addFilterButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    _addFilterButton.layer.borderWidth = 2;
    
    selectedFilterIndex = 0;

    _selectedSizeImageView = _logoImageView;
    _selectedSizeTextField = _overlayTextField;
    _selectedSizeView = _overlayView;
    _selectedSizeLogoName = @"overlayGLogo";

    _overlayView.hidden = YES;
    _normalSizePickerButton.selected = YES;
}

- (void) viewWillAppear:(BOOL)animated
{
    
    if(appController.isFromPostShare) {
        appController.isFromPostShare = NO;
        [self dismissViewControllerAnimated:NO completion:nil];
        return;
    }
    
    [super viewWillAppear:animated];
 
    [self.navigationController setNavigationBarHidden:YES];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self setupFilters];
    });
    
    if (IS_IOS7) {
        ciFilters = @[[NSNull null], @"CIPhotoEffectNoir", @"CIPhotoEffectChrome", @"CIPhotoEffectInstant", @"CIPhotoEffectTonal", @"CIPhotoEffectFade"];

    }
    else {
        ciFilters = nil;
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Filters not available" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];

    }
    

    //[self scrollviewForImageFilters];

    if (_isMediaTypeImage) {
        _filterSwitcherView.hidden = YES;
        _previewImageView.hidden = NO;
        
        _playButton.hidden = YES;
        _previewImageView.image = [UIImage imageWithContentsOfFile:_mediaPath];
        [_previewImageView setContentMode:UIViewContentModeScaleAspectFill];

    }
    else {
        _filterSwitcherView.hidden = NO;
        _previewImageView.hidden = YES;
        
        if (IS_IOS7) {
            self.filterSwitcherView.filterGroups = @[
                                                     [NSNull null],
                                                     [SCFilterGroup filterGroupWithFilter:[SCFilter filterWithName:@"CIPhotoEffectNoir"]],
                                                     [SCFilterGroup filterGroupWithFilter:[SCFilter filterWithName:@"CIPhotoEffectChrome"]],
                                                     [SCFilterGroup filterGroupWithFilter:[SCFilter filterWithName:@"CIPhotoEffectInstant"]],
                                                     [SCFilterGroup filterGroupWithFilter:[SCFilter filterWithName:@"CIPhotoEffectTonal"]],
                                                     [SCFilterGroup filterGroupWithFilter:[SCFilter filterWithName:@"CIPhotoEffectFade"]]
                                                     ];
        }
        else {
            self.filterSwitcherView.filterGroups = nil;
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Filters not available" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
        
        
        self.filterSwitcherView.disabled = NO;
        _player = [SCPlayer player];
        if (!_mediaPath) {
            [_player setItemByAsset:_recordSession.assetRepresentingRecordSegments];
            
        }
        else {
            [_player setItemByStringPath:_mediaPath];
        }

        self.filterSwitcherView.player = _player;
        self.filterSwitcherView.SCImageView.viewMode = SCImageViewModeFillAspectRatio;

        
        _player.shouldLoop = NO;
        

        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

        _playButton.hidden = YES;

        [_player play];

    }
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    if (!_isMediaTypeImage) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (IBAction)playVideo:(id)sender
{
    [_player seekToTime:kCMTimeZero];
    [_player play];
    
    _playButton.hidden = YES;
    _previewImageView.hidden = YES;
}


-(void)itemDidFinishPlaying:(NSNotification*)notif {
    NSLog(@"finish playing");
    _playButton.hidden = NO;
    
    if (!_previewImageView.image)
    {
        _previewImageView.image = [self firstFrameOfVideo];
        
    }

}


- (void) setupFilters
{
    UIImage *origImage = nil;
    if (_isMediaTypeImage) {
        origImage = [UIImage imageWithContentsOfFile:_mediaPath];
    }
    else {
        origImage = [self firstFrameOfVideo];
    }
    
    UIImage *squareImage = [self squareImageFromImage:origImage scaledToSize:40];
    
    CIImage *original = [CIImage imageWithCGImage:squareImage.CGImage];

    for (NSInteger tag = 0; tag < 6; tag++) {
        CIImage *result = original;
        if (IS_IOS7) {
            if (tag != 0) {
                CIFilter *ciFilter = [CIFilter filterWithName:[ciFilters objectAtIndex:tag]];
                [ciFilter setValue:result forKey:kCIInputImageKey];
                result = [ciFilter valueForKey:kCIOutputImageKey];
            }
        }
        
        CGImageRef moi3 = [[CIContext contextWithOptions:nil]
                           createCGImage:result
                           fromRect:original.extent];
        UIImage *moi4 = [UIImage imageWithCGImage:moi3];
        CGImageRelease(moi3);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIView *subview = [_filterSelecter viewWithTag:tag];
            if ([subview isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton*)subview;
                [btn setImage:moi4 forState:UIControlStateNormal];
                [btn setTitle:@"" forState:UIControlStateNormal];
                btn.layer.borderWidth = 2;
                btn.layer.borderColor = [UIColor whiteColor].CGColor;
            }
        });
    }
    
    
}

- (UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize {
    CGAffineTransform scaleTransform;
    CGPoint origin;
    
    if (image.size.width > image.size.height) {
        CGFloat scaleRatio = newSize / image.size.height;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        
        origin = CGPointMake(-(image.size.width - image.size.height) / 2.0f, 0);
    } else {
        CGFloat scaleRatio = newSize / image.size.width;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        
        origin = CGPointMake(0, -(image.size.height - image.size.width) / 2.0f);
    }
    
    CGSize size = CGSizeMake(newSize, newSize);
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, scaleTransform);
    
    [image drawAtPoint:origin];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}


- (UIImage*)firstFrameOfVideo
{
    AVAsset *asset = nil;
    if (_mediaPath) {
        asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:_mediaPath]];
    }
    else {
        asset = _recordSession.assetRepresentingRecordSegments;
    }
    
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMake(1, 1);
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationUp];
    
    return thumbnail;
    
}


- (IBAction)toggleOverlay:(UIButton*)sender
{
    if (!_filterSelecter.hidden) {
        [self toggleFilterView:nil];
    }

    [self toggleColorPicker:_colorChooser];
    
//    if (sender.selected) {
//        sender.selected = NO;
//        _overlayView.hidden = NO;
//        _colorChooser.hidden = NO;
//        //_textButton.enabled = YES;
//    }
//    else {
//        sender.selected = YES;
//        _overlayView.hidden = YES;
//        _colorChooser.hidden = YES;
//        //_textButton.enabled = NO;
//
//    }
}

- (IBAction)editText:(UIButton*)sender
{
    if (!_filterSelecter.hidden) {
        [self toggleFilterView:nil];
    }
    if ([_selectedSizeTextField isFirstResponder]) {
        [_selectedSizeTextField resignFirstResponder];
    }
    else {
        [_selectedSizeTextField becomeFirstResponder];
    }
}

- (IBAction)backButtonAction:(id)sender
{
    [_player pause];

    [self.navigationController setNavigationBarHidden:YES animated:YES];

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)toggleFilterView:(UIButton*)sender
{
    _filterSelecter.hidden = !_filterSelecter.hidden;
    
    if (!_filterSelecter.hidden) {
        //_addFilterButton.layer.borderColor = [[UIColor redColor] CGColor];
        _addFilterButton.layer.borderColor = [[UIColor colorWithRed:85/255.0 green:153/255.0 blue:235/255.0 alpha:1.0] CGColor ];
        _overlayButton.hidden = YES;
        _textButton.hidden = YES;
        _sizePickerButton.hidden = YES;
    }
    else {
        _addFilterButton.layer.borderColor = [[UIColor whiteColor] CGColor];
        _overlayButton.hidden = NO;
        _textButton.hidden = NO;
        _sizePickerButton.hidden = NO;
    }
    
    //_colorChooser.hidden = !_colorChooser.hidden;
    
}

- (IBAction)toggleSizePickerView:(UIButton*)sender
{
    _sizePickerView.hidden = !_sizePickerView.hidden;
    
    if (!_sizePickerView.hidden) {
        _overlayButton.hidden = YES;
        _textButton.hidden = YES;
        _addFilterButton.hidden = YES;
        sender.selected = YES;
        
    }
    else {
        _overlayButton.hidden = NO;
        _textButton.hidden = NO;
        _addFilterButton.hidden = NO;
        sender.selected = NO;
    }
    
    //_colorChooser.hidden = !_colorChooser.hidden;
    
}


- (IBAction)toggleColorPicker:(id)sender
{
    
}

- (IBAction)changeSize:(UIButton*)sender
{
    if ([_smallerSizePickerButton isEqual:sender]) {
        _largerSizePickerButton.selected = NO;
        _normalSizePickerButton.selected = NO;
        
        _smallerOverlayView.hidden = NO;
        _overlayView.hidden = YES;
        _largerOverlayView.hidden = YES;
        
        _smallerOverlayTextField.text = _selectedSizeTextField.text;
        
        _selectedSizeView = _smallerOverlayView;
        _selectedSizeImageView = _smallerLogoImageView;
        _selectedSizeTextField = _smallerOverlayTextField;
        _selectedSizeLogoName = @"overlayGLogo_smaller";

    }
    else if ([_largerSizePickerButton isEqual:sender]) {
        _smallerSizePickerButton.selected = NO;
        _normalSizePickerButton.selected = NO;
        
        _smallerOverlayView.hidden = YES;
        _overlayView.hidden = YES;
        _largerOverlayView.hidden = NO;

        _largerOverlayTextField.text = _selectedSizeTextField.text;
        
        _selectedSizeView = _largerOverlayView;
        _selectedSizeImageView = _largerLogoImageView;
        _selectedSizeTextField = _largerOverlayTextField;
        _selectedSizeLogoName = @"overlayGLogo_larger";

        
    }
    else if ([_normalSizePickerButton isEqual:sender]) {
        _largerSizePickerButton.selected = NO;
        _smallerSizePickerButton.selected = NO;
        
        _smallerOverlayView.hidden = YES;
        _overlayView.hidden = NO;
        _largerOverlayView.hidden = YES;
        
        _overlayTextField.text = _selectedSizeTextField.text;
        
        _selectedSizeView = _overlayView;
        _selectedSizeImageView = _logoImageView;
        _selectedSizeTextField = _overlayTextField;
        _selectedSizeLogoName = @"overlayGLogo";

    }
    sender.selected = YES;
}

- (IBAction)selectFilter:(UIButton*)sender
{
    NSInteger tag = sender.tag;
    
    if (tag == selectedFilterIndex) {
        return;
    }
    
    selectedFilterIndex = tag;
    
    if (_isMediaTypeImage) {
        CIImage *original = [CIImage imageWithContentsOfURL:[NSURL fileURLWithPath:_mediaPath]];
        CIImage *result = original;
        if (IS_IOS7) {
            if (tag != 0) {
                CIFilter *ciFilter = [CIFilter filterWithName:[ciFilters objectAtIndex:tag]];
                [ciFilter setValue:result forKey:kCIInputImageKey];
                result = [ciFilter valueForKey:kCIOutputImageKey];
            }
        }
        
        CGImageRef moi3 = [[CIContext contextWithOptions:nil]
                           createCGImage:result
                           fromRect:original.extent];
        UIImage *moi4 = [UIImage imageWithCGImage:moi3];
        CGImageRelease(moi3);
        _previewImageView.image = moi4;
        [_previewImageView setContentMode:UIViewContentModeScaleAspectFill];
    }
    else {
        CIImage *original = _previewImageView.image.CIImage;
        if (!original) {
            original = [CIImage imageWithCGImage:_previewImageView.image.CGImage];
        }
        CIImage *result = original;
        if (IS_IOS7) {
            if (tag != 0) {
                CIFilter *ciFilter = [CIFilter filterWithName:[ciFilters objectAtIndex:tag]];
                [ciFilter setValue:result forKey:kCIInputImageKey];
                result = [ciFilter valueForKey:kCIOutputImageKey];
            }
        }
        
        CGImageRef moi3 = [[CIContext contextWithOptions:nil]
                           createCGImage:result
                           fromRect:original.extent];
        UIImage *moi4 = [UIImage imageWithCGImage:moi3];
        CGImageRelease(moi3);
        _previewImageView.image = moi4;

        [_filterSwitcherView selectFilterAtIndex:tag];
    }
}

- (void) goToMediaShareViewWithMediaPath:(NSString*)mPath {
    
    if(mPath == nil || [mPath isEqualToString:@""]) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Please take your video before proceeding." duration:1.0f];
        return;
    }
    appController.uploadedMediaPath = mPath;
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navController = (UINavigationController *)[mainStoryBoard instantiateViewControllerWithIdentifier:@"postShareNav"];
    [self presentViewController:navController animated:NO completion:nil];
    
//    PostTagViewController *pageViewController = (PostTagViewController *)[mainStoryBoard instantiateViewControllerWithIdentifier:@"postTagPage"];
//    [self.navigationController pushViewController:navController animated:YES];
    
//    shareCtrl.isMediaTypeImage = _isMediaTypeImage;
    
//    NSLog(@"%@", self.navigationController.parentViewController.storyboard);
}

- (IBAction)doneButtonAction:(id)sender
{
    NSString *finalMediaPath = nil;
    if (_isMediaTypeImage) {
        
        UIImage *finalImage = _previewImageView.image;
        if (!_selectedSizeView.hidden) {
            UIImage *fgImage = [self imageWithView:_selectedSizeView];
            UIImage *bgImage = _previewImageView.image;
            CGSize fgSize = fgImage.size;
            CGSize bgSize = bgImage.size;
            
            CGPoint center = CGPointMake(bgSize.width / 4, bgSize.height / 4);
            
            //finalImage = [self drawImage:fgImage inImage:bgImage atPoint:CGPointMake(center.x - fgSize.width / 2, center.y - fgSize.height / 2)];
            CGRect a = [_selectedSizeView convertRect:_selectedSizeView.bounds toView:_previewImageView];
            if (! IS_IPHONE_5) {
                float factor = 320.0 / 230.0;
                a = CGRectMake(a.origin.x * factor, a.origin.y * factor, a.size.width * factor, a.size.height * factor);
            }
            finalImage = [self drawImage:fgImage inImage:bgImage atPoint:CGPointMake(a.origin.x, a.origin.y)];

        }
        
        
        finalMediaPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"final.jpg"];
        NSData *imgData = UIImageJPEGRepresentation(finalImage, 1);
        [imgData writeToFile:finalMediaPath atomically:YES];
        
        [self goToMediaShareViewWithMediaPath:finalMediaPath];
    } else {
        
        [_player pause];
        [[ActivityIndicator currentIndicator] show];
        
        finalMediaPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"final.mp4"];
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];

        
        void(^completionHandler)(NSError *error) = ^(NSError *error) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            if (error == nil) {
                //[self.recordSession saveToCameraRoll];
                
                 
                 if (_selectedSizeView.hidden) {
                     [[ActivityIndicator currentIndicator] hide];
                     
                     [self goToMediaShareViewWithMediaPath:finalMediaPath];
                 }
                 else {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self videoOutput:[AVAsset assetWithURL:[NSURL fileURLWithPath:finalMediaPath]]];
                     });
                 }
                 
                
            } else {
                [[ActivityIndicator currentIndicator] hide];

                [[[UIAlertView alloc] initWithTitle:@"Failed to save" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        };

//        if (_filterSwitcherView.selectedFilterGroup) {
//            selectedFilterIndex = [_filterSwitcherView.filterGroups indexOfObject:_filterSwitcherView.selectedFilterGroup];
//        }
//        if (selectedFilterIndex == 0) {
//            if (!_mediaPath) {
//                _recordSession.outputUrl = [NSURL fileURLWithPath:finalMediaPath];
//                [self.recordSession mergeRecordSegments:completionHandler];
//            }
//            else {
//                NSFileManager *fm = [NSFileManager defaultManager];
//                NSError *err = nil;
//                [fm removeItemAtPath:finalMediaPath error:&err];
//                [fm copyItemAtPath:_mediaPath toPath:finalMediaPath error:&err];
//                completionHandler(err);
//            }
//        } else {
//            AVAsset *vAsset;
//            
//            if (!_mediaPath) {
//                vAsset = _recordSession.assetRepresentingRecordSegments;
//            }
//            else {
//                vAsset = [AVAsset assetWithURL:[NSURL fileURLWithPath:_mediaPath]];
//            }
        
        AVAsset *vAsset;
        
        if (!_mediaPath) {
            vAsset = _recordSession.assetRepresentingRecordSegments;
        }
        else {
            vAsset = [AVAsset assetWithURL:[NSURL fileURLWithPath:_mediaPath]];
        }

        SCFilterGroup *selectedFG = nil;
        
        if ([_filterSwitcherView.selectedFilterGroup isEqual:[NSNull null]]){
            selectedFG = nil;
        }
        else {
            selectedFG = _filterSwitcherView.selectedFilterGroup;
        }

        SCAssetExportSession *exportSession = [[SCAssetExportSession alloc] initWithAsset:vAsset];
        exportSession.filterGroup = selectedFG;
        exportSession.sessionPreset = SCAssetExportSessionPresetHighestQuality;
        exportSession.outputUrl = [NSURL fileURLWithPath:finalMediaPath];
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.keepVideoSize = NO;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            completionHandler(exportSession.error);
        }];
        


    }
    
    
}

- (void)videoOutput:(AVAsset*)videoAsset
{
    // 1 - Early exit if there's no video file selected
    if (!videoAsset) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Load a Video Asset First"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // 2 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    // 3 - Video track
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                        ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                         atTime:kCMTimeZero error:nil];
    
    
    // 3.1 - Create AVMutableVideoCompositionInstruction
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    
    // 3.2 - Create an AVMutableVideoCompositionLayerInstruction for the video track and fix the orientation.
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
    BOOL isVideoAssetPortrait_  = NO;
    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ = UIImageOrientationRight;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ =  UIImageOrientationLeft;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
        videoAssetOrientation_ =  UIImageOrientationUp;
    }
    if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
        videoAssetOrientation_ = UIImageOrientationDown;
    }
    //[videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
    [videolayerInstruction setOpacity:0.0 atTime:videoAsset.duration];
    
    
    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    
    //videoTrack.preferredTransform = CGAffineTransformMake(videoTransform.a, videoTransform.b, videoTransform.c, videoTransform.d, 0, 0);
    
    CGAffineTransform applyTransform = videoTransform;
    
    if (videoTransform.tx != 0) {
        if (videoTransform.tx != videoAssetTrack.naturalSize.width) {
            applyTransform.tx = videoAssetTrack.naturalSize.width;
        }
    }
    if (videoTransform.ty != 0) {
        if (videoTransform.ty != videoAssetTrack.naturalSize.height) {
            applyTransform.ty = videoAssetTrack.naturalSize.height;
        }
    }
    
    [videolayerInstruction setTransform:applyTransform atTime:kCMTimeZero];

    CGSize naturalSize;
    if(isVideoAssetPortrait_){
        naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
    } else {
        naturalSize = videoAssetTrack.naturalSize;

    }
    
    float renderWidth, renderHeight, renderScale;
    
    
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    //mainCompositionInst.renderScale = renderScale;
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    
    [self applyVideoEffectsToComposition:mainCompositionInst size:naturalSize];
    
    //Audio Track
    AVMutableCompositionTrack *audioTrack = nil;
    
    
    
    
    if([[videoAsset tracksWithMediaType:AVMediaTypeAudio] count] != 0) {
        audioTrack = [videoAsset tracksWithMediaType:AVMediaTypeAudio][0];
    }
    
    if (audioTrack) {
        AVMutableCompositionTrack *audioCompositionTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [audioCompositionTrack insertTimeRange:audioTrack.timeRange ofTrack:audioTrack atTime:kCMTimeZero error:nil];
    }

    // 4 - Get path
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPathDocs =  [NSTemporaryDirectory() stringByAppendingPathComponent:
                             [NSString stringWithFormat:@"FinalVideo.mp4"]];
    [[NSFileManager defaultManager] removeItemAtPath:myPathDocs error:nil];
    NSURL *url = [NSURL fileURLWithPath:myPathDocs];
    
    // 5 - Create exporter
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                      presetName:AVAssetExportPresetMediumQuality];
    exporter.outputURL=url;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = mainCompositionInst;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self exportDidFinish:exporter];
        });
    }];
}

- (void)exportDidFinish:(AVAssetExportSession*)session {
    
    if (session.status == AVAssetExportSessionStatusCompleted) {
        
        [[ActivityIndicator currentIndicator] hide];
        NSURL *outputURL = session.outputURL;
        
        [self goToMediaShareViewWithMediaPath:outputURL.resourceSpecifier];
    }
    
}

- (void)applyVideoEffectsToComposition:(AVMutableVideoComposition *)composition size:(CGSize)size
{
    // 1 - set up the overlay
    CALayer *overlayLayer = [CALayer layer];
    
    float widthScale = size.width / _filterSwitcherView.frame.size.width;
    float heightScale = size.height / _filterSwitcherView.frame.size.height;

    //[self changeScaleforView:_overlayView scale:2];
    UIImage *overlayImage = [self imageWithView:_selectedSizeView];
    
    [overlayLayer setContents:(id)[overlayImage CGImage]];
    
    CGSize fgSize = CGSizeMake(overlayImage.size.width * widthScale, overlayImage.size.height * heightScale);
    
    CGPoint center = CGPointMake(size.width / 2, size.height / 2);
    
    overlayLayer.frame = CGRectMake(center.x - fgSize.width / 2, center.y - fgSize.height / 2, fgSize.width, fgSize.height);
    
    CGRect a = [_selectedSizeView convertRect:_selectedSizeView.bounds toView:_previewImageView];
    if (! IS_IPHONE_5) {
        float factor = 320.0 / 230.0;
        a = CGRectMake(a.origin.x * factor, a.origin.y * factor, a.size.width * factor, a.size.height * factor);
    }
    
    overlayLayer.frame = CGRectMake( a.origin.x * widthScale, (320 - a.size.height - a.origin.y) * heightScale, a.size.width * widthScale, a.size.height * heightScale);

    //[overlayLayer setMasksToBounds:YES];
    
    // 2 - set up the parent layer
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, size.width, size.height);
    videoLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer];
    
    // 3 - apply magic
    composition.animationTool = [AVVideoCompositionCoreAnimationTool
                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
}


- (UIImage *) imageWithView:(UIView *)view
{
    //[self changeScaleforView:view scale:2];
    
    CGSize size = view.bounds.size;
    if (! IS_IPHONE_5) {
        float factor = 320.0 / 230.0;
        size = CGSizeMake(size.width * factor, size.height * factor);
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

- (void)changeScaleforView:(UIView *)aView scale:(CGFloat)scale
{
    [aView.subviews enumerateObjectsUsingBlock:^void(UIView *v, NSUInteger idx, BOOL *stop)
     {
         if([v isKindOfClass:[UITextField class]]) {
             v.layer.contentsScale = scale;
         } else
             if([v isKindOfClass:[UIImageView class]]) {
                 // labels and images
                 // v.layer.contentsScale = scale; won't work
                 
                 // if the image is not "@2x", you could subclass UIImageView and set the name of the @2x
                 // on it as a property, then here you would set this imageNamed as the image, then undo it later
             } else
                 if([v isMemberOfClass:[UIView class]]) {
                     // container view
                     [self changeScaleforView:v scale:scale];
                 }
     } ];
}

- (UIImage*) drawImage:(UIImage*) fgImage
              inImage:(UIImage*) bgImage
              atPoint:(CGPoint)  point
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(bgImage.size.width/2, bgImage.size.height/2), FALSE, 2);
    [bgImage drawInRect:CGRectMake( 0, 0, bgImage.size.width/2, bgImage.size.height/2)];
    
    float factor = 1;
    if (! IS_IPHONE_5) {
        factor = 320.0 / 230.0;
    }

    [fgImage drawInRect:CGRectMake( point.x, point.y, fgImage.size.width * factor, fgImage.size.height * factor)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - UITextFieldDelegate

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    NSUInteger newLength = [textField.text length] + [string length] - range.length;
//    return (newLength > 12) ? NO : YES;
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Util

-(UIImage *)imageNamed:(NSString*)name withColor:(UIColor *)color {
    // load the image
    
    UIImage *img = [UIImage imageNamed:name];
    
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContext(img.size);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
}

@end
