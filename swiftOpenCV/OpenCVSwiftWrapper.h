//
//  OpenCVSwiftWrapper.h
//  swiftOpenCV
//
//  Created by Robin Malhotra on 29/03/16.
//  Copyright © 2016 Robin Malhotra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface OpenCVSwiftWrapper : NSObject

+ (UIImage *)processImageWithOpenCV:(UIImage*)inputImage;

@end