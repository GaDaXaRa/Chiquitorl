//
//  DeviceHardwareHelper.m
//  Chiquitorl
//
//  Created by Miguel Santiago Rodríguez on 09/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "DeviceHardwareHelper.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface DeviceHardwareHelper ()

@property (nonatomic, copy) void (^aproachBlock)();
@property (nonatomic, copy) void (^leavingBlock)();

@end

@implementation DeviceHardwareHelper

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityStateChanged:) name:UIDeviceProximityStateDidChangeNotification object:nil];
    }
    return self;
}

+ (void)vibrate {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

+ (void)torchOff {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    [device setTorchMode: AVCaptureTorchModeOff];
    [device unlockForConfiguration];
}

+ (void)torchOn {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    [device setTorchMode: AVCaptureTorchModeOn];
    [device unlockForConfiguration];
}

- (void)onProximityEventApproachDoThis:(void(^)())action {
    self.aproachBlock = action;
}

- (void)onProximityEventLeavingDoThis:(void(^)())action {
    self.leavingBlock = action;
}

- (void)proximityStateChanged:(NSNotification *)notification {
    if ([[UIDevice currentDevice] proximityState] == YES) { //close to the user
        self.aproachBlock();
    } else {
        self.leavingBlock();
    }
}

@end
