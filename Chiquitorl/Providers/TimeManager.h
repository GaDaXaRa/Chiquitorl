//
//  TimeManager.h
//  Chiquitorl
//
//  Created by Miguel Santiago Rodríguez on 09/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BASIC_BLOCK)();

@interface TimeManager : NSObject

@property (nonatomic, getter = isOn) BOOL on;

- (instancetype)initWithTimeInterval:(NSUInteger)seconds andAction:(BASIC_BLOCK)action;

- (void)switchOn;

- (void)switchOff;

@end
