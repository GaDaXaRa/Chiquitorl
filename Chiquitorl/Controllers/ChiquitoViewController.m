//
//  ChiquitoViewController.m
//  Chiquitorl
//
//  Created by Miguel Santiago Rodríguez on 09/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "ChiquitoViewController.h"
#import "ChiquitoImagesProvider.h"
#import "ChiquitoSoundsProvider.h"
#import "AccelerometerManager.h"
#import "DeviceHardwareHelper.h"
#import "ImagePickerHelper.h"

@interface ChiquitoViewController () <AccelerometerDelegate, ChiquitoSoundDelegate, ImagePickerHelperDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *chiquitoImageView;

@property (nonatomic) BOOL isTalking;
@property (strong, nonatomic) NSTimer *pecadorTimer;

@property (strong, nonatomic) ChiquitoImagesProvider *imageProvider;

@property (strong, nonatomic) IBOutlet ChiquitoSoundsProvider *soundsProvider;
@property (strong, nonatomic) IBOutlet DeviceHardwareHelper *hardwareHelper;
@property (strong, nonatomic) IBOutlet AccelerometerManager *accelerometerManager;
@property (strong, nonatomic) IBOutlet ImagePickerHelper *imagePickerHelper;
@end

@implementation ChiquitoViewController

#pragma mark -
#pragma mark Lazy getting

- (ChiquitoImagesProvider *)imageProvider {
    if(!_imageProvider) {
        _imageProvider = [[ChiquitoImagesProvider alloc] initWithFileName:@"chiquito-images"];
    }
    
    return _imageProvider;
}

- (NSTimer *)pecadorTimer {
    if (!_pecadorTimer) {
        _pecadorTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(playCobarde) userInfo:nil repeats:YES];
    }
    
    return _pecadorTimer;
}

#pragma mark -
#pragma mark Gesture Actions

- (IBAction)tapTwoFingers:(id)sender {
    [self toggleSound:sender];
}

- (IBAction)swipeRight:(UISwipeGestureRecognizer *)sender {
    [self.imagePickerHelper useCameraRoll];
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
    [self configureDelegates];
    [self enableProximity];
    [self.accelerometerManager startAccelerometer];
    [self startPecador];
}

- (void)configureDelegates
{
    self.soundsProvider.delegate = self;
    self.accelerometerManager.delegate = self;
    self.imagePickerHelper.delegate = self;
}

- (IBAction)swipeLeft:(UISwipeGestureRecognizer *)sender {
    [self.imagePickerHelper useCamera];
}

- (void)enableProximity {
    __weak typeof(self) weakSelf = self;
    [self.hardwareHelper onProximityEventApproachDoThis:^{
        [weakSelf playIiihii];
    }];
    
    [self.hardwareHelper onProximityEventLeavingDoThis:^{
        [weakSelf playIoPuta];
    }];
}

#pragma mark -
#pragma mark AccelerometerManagerDelegate

- (void)isUpsideDown {
    if (!self.isTalking) {
        [self startPecador];
    }
}

- (void)isFaceToGround {
    [self stopPecador];
}

#pragma mark -
#pragma mark ChiquitoSoundDelegate

- (void)soundEffectDidFinishPlaying:(ChiquitoSoundsProvider *)chiquitoSound {
    [DeviceHardwareHelper torchOff];
}

- (void)imagePickerHelper:(ImagePickerHelper *)imagePicker didSelecetImage:(UIImage *)image {
    self.chiquitoImageView.image = image;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        [self changeBackgorundImage];
    }
}

- (void) changeBackgorundImage {
    self.chiquitoImageView.image = [self.imageProvider randomImage];
}

- (void)toggleSound:(UITapGestureRecognizer *)recognizer {
    if (self.isTalking) {
        [self stopPecador];
    } else {
        [self startPecador];
    }
}

- (void)startPecador {
    [self.pecadorTimer fire];
    self.isTalking = YES;
}

- (void)stopPecador {
    [self.pecadorTimer invalidate];
    self.pecadorTimer = nil;
    self.isTalking = NO;
}

- (void)playCobarde {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Cobarde"ofType:@"wav"];
    [self.soundsProvider playSoundWithFilePath:filePath];
    [DeviceHardwareHelper torchOn];
    [DeviceHardwareHelper vibrate];
}

- (void)playIiihii {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Iiihii"ofType:@"wav"];
    [self.soundsProvider playSoundWithFilePath:filePath];
}

- (void)playIoPuta {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Ioputarl"ofType:@"wav"];
    [self.soundsProvider playSoundWithFilePath:filePath];
}

@end