//
//  AccelerometerManager.m
//  Chiquitorl
//
//  Created by Miguel Santiago Rodríguez on 09/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "AccelerometerManager.h"
#import <CoreMotion/CoreMotion.h>

@interface AccelerometerManager ()

@property (strong, nonatomic) CMMotionManager *motionManager;

@end

@implementation AccelerometerManager

- (CMMotionManager *)motionManager {
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.accelerometerUpdateInterval = .2;
    }
    
    return _motionManager;
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
        [self.delegate isFaceToGround];
    } else if ([self isUpsideDown:acceleration]) {
        [self.delegate isUpsideDown];
    }
}

- (BOOL) isInGround:(CMAcceleration)acceleration {
    return (acceleration.z > 0.8 && acceleration.y < 0.2 && acceleration.x < 0.2);
}

- (BOOL) isUpsideDown:(CMAcceleration)acceleration {
    return (acceleration.z < 0.2 && acceleration.y > 0.8 && acceleration.x < 0.2);
}

@end
