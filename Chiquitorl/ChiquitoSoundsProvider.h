//
//  ChiquitoSoundsProvider.h
//  Chiquitorl
//
//  Created by Miguel Santiago Rodríguez on 09/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChiquitoSoundsProvider;
@protocol ChiquitoSoundDelegate <NSObject>
@optional
- (void)soundEffectDidFinishPlaying:(ChiquitoSoundsProvider *)chiquitoSound;

@end

@interface ChiquitoSoundsProvider : NSObject

@property (weak, nonatomic) id<ChiquitoSoundDelegate> delegate;

- (void)playSoundWithFilePath:(NSString *)filePath;
- (void)stopPlayingSound;

@end
