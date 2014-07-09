//
//  ChiquitoImagesProvider.m
//  Chiquitorl
//
//  Created by Miguel Santiago Rodríguez on 09/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "ChiquitoImagesProvider.h"

@interface ChiquitoImagesProvider ()

@property (strong, nonatomic) NSArray *imagesArray;
@property (strong, nonatomic) NSString *fileName;

@end

@implementation ChiquitoImagesProvider

- (instancetype)initWithFileName:(NSString *)fileName {
    self = [super init];
    
    if (self) {
        _fileName = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    }
    
    return self;
}

- (NSArray *)imagesArray {
    if (!_imagesArray) {
        if (self.fileName) {
            _imagesArray = [[NSArray alloc] initWithContentsOfFile:self.fileName];
        } else {
            _imagesArray = [[NSArray alloc] init];
        }
    }
    
    return _imagesArray;
}

- (UIImage *)randomImage {
    UIImage *chiquitoImage = [UIImage imageNamed:[self.imagesArray objectAtIndex: arc4random() % [self.imagesArray count]]];
    return chiquitoImage;
}

@end
