//
//  SSOpencvImageTool.m
//  SSCardRecognize
//
//  Created by 张家铭 on 2017/9/1.
//  Copyright © 2017年 753331342@qq.com. All rights reserved.
//

#import "SSOpencvImageTool.h"

#ifdef __cplusplus
#undef NO
#undef YES
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#endif

@implementation SSOpencvImageTool

+ (UIImage *)cardDetectWithImage:(UIImage *)image {
	cv::Mat srcMat = [self matWithImage:image];
	cv::Mat blurMat = srcMat.clone();
	cv::GaussianBlur(srcMat, blurMat, cv::Size(3, 3), 0, 0, cv::BORDER_DEFAULT);
	
	cv::Mat grayMat;
	cv::cvtColor(blurMat, grayMat, cv::COLOR_BGR2GRAY);
	
	cv::adaptiveThreshold(grayMat, grayMat, 255, cv::ADAPTIVE_THRESH_GAUSSIAN_C, cv::THRESH_BINARY_INV, 5, -1);
	
	std::vector<std::vector<cv::Point> > allContours;
	cv::findContours(grayMat, allContours, CV_RETR_LIST, CV_CHAIN_APPROX_SIMPLE);
	
	for (size_t i = 0; i < allContours.size(); i++) {
		cv::Rect rect = cv::boundingRect(allContours[i]);
		rectangle(srcMat, rect, cvScalar(0, 255, 0));
		if (rect.area() > 100) {
			rectangle(srcMat, rect, cvScalar(255, 0, 0));
			NSLog(@"%d----%d---%d---%d", rect.x,rect.y, rect.width, rect.height);
		}
	}
	return [self imageWithCVMat:srcMat];
}

+ (cv::Mat)matWithImage:(UIImage *)image {
	
	CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
	CGFloat cols = image.size.width;
	CGFloat rows = image.size.height;
	
	cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
	
	CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to backing data
													cols,                      // Width of bitmap
													rows,                     // Height of bitmap
													8,                          // Bits per component
													cvMat.step[0],              // Bytes per row
													colorSpace,                 // Colorspace
													kCGImageAlphaNoneSkipLast |
													kCGBitmapByteOrderDefault); // Bitmap info flags
	
	CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
	CGContextRelease(contextRef);
	
	return cvMat;
}

+ (UIImage *)imageWithCVMat:(const cv::Mat&)cvMat {
	NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize() * cvMat.total()];
	
	CGColorSpaceRef colorSpace;
	
	if (cvMat.elemSize() == 1)
	{
		colorSpace = CGColorSpaceCreateDeviceGray();
	}
	else
	{
		colorSpace = CGColorSpaceCreateDeviceRGB();
	}
	
	CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge_retained CFDataRef)data);
	
	CGImageRef imageRef = CGImageCreate(cvMat.cols,                                     // Width
										cvMat.rows,                                     // Height
										8,                                              // Bits per component
										8 * cvMat.elemSize(),                           // Bits per pixel
										cvMat.step[0],                                  // Bytes per row
										colorSpace,                                     // Colorspace
										kCGImageAlphaNone | kCGBitmapByteOrderDefault,  // Bitmap info flags
										provider,                                       // CGDataProviderRef
										NULL,                                           // Decode
										false,                                          // Should interpolate
										kCGRenderingIntentDefault);                     // Intent
	
	UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
	CGImageRelease(imageRef);
	CGDataProviderRelease(provider);
	CGColorSpaceRelease(colorSpace);
	
	return image;
}

@end
