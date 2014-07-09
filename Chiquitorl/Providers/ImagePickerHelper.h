//
//  ImagePickerHelper.h
//  Chiquitorl
//
//  Created by Miguel Santiago Rodríguez on 09/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ImagePickerHelper;
@protocol ImagePickerHelperDelegate <NSObject>

- (void)imagePickerHelper:(ImagePickerHelper *)imagePicker didSelecetImage:(UIImage *)image;

@end

@interface ImagePickerHelper : NSObject <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) UIViewController<ImagePickerHelperDelegate> *delegate;

- (void) useCamera;
- (void) useCameraRoll;

@end
