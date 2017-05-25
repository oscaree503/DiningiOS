//
//  CustomCameraViewController.m
//  VIND
//
//  Created by Vinay Raja on 23/08/14.
//
//

#import "CustomCameraViewController.h"
#import "SCAudioTools.h"
#import "SCRecorderFocusView.h"
#import "SCRecorder.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MediaEditViewController.h"
#import <AudioToolbox/AudioServices.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "PreLoadHeader.h"



#define kVideoPreset AVCaptureSessionPreset640x480

@interface CustomCameraViewController () <SCRecorderDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    SCRecorder *_recorder;
    UIImage *_photo;
    SCRecordSession *_recordSession;
    
    BOOL _mediaTypeImage, isLoading;
    NSString *_mediaPath;
    
    BOOL noCameraMode;
}

@property (strong, nonatomic) IBOutlet UIView *previewView, *containerView, *topView, *bottomView;
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIImageView *captureButtonView;
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *recordImageView;
@property (weak, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressGSR;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapGSR;
@property (weak, nonatomic) IBOutlet UIImageView *previewImage;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *switchMode;
@property (weak, nonatomic) IBOutlet UIButton *switchCamera;
@property (weak, nonatomic) IBOutlet UIButton *flashModeButton;

@property (strong, nonatomic) IBOutlet UIButton *btnLockUnlock;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) IBOutlet UILabel *labelTimer;

@property (strong, nonatomic) SCRecorderFocusView *focusView;
@property (assign, nonatomic) int hours, minutes, seconds, secondsLeft;


- (IBAction)switchCameraMode:(id)sender;
- (IBAction)switchFlash:(id)sender;

- (IBAction)backButton:(id)sender;
- (IBAction)btnLockUnlockClicked:(id)sender;
@end

@implementation CustomCameraViewController

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
    isLoading = NO;
    [self setupView];
}

- (void) setupView {
    
    noCameraMode = NO;
    _recorder = [SCRecorder recorder];
    if (!_recorder) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Camera not available" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        noCameraMode = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadFromLibrary:nil];
        });
        return;
    }
    
    
    CGRect previewViewFrame = self.previewView.frame;
    previewViewFrame.size.width = [UIScreen mainScreen].bounds.size.width;
    previewViewFrame.size.height = [UIScreen mainScreen].bounds.size.height - self.topView.frame.size.height - self.bottomView.frame.size.height;
    previewViewFrame.origin.x = 0;
    previewViewFrame.origin.y = self.topView.frame.size.height;
    
    [self.previewView setFrame:previewViewFrame];
    
    
    [self.loadingView setFrame:CGRectMake(0, 0, previewViewFrame.size.width, previewViewFrame.size.height)];
    
    UIView *previewView = self.previewView;
    _recorder.previewView = previewView;
    
    self.focusView = [[SCRecorderFocusView alloc] initWithFrame:previewView.bounds];
    self.focusView.recorder = _recorder;
    [previewView addSubview:self.focusView];
    
    [_recorder openSession:^(NSError *sessionError, NSError *audioError, NSError *videoError, NSError *photoError) {
        NSLog(@"==== Opened session ====");
        NSLog(@"Session error: %@", sessionError.description);
        NSLog(@"Audio error : %@", audioError.description);
        NSLog(@"Video error: %@", videoError.description);
        NSLog(@"Photo error: %@", photoError.description);
        NSLog(@"=======================");
        //[self prepareCamera];
        
        
    }];
    
    [self setUpToInitialState];
    
    [previewView bringSubviewToFront:self.btnLockUnlock];
    [previewView bringSubviewToFront:self.labelTimer];
    
}

-(void)setUpToInitialState {
    
    //_tapGSR.enabled = NO;
    
    _recorder.sessionPreset = AVCaptureSessionPresetPhoto;
    _recorder.audioEnabled = YES;
    _recorder.delegate = self;
    
    _recorder.flashMode = SCFlashModeAuto;
    //[_flashModeButton setImage:[UIImage imageNamed:@"flash_icon_off"] forState:UIControlStateNormal];
    //_captureButtonView.image = [UIImage imageNamed:@"camera_icon_off"];
    _recordImageView.hidden = YES;
    _instructionLabel.text = @"Tap to take picture";
    _longPressGSR.enabled = NO;
    _tapGSR.enabled = YES;
    _progressBar.progress = 0;
    _switchMode.selected = NO;
    _labelTimer.hidden = YES;
    _btnLockUnlock.hidden = YES;
    _switchCamera.enabled = YES;
    [_btnLockUnlock setSelected:NO];
    
    _nextButton.hidden = YES;
    //    _secondsLeft = (IS_IPHONE_4) ? 600 : 600;
    _secondsLeft = TRMaxVideoLength;
    _labelTimer.text = @"";
    
    // Silver_Media Change
    _nextButton.hidden = YES;
    _mediaPath = nil;
    
    if ([_recorder.sessionPreset isEqualToString:AVCaptureSessionPresetPhoto]) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        } completion:^(BOOL finished) {
            _recorder.sessionPreset = kVideoPreset;
            _recorder.flashMode = SCFlashModeOff;
            //[_flashModeButton setImage:[UIImage imageNamed:@"flash_icon_off"] forState:UIControlStateNormal];
            //_captureButtonView.image = [UIImage imageNamed:@"record_on"];
            [_recordImageView setHidden:NO];
            //_instructionLabel.text = @"Touch and hold to record";
            
            [_recorder.recordSession removeAllSegments];
            _mediaTypeImage = NO;
            //_flashModeButton.hidden = YES;
            _nextButton.hidden = NO;
            _recordImageView.highlighted = NO;
            _btnLockUnlock.hidden = NO;
            if (![_btnLockUnlock isSelected]) {
                _instructionLabel.text = @"Touch and hold to record";
                _longPressGSR.enabled = YES;
                _tapGSR.enabled = NO;
            }
            else{
                _instructionLabel.text = @"Tap to start recording";
                _longPressGSR.enabled = NO;
                _tapGSR.enabled = YES;
                
            }
            _labelTimer.hidden = NO;
            
            
        }];
    }
}


- (void)recorder:(SCRecorder *)recorder didReconfigureAudioInput:(NSError *)audioInputError {
    NSLog(@"Reconfigured audio input: %@", audioInputError);
}

- (void)recorder:(SCRecorder *)recorder didReconfigureVideoInput:(NSError *)videoInputError {
    NSLog(@"Reconfigured video input: %@", videoInputError);
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBarHidden = YES;
    [self setUpToInitialState];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (noCameraMode && !_mediaPath) {
        [self loadFromLibrary:nil];
    }
    else {
        [self prepareCamera];
        
        [_recorder startRunningSession];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    _mediaPath = nil;
    [_recorder endRunningSession];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    //    self.navigationController.navigationBarHidden = NO;
}

// Focus
- (void)recorderDidStartFocus:(SCRecorder *)recorder {
    [self.focusView showFocusAnimation];
}

- (void)recorderDidEndFocus:(SCRecorder *)recorder {
    [self.focusView hideFocusAnimation];
}

- (void)recorderWillStartFocus:(SCRecorder *)recorder {
    [self.focusView showFocusAnimation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareCamera {
    if (_recorder.recordSession == nil) {
        
        SCRecordSession *session = [SCRecordSession recordSession];
        //        session.suggestedMaxRecordDuration = CMTimeMakeWithSeconds((IS_IPHONE_4) ? 600 : 600,10000);//20, 10000//600,360000
        session.suggestedMaxRecordDuration = CMTimeMakeWithSeconds(TRMaxVideoLength, 10000);
        session.videoSizeAsSquare = YES;
        _recorder.recordSession = session;
    }
}

- (IBAction)btnLockUnlockClicked:(id)sender{
    
    if ([_btnLockUnlock isSelected]) {
        [_btnLockUnlock setSelected:NO];
        _longPressGSR.enabled = YES;
        _tapGSR.enabled = NO;
        
        _instructionLabel.text = @"Touch and hold to record";
    }
    else{
        _longPressGSR.enabled = NO;
        _tapGSR.enabled = YES;
        [_btnLockUnlock setSelected:YES];
        _instructionLabel.text = @"Tap to start recording";
        
    }
    
}

- (void)recorder:(SCRecorder *)recorder didCompleteRecordSession:(SCRecordSession *)recordSession {
    [self finishSession:recordSession];
}

- (void)recorder:(SCRecorder *)recorder didInitializeAudioInRecordSession:(SCRecordSession *)recordSession error:(NSError *)error {
    if (error == nil) {
        NSLog(@"Initialized audio in record session");
    } else {
        NSLog(@"Failed to initialize audio in record session: %@", error.localizedDescription);
    }
}

- (void)recorder:(SCRecorder *)recorder didInitializeVideoInRecordSession:(SCRecordSession *)recordSession error:(NSError *)error {
    if (error == nil) {
        NSLog(@"Initialized video in record session");
    } else {
        NSLog(@"Failed to initialize video in record session: %@", error.localizedDescription);
    }
}

- (void)recorder:(SCRecorder *)recorder didBeginRecordSegment:(SCRecordSession *)recordSession error:(NSError *)error {
    
    //    if ([recorder isRecording]) {
    //            _switchCamera.enabled = NO;
    //    }
    _mediaPath = nil;
    
    
    
    NSLog(@"Began record segment: %@", error);
}

- (void)recorder:(SCRecorder *)recorder didEndRecordSegment:(SCRecordSession *)recordSession segmentIndex:(NSInteger)segmentIndex error:(NSError *)error {
    NSLog(@"End record segment %d: %@", (int)segmentIndex, error);
    _nextButton.hidden = NO;
    
    _mediaPath = nil;
}

- (void)recorder:(SCRecorder *)recorder didAppendVideoSampleBuffer:(SCRecordSession *)recordSession {
    [self updateDurationWithRecording];
    
}

- (void)finishSession:(SCRecordSession *)recordSession {
    
    _mediaTypeImage = NO;
    _mediaPath = nil;
    
    [recordSession endRecordSegment:^(NSInteger segmentIndex, NSError *error) {
        
        //        _recordSession = recordSession;
        
        //_recorder.recordSession = recordSession;
        //[self prepareCamera];
    }];
}

- (IBAction)handleLongPress:(UILongPressGestureRecognizer*)longPressGS {
    
    
    if (longPressGS.state == UIGestureRecognizerStateBegan) {
        
        // [self playNotificationSound];
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            AVAudioSession *session = [AVAudioSession sharedInstance];
            NSError *setCategoryError = nil;
            if (![session setCategory:AVAudioSessionCategoryPlayAndRecord
                          withOptions:AVAudioSessionCategoryOptionMixWithOthers
                                error:&setCategoryError]) {
                // handle error
            }
            
            _recordImageView.highlighted = YES;
            _instructionLabel.text = @"Recording...";
            
            _captureButtonView.image = [UIImage imageNamed:@"record_off"];
            
            [_recorder record];
            _switchCamera.enabled = NO;
            [self startTimer];
            
        });
        
        
        
    } else if (longPressGS.state == UIGestureRecognizerStateEnded) {
        
        
        _switchCamera.enabled = YES;
        _recordImageView.highlighted = NO;
        _instructionLabel.text = @"Touch and hold to record";
        _captureButtonView.image = [UIImage imageNamed:@"record_on"];
        [self stopTimer];
        [_recorder pause];
        
        //[self playNotificationSound];
        
    }
}

- (IBAction)handleTap:(UITapGestureRecognizer*)tapGS {
    
    
    if ([_recorder.sessionPreset isEqualToString:AVCaptureSessionPresetPhoto]) {
        
        if (tapGS.state == UIGestureRecognizerStateBegan) {
            
        }
        else if (tapGS.state == UIGestureRecognizerStateEnded) {
            _captureButtonView.image = [UIImage imageNamed:@"camera_icon_on"];
            
            
            CATransition *shutterAnimation = [CATransition animation];
            
            [shutterAnimation setDelegate:self];
            [shutterAnimation setDuration:0.6];
            
            shutterAnimation.timingFunction = UIViewAnimationCurveEaseInOut;
            [shutterAnimation setType:@"cameraIris"];
            [shutterAnimation setValue:@"cameraIris" forKey:@"cameraIris"];
            CALayer *cameraShutter = [[CALayer alloc]init];
            [cameraShutter setBounds:CGRectMake(0.0, 0.0, 320.0, 425)];
            [self.previewView.layer addSublayer:cameraShutter];
            [self.previewView.layer addAnimation:shutterAnimation forKey:@"cameraIris"];
            
            [self.previewView.layer setMasksToBounds:YES];
            [_recorder capturePhoto:^(NSError *error, UIImage *image) {
                [cameraShutter removeFromSuperlayer];
                [self.previewView.layer removeAnimationForKey:@"cameraIris"];
                if (image != nil) {
                    [self imageCaptured:image];
                } else {
                    [self showAlertViewWithTitle:@"Failed to capture photo" message:error.localizedDescription];
                }
            }];
            
        }
    }
    else{
        
        if ([_btnLockUnlock isSelected]) {
            
            
            if ([_recorder isRecording]) {
                
                _switchCamera.enabled = YES;
                _recordImageView.highlighted = NO;
                [_recorder pause];
                _instructionLabel.text = @"Tap to start recording";
                [self stopTimer];
                
                // [self playNotificationSound];
                
            }
            else {
                
                //[self playNotificationSound];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    AVAudioSession *session = [AVAudioSession sharedInstance];
                    NSError *setCategoryError = nil;
                    if (![session setCategory:AVAudioSessionCategoryPlayAndRecord
                                  withOptions:AVAudioSessionCategoryOptionMixWithOthers
                                        error:&setCategoryError]) {
                        // handle error
                    }
                    
                    _switchCamera.enabled = NO;
                    _recordImageView.highlighted = YES;
                    [_recorder record];
                    _instructionLabel.text = @"Recording...";
                    [self startTimer];
                    
                });
                
                
            }
            
            
            //[self performSelectorInBackground:@selector(playNotificationSound) withObject:nil];
            
            
            
        }
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

- (void) imageCaptured:(UIImage*)image
{
    //_nextButton.hidden = NO;
    
    UIImage *squareImage = [self squareImageFromImage:image scaledToSize:320];
    _captureButtonView.image = [UIImage imageNamed:@"camera_icon_off"];
    _previewImage.image = squareImage;
    
    //_previewImage.hidden = NO;
    //_backButton.selected = YES;
    _mediaPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"media.jpg"];
    _mediaTypeImage = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *imgData = UIImageJPEGRepresentation(squareImage, 1);
        NSError *error = nil;
        [imgData writeToFile:_mediaPath options:NSDataWritingAtomic error:&error];
        
        [self goToEditController:nil];
        
        if (error) {
            NSLog(@"error writing : %@", error);
        }
        
        
    });
    
    
    
}

- (void) updateDurationWithRecording
{
    CMTime currentTime = kCMTimeZero;
    
    if (_recorder.recordSession != nil) {
        currentTime = _recorder.recordSession.currentRecordDuration;
    }
    
    _progressBar.progress =  _recorder.recordSession.ratioRecorded;// (currentTime.value/currentTime.timescale)/20;
    NSLog(@"progress %f", _progressBar.progress);
    if (_progressBar.progress == 1.000000)
    {
        _recordImageView.highlighted = NO;
        _instructionLabel.text = @"Touch and hold to record";
        _captureButtonView.image = [UIImage imageNamed:@"record_on"];
        [_recorder pause];
        [self finishSession:_recorder.recordSession];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self goToEditController:nil];
        });
        
        //sound
    }
}


- (IBAction) backButton:(id)sender
{
    NSArray* tmpDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:NULL];
    for (NSString *file in tmpDirectory) {
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), file] error:NULL];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)switchCameraMode:(UIButton*)sender
{
    _nextButton.hidden = YES;
    _mediaPath = nil;
    sender.selected = !sender.selected;
    if ([_recorder.sessionPreset isEqualToString:AVCaptureSessionPresetPhoto]) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        } completion:^(BOOL finished) {
            _recorder.sessionPreset = kVideoPreset;
            _recorder.flashMode = SCFlashModeOff;
            [_flashModeButton setImage:[UIImage imageNamed:@"flash_icon_off"] forState:UIControlStateNormal];
            _captureButtonView.image = [UIImage imageNamed:@"record_on"];
            [_recordImageView setHidden:NO];
            //_instructionLabel.text = @"Touch and hold to record";
            
            [_recorder.recordSession removeAllSegments];
            _mediaTypeImage = NO;
            //_flashModeButton.hidden = YES;
            _nextButton.hidden = NO;
            _recordImageView.highlighted = NO;
            _btnLockUnlock.hidden = NO;
            if (![_btnLockUnlock isSelected]) {
                _instructionLabel.text = @"Touch and hold to record";
                _longPressGSR.enabled = YES;
                _tapGSR.enabled = NO;
            }
            else{
                _instructionLabel.text = @"Tap to start recording";
                _longPressGSR.enabled = NO;
                _tapGSR.enabled = YES;
                
            }
            _labelTimer.hidden = NO;
            
            
        }];
    } else {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        } completion:^(BOOL finished) {
            _recorder.sessionPreset = AVCaptureSessionPresetPhoto;
            _recorder.flashMode = SCFlashModeAuto;
            [_flashModeButton setImage:[UIImage imageNamed:@"flash_icon_off"] forState:UIControlStateNormal];
            _captureButtonView.image = [UIImage imageNamed:@"camera_icon_off"];
            _recordImageView.hidden = YES;
            _instructionLabel.text = @"Tap to take picture";
            _longPressGSR.enabled = NO;
            _tapGSR.enabled = YES;
            _progressBar.progress = 0;
            _flashModeButton.hidden = NO;
            _nextButton.hidden = YES;
            _btnLockUnlock.hidden = YES;
            _labelTimer.hidden = YES;
        }];
    }
    
}

- (IBAction)switchCamera:(id)sender
{
    if ([_recorder.sessionPreset isEqualToString:AVCaptureSessionPresetPhoto]) {
        
        [_recorder switchCaptureDevices];
        
    }
    else{
        
        if ([_recorder isRecording]) {
            return;
        }
        else{
            [_recorder switchCaptureDevices];
        }
        
    }
    
}

- (IBAction)btnLockUnlock:(id)sender {
    if ([_btnLockUnlock isSelected]) {
        [_btnLockUnlock setSelected:NO];
        _longPressGSR.enabled = YES;
        _tapGSR.enabled = NO;
    }
    else{
        _longPressGSR.enabled = NO;
        _tapGSR.enabled = YES;
        [_btnLockUnlock setSelected:YES];
    }
    
    
}



- (IBAction)switchFlash:(id)sender
{
    NSString *flashModeString = nil;
    if ([_recorder.sessionPreset isEqualToString:AVCaptureSessionPresetPhoto]) {
        switch (_recorder.flashMode) {
            case SCFlashModeAuto:
                flashModeString = @"Flash : Off";
                _recorder.flashMode = SCFlashModeOff;
                [_flashModeButton setImage:[UIImage imageNamed:@"flash_icon_off"] forState:UIControlStateNormal];
                break;
            case SCFlashModeOff:
                flashModeString = @"Flash : On";
                _recorder.flashMode = SCFlashModeOn;
                [_flashModeButton setImage:[UIImage imageNamed:@"flash_icon_on"] forState:UIControlStateNormal];
                break;
            case SCFlashModeOn:
                flashModeString = @"Flash : Light";
                _recorder.flashMode = SCFlashModeLight;
                [_flashModeButton setImage:[UIImage imageNamed:@"flash_icon_light"] forState:UIControlStateNormal];
                break;
            case SCFlashModeLight:
                flashModeString = @"Flash : Auto";
                _recorder.flashMode = SCFlashModeAuto;
                [_flashModeButton setImage:[UIImage imageNamed:@"flash_icon_auto"] forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    } else {
        switch (_recorder.flashMode) {
            case SCFlashModeOff:
                flashModeString = @"Flash : On";
                _recorder.flashMode = SCFlashModeLight;
                [_flashModeButton setImage:[UIImage imageNamed:@"flash_icon_on"] forState:UIControlStateNormal];
                break;
            case SCFlashModeLight:
                flashModeString = @"Flash : Off";
                _recorder.flashMode = SCFlashModeOff;
                [_flashModeButton setImage:[UIImage imageNamed:@"flash_icon_off"] forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }
    
    //[self.flashModeButton setTitle:flashModeString forState:UIControlStateNormal];
}

- (IBAction)goToEditController:(id)sender {
    
    if(isLoading) return;
    
    //    [commonUtils showActivityIndicatorColored:self.containerView];
    isLoading = YES;
    UIActivityIndicatorView *activityIndicator;
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator setHidden:NO];
    activityIndicator.center = self.containerView.center;
    activityIndicator.color = appController.appMainColor;
    [activityIndicator startAnimating];
    [activityIndicator.layer setZPosition:9999];
    [self.containerView addSubview:activityIndicator];
    
    
    if (sender && !_mediaTypeImage && !_mediaPath) {
        [self finishSession:_recorder.recordSession];
    }
    
    [self stopTimer];
    
    if(_mediaTypeImage) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Please take your video before proceeding." duration:1.0f];
        return;
    }
    
    
    MediaEditViewController *meVC = nil;
    //    if (IS_IPHONE_5_ABOVE) {
    meVC = [[MediaEditViewController alloc] initWithNibName:@"MediaEditViewController" bundle:nil];
    //    }
    //    else
    //    {
    //        meVC = [[MediaEditViewController alloc] initWithNibName:@"MediaEditViewController_ip3" bundle:nil];
    //    }
    
    
    //    [commonUtils hideActivityIndicator];
    
    
    
    [activityIndicator setHidden:YES];
    [activityIndicator removeFromSuperview];
    activityIndicator = nil;
    [commonUtils removeAllSubViews:self.containerView];
    isLoading = NO;
    
    [self.navigationController pushViewController:meVC animated:YES];
    
    meVC.mediaPath = _mediaPath;
    meVC.isMediaTypeImage = _mediaTypeImage;
    meVC.recordSession = _recorder.recordSession;
    
}

- (IBAction)loadFromLibrary:(id)sender {
    _nextButton.hidden = YES;
    _previewImage.hidden = YES;
    _backButton.selected = NO;
    
    _progressBar.progress = 0;
    
    [_recorder.recordSession removeAllSegments];
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.navigationBar.tintColor = [UIColor blackColor];
    picker.delegate = self;
    picker.allowsEditing = YES;
    //picker.videoMaximumDuration  = 20;
    picker.videoMaximumDuration = TRMaxVideoLength;
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage,  nil];
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    _progressBar.progress = 0;
    [_recorder.recordSession removeAllSegments];
    //NSString *temporaryPathForCopy = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp"];
    
    //NSString * path = temporaryPathForCopy;
    
    NSString *mediaType = info[@"UIImagePickerControllerMediaType"];
    
    
    if ([mediaType isEqualToString:(NSString*)kUTTypeImage]) {
        //
        //        Silver_Media Change
        //
        //        UIImage *img=[info objectForKey:UIImagePickerControllerEditedImage];
        //
        //
        //        //UIImage *squareImage = [self squareImageFromImage:img scaledToSize:320];
        //
        //        // UIImage *newImage =[self upsideDownImage :img];
        //        NSData *imgData = UIImageJPEGRepresentation(img, 1);
        //
        //        _mediaTypeImage = YES;
        //        _mediaPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"media.jpg"];
        //
        //        NSError *error = nil;
        //        [imgData writeToFile:_mediaPath options:NSDataWritingAtomic error:&error];
        //
        //        if (error) {
        //            NSLog(@"error writing : %@", error);
        //        }
        [commonUtils showVAlertSimple:@"Warning" body:@"Please switch to video mode only" duration:0.8f];
    }
    else{
        [commonUtils showActivityIndicatorColored:self.view];

        NSURL *videoURL1 = info[@"UIImagePickerControllerMediaURL"];
        
        
        
        NSData *videoData = [NSData dataWithContentsOfURL:videoURL1];
        
        _mediaTypeImage = NO;
        _mediaPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"media.mp4"];
        
        NSError *error = nil;
        [videoData writeToFile:_mediaPath options:NSDataWritingAtomic error:&error];
        
        if (error) {
            NSLog(@"error writing : %@", error);
        }
        
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    [self goToEditController:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    if (noCameraMode) {
        [self backButton:nil];
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}



- (void)showAlertViewWithTitle:(NSString*)title message:(NSString*) message {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}

- (void)updateCounter:(NSTimer *)theTimer {
    if(_secondsLeft > 0 ){
        //_hours = _secondsLeft / 3600;
        _minutes = (_secondsLeft % 3600) / 60;
        _seconds = (_secondsLeft %3600) % 60;
        _labelTimer.text = [NSString stringWithFormat:@"%02d:%02d", _minutes, _seconds];
        _secondsLeft -- ;
        
    }
    else{
        //        _secondsLeft = (IS_IPHONE_4) ? 600 : 600;
        _secondsLeft = TRMaxVideoLength;
    }
}

-(void)countdownTimer{
    
    _secondsLeft = _hours = _minutes = _seconds = 0;
    [self startTimer];
}
-(void)stopTimer{
    
    if([_timer isValid])
    {
        [_timer invalidate];
    }
}

-(void)startTimer{
    
    if([_timer isValid])
    {
        [_timer invalidate];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateCounter:nil];
    });
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
}
-(void)playNotificationSound{
    
    //play sound
    SystemSoundID	pewPewSound;
    NSString *pewPewPath = [[NSBundle mainBundle]
                            pathForResource:@"record" ofType:@"wav"];
    NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
    
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    // session.outputDataSources
    NSError *sessionError;
    //    [session setCategory:AVAudioSessionCategoryOptionMixWithOthers error:&sessionError];
    
    
    //    AVAudioSession *session = [AVAudioSession sharedInstance];
    //
    NSError *setCategoryError = nil;
    if (![session setCategory:AVAudioSessionCategoryPlayback
                  withOptions:AVAudioSessionCategoryOptionMixWithOthers
                        error:&setCategoryError]) {
        // handle error
    }
    // use the louder speaker
    //    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    //    AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,
    //                             sizeof (audioRouteOverride),&audioRouteOverride);
    
    if(session == nil)
        NSLog(@"Error creating session: %@", [sessionError description]);
    else
        [session setActive:YES error:&sessionError];
    
    //    AVAudioPlayer *pl = [[AVAudioPlayer alloc] initWithContentsOfURL:pewPewURL error:&sessionError];
    //    [pl play];
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL, &pewPewSound);
    AudioServicesPlaySystemSound(pewPewSound);
    
    
}

@end
