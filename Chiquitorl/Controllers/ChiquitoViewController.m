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
#import "TimeManager.h"

@interface ChiquitoViewController () <AccelerometerDelegate, ChiquitoSoundDelegate, ImagePickerHelperDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *chiquitoImageView;

@property (strong, nonatomic) ChiquitoImagesProvider *imageProvider;
@property (strong, nonatomic) TimeManager *timeManager;

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

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureTimeManager];
    [self configureDelegates];
    [self enableProximity];
    [self.accelerometerManager startAccelerometer];
}

#pragma mark -
#pragma mark Chiquito actions

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

#pragma mark -
#pragma mark Toggle sound

- (void)toggleSound:(UITapGestureRecognizer *)recognizer {
    if (self.timeManager.isOn) {
        [self.timeManager switchOff];
    } else {
        [self.timeManager switchOn];
    }
}

#pragma mark -
#pragma mark Gesture Actions

- (IBAction)tapTwoFingers:(id)sender {
    [self toggleSound:sender];
}

- (IBAction)swipeRight:(UISwipeGestureRecognizer *)sender {
    [self.imagePickerHelper useCameraRoll];
}

- (IBAction)swipeLeft:(UISwipeGestureRecognizer *)sender {
    [self.imagePickerHelper useCamera];
}

#pragma mark -
#pragma mark Helping methods

- (void)configureTimeManager {
    self.timeManager = [[TimeManager alloc] initWithTimeInterval:2 andAction:^{
        [self playCobarde];
    }];
    [self.timeManager switchOn];
}

- (void)configureDelegates
{
    self.soundsProvider.delegate = self;
    self.accelerometerManager.delegate = self;
    self.imagePickerHelper.delegate = self;
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
#pragma mark Shake

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        self.chiquitoImageView.image = [self.imageProvider randomImage];
    }
}

#pragma mark -
#pragma mark AccelerometerManagerDelegate

- (void)isUpsideDown {
    if (!self.timeManager.isOn) {
        [self.timeManager switchOn];
    }
}

- (void)isFaceToGround {
    [self.timeManager switchOff];
}

#pragma mark -
#pragma mark ChiquitoSoundDelegate

- (void)soundEffectDidFinishPlaying:(ChiquitoSoundsProvider *)chiquitoSound {
    [DeviceHardwareHelper torchOff];
}

- (void)imagePickerHelper:(ImagePickerHelper *)imagePicker didSelecetImage:(UIImage *)image {
    self.chiquitoImageView.image = image;
}

@end