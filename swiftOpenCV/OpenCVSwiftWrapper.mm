//
//  OpenCVSwiftWrapper.m
//  swiftOpenCV
//
//  Created by Robin Malhotra on 29/03/16.
//  Copyright © 2016 Robin Malhotra. All rights reserved.
//

                  
#include "OpenCVSwiftWrapper.h"
#include <opencv2/opencv.hpp>
                  
using namespace cv;
using namespace std;

@implementation OpenCVSwiftWrapper : NSObject

bool myfunction (int i,int j) { return (i<j); }

+ (UIImage *)processImageWithOpenCV:(UIImage*)inputImage
{
    Mat mat = [self cvMatFromUIImage:inputImage];

    // do your processing here
    int const max_BINARY_value = 2147483647;
    cv::Mat src_gray=[self cvMatFromUIImage:inputImage];
    cv::Mat dst;
    dst=src_gray;
    cv::cvtColor(src_gray, dst, cv::COLOR_RGB2GRAY);
    cv::Mat canny_output;
    std::vector<std::vector<cv::Point> > contours;
    std::vector<cv::Vec4i> hierarchy;
    
    cv::RNG rng(12345);
    
    cv::threshold( dst, dst, 1, max_BINARY_value,cv::THRESH_OTSU );
    
    cv::Mat contourOutput = dst.clone();
    cv::findContours( contourOutput, contours, cv::RETR_TREE, cv::CHAIN_APPROX_SIMPLE );
    
    sort(contours.begin(), contours.end(), [](const vector<cv::Point>& c1, const vector<cv::Point>& c2){
        return contourArea(c1, false) < contourArea(c2, false);
    });
    reverse(contours.begin(), contours.end());
//    
    std::vector<std::vector<cv::Point> > newContours;
//    for (int i=0 ; i<9;i++)
//    {
//        newContours.push_back(contours[i]);
//    }
//    newContours.erase(newContours.begin() + 0);
    
    int i = 0;
    double lastLevelWidth = 0, lastLevelHeight = 0;
    bool hasFoundSecondLevel = false, hasFoundFirstLevel = false;
    if(contours.size() != 0)
    {
        while (true)
        {
            cv::Rect box = boundingRect(contours[i]);
            if (lastLevelWidth == 0)
            {
                lastLevelWidth = box.width;
                lastLevelHeight = box.height;
                hasFoundFirstLevel = true;
            }
            
            else if (box.width < lastLevelHeight/3 and box.height <lastLevelHeight/3)
            {
                if(hasFoundFirstLevel and hasFoundSecondLevel)
                {
                    break;
                }
                else if (hasFoundSecondLevel and !hasFoundSecondLevel)
                {
                    hasFoundSecondLevel = true;
                    newContours.push_back(contours[i]);
                }
            }
            else
            {
                newContours.push_back(contours[i]);
            }
            
        }
    }
    
//    contours = newContours;
    
    //Draw the contours
    cv::Mat contourImage(dst.size(), CV_8UC3, cv::Scalar(0,0,0));
    cv::Scalar colors[3];
    colors[0] = cv::Scalar(255, 0, 0);
    colors[1] = cv::Scalar(0, 255, 0);
    colors[2] = cv::Scalar(0, 0, 255);
    for (size_t idx = 0; idx < contours.size(); idx++) {
//        cv::drawContours(contourImage, contours, idx, colors[idx % 3]);
    cv::Rect box = boundingRect(contours[idx]);
    rectangle(contourImage, box, colors[idx%3]);
        NSLog(@"%f", contourArea(contours[idx],false));
    }
    
    return [self UIImageFromCVMat:contourImage];
}


+ (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}
+ (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    cv::Mat cvMat(rows, cols, CV_8UC1); // 8 bits per component, 1 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}


+(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

@end