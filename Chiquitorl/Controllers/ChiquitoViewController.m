//
//  ChiquitoViewController.m
//  Chiquitorl
//
//  Created by Miguel Santiago Rodríguez on 09/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "ChiquitoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreMotion/CoreMotion.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ChiquitoViewController () <AVAudioPlayerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *chiquitoImageView;
@property (strong, nonatomic) NSTimer *pecadorTimer;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (strong, nonatomic) NSArray *imagesArray;
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (nonatomic) BOOL isTalking;
@end

@implementation ChiquitoViewController

- (CMMotionManager *)motionManager {
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.accelerometerUpdateInterval = .2;
    }
    
    return _motionManager;
}

- (NSArray *)imagesArray {
    if (!_imagesArray) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"chiquito-images" ofType:@"plist"];
        _imagesArray = [[NSArray alloc] initWithContentsOfFile:filePath];
    }
    
    return _imagesArray;
}

- (NSTimer *)pecadorTimer {
    if (!_pecadorTimer) {
        _pecadorTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(playPecador) userInfo:nil repeats:YES];
    }
    
    return _pecadorTimer;
}

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
    self.player.delegate = self;
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleSound:)];
    doubleTap.numberOfTouchesRequired = 2;
    doubleTap.numberOfTapsRequired = 1;
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.chiquitoImageView addGestureRecognizer:doubleTap];
    [self.chiquitoImageView addGestureRecognizer:swipeLeft];
    [self.chiquitoImageView addGestureRecognizer:swipeRight];
    [self startPecador];
    [self startAccelerometer];
}

- (void)startAccelerometer {
    if (self.motionManager.isAccelerometerAvailable) {
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                                 withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                     [self checkAcelerometer:accelerometerData.acceleration];
                                                 }];
    }
}

- (void)checkAcelerometer:(CMAcceleration)acceleration {
    if ([self isInGround:acceleration]) {
        [self stopPecador];
    } else if (!self.isTalking && [self isUpsideDown:acceleration]) {
        [self startPecador];
    }
}

- (BOOL) isInGround:(CMAcceleration)acceleration {
    return (acceleration.z > 0.8 && acceleration.y < 0.2 && acceleration.x < 0.2);
}

- (BOOL) isUpsideDown:(CMAcceleration)acceleration {
    return (acceleration.z < 0.2 && acceleration.y > 0.8 && acceleration.x < 0.2);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        [self changeBackgorundImage];
    }
}

- (void) changeBackgorundImage {
    UIImage *chiquitoImage = [UIImage imageNamed:[self.imagesArray objectAtIndex: arc4random() % [self.imagesArray count]]];
    self.chiquitoImageView.image = chiquitoImage;
}

- (void)startPecador {
    [self.pecadorTimer fire];
    self.isTalking = YES;
    [self toggleLED];
}

- (void)toggleSound:(UITapGestureRecognizer *)recognizer {
    if (self.isTalking) {
        [self stopPecador];
    } else {
        [self startPecador];
    }
}

- (void)didSwipeLeft:(UISwipeGestureRecognizer *)recognizer {
    [self useCamera];
}

- (void)didSwipeRight:(UISwipeGestureRecognizer *)recognizer {
    [self useCameraRoll];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)playPecador {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Cobarde"ofType:@"wav"];
    NSError *err = nil;
    NSData *soundData = [[NSData alloc] initWithContentsOfFile:filePath options:NSDataReadingMapped error:&err];
    
    self.player = [[AVAudioPlayer alloc] initWithData:soundData error:&err];
    
    [self.player play];
    
    [self vibrate];
}

- (void)vibrate {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void) toggleLED {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    [device setTorchMode: self.isTalking ? AVCaptureTorchModeOn : AVCaptureTorchModeOff];
    [device unlockForConfiguration];
}

- (void)stopPecador {
    [self.pecadorTimer invalidate];
    self.pecadorTimer = nil;
    self.isTalking = NO;
    [self.player stop];
    [self toggleLED];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self toggleLED];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void) useCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void) useCameraRoll {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])  {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        self.chiquitoImageView.image = info[UIImagePickerControllerOriginalImage];
        
    }
}

@end
