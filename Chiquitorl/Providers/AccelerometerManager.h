//
//  AccelerometerManager.h
//  Chiquitorl
//
//  Created by Miguel Santiago Rodríguez on 09/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AccelerometerDelegate <NSObject>

-(void)isFaceToGround;
-(void)isUpsideDown;

@end

@interface AccelerometerManager : NSObject

@property (nonatomic, weak) id<AccelerometerDelegate> delegate;

- (void)startAccelerometer;

@end
