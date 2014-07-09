//
//  ChiquitoSoundsProvider.m
//  Chiquitorl
//
//  Created by Miguel Santiago Rodríguez on 09/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "ChiquitoSoundsProvider.h"
#import <AVFoundation/AVFoundation.h>

@interface ChiquitoSoundsProvider ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation ChiquitoSoundsProvider

- (void)playSoundWithFilePath:(NSString *)filePath {
    NSError *err = nil;
    NSData *soundData = [[NSData alloc] initWithContentsOfFile:filePath options:NSDataReadingMapped error:&err];
    
    self.player = [[AVAudioPlayer alloc] initWithData:soundData error:&err];
    self.player.delegate = self;
    [self.player play];
}

- (void)stopPlayingSound {
    [self.player stop];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if ([self.delegate respondsToSelector:@selector(soundEffectDidFinishPlaying:)]) {
        [self.delegate soundEffectDidFinishPlaying:self];
    }
}

@end
