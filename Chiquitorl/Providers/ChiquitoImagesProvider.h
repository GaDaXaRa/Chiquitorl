//
//  ChiquitoImagesProvider.h
//  Chiquitorl
//
//  Created by Miguel Santiago Rodríguez on 09/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChiquitoImagesProvider : NSObject

- (instancetype)initWithFileName:(NSString *)fileName;
- (UIImage *)randomImage;

@end
