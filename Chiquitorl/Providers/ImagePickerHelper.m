//
//  ImagePickerHelper.m
//  Chiquitorl
//
//  Created by Miguel Santiago Rodríguez on 09/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "ImagePickerHelper.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation ImagePickerHelper


- (void) useCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self.delegate presentViewController:[self buildImagePickerControllerWithType:UIImagePickerControllerSourceTypeCamera]
                           animated:YES
                         completion:nil];
    }
}

- (void) useCameraRoll {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])  {
        [self.delegate presentViewController:[self buildImagePickerControllerWithType:UIImagePickerControllerSourceTypeSavedPhotosAlbum]
                           animated:YES
                         completion:nil];
    }
}

- (UIImagePickerController *)buildImagePickerControllerWithType:(UIImagePickerControllerSourceType)type {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = type;
    imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    imagePicker.allowsEditing = NO;
    
    return imagePicker;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        [self.delegate imagePickerHelper:self didSelecetImage:info[UIImagePickerControllerOriginalImage]];
    }
}


@end
