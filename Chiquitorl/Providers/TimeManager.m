//
//  TimeManager.m
//  Chiquitorl
//
//  Created by Miguel Santiago Rodríguez on 09/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "TimeManager.h"

@interface TimeManager ()

@property (nonatomic, copy) void (^action)();
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) NSUInteger timeInterval;

@end

@implementation TimeManager

- (instancetype)initWithTimeInterval:(NSUInteger)seconds andAction:(void(^)())action {
    self = [super init];
    
    if (self) {
        _action = action;
        _timeInterval = seconds;
    }
    
    return self;
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(perFormAction) userInfo:nil repeats:YES];
    }
    
    return _timer;
}

- (void)switchOn {
    self.on = YES;
    [self.timer fire];
}

- (void)switchOff {
    self.on = NO;
    [self.timer invalidate];
    self.timer = nil;
}

- (void)perFormAction {
    self.action();
}

@end
