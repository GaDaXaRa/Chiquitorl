//
//  DeviceHardwareHelper.h
//  Chiquitorl
//
//  Created by Miguel Santiago Rodríguez on 09/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BASIC_BLOCK)();

@interface DeviceHardwareHelper : NSObject

+ (void)vibrate;
+ (void)torchOn;
+ (void)torchOff;

- (void)onProximityEventApproachDoThis:(BASIC_BLOCK)block;
- (void)onProximityEventLeavingDoThis:(BASIC_BLOCK)block;

@end
