//
//  SSImageTool.m
//  SSCardRecognize
//
//  Created by 张家铭 on 2017/8/31.
//  Copyright © 2017年 753331342@qq.com. All rights reserved.
//

#import "SSImageTool.h"

@implementation SSImageTool

/** 将CMSampleBufferRef转成UIImage对象 */
+ (UIImage *)imageWithSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
	// 制作 CVImageBufferRef
	CVImageBufferRef buffer;
	buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
	
	CVPixelBufferLockBaseAddress(buffer, 0);
	
	// 从 CVImageBufferRef 取得影像的细部信息
	uint8_t *base;
	size_t width, height, bytesPerRow;
	base = CVPixelBufferGetBaseAddress(buffer);
	width = CVPixelBufferGetWidth(buffer);
	height = CVPixelBufferGetHeight(buffer);
	bytesPerRow = CVPixelBufferGetBytesPerRow(buffer);
	
	// 利用取得影像细部信息格式化 CGContextRef
	CGColorSpaceRef colorSpace;
	CGContextRef cgContext;
	colorSpace = CGColorSpaceCreateDeviceRGB();
	cgContext = CGBitmapContextCreate(base, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
	CGColorSpaceRelease(colorSpace);
	
	// 透过 CGImageRef 将 CGContextRef 转换成 UIImage
	CGImageRef cgImage;
	UIImage *image;
	cgImage = CGBitmapContextCreateImage(cgContext);
	image = [UIImage imageWithCGImage:cgImage];
	CGImageRelease(cgImage);
	CGContextRelease(cgContext);
	
	CVPixelBufferUnlockBaseAddress(buffer, 0);
	
	return image;
}

/** 根据rect裁剪图片 */
+ (UIImage *)imageWithImage:(UIImage *)image inRect:(CGRect)rect {
	if (rect.size.width >= image.size.width
		&& rect.size.height >= image.size.height) {
		return image;
	}
	
	CGImageRef sourceImageRef = image.CGImage;
	CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
	return [UIImage imageWithCGImage:newImageRef];
}

// 裁剪银行卡号所在区域
+ (UIImage *)cropImageFromImage:(UIImage *)img {
	
	static CGFloat cardWidth = 420;
	static CGFloat cardHeight = 420/1.58;
	
	CGFloat h = img.size.height * 500 / img.size.width;
	UIGraphicsBeginImageContext(CGSizeMake(500, h));
	[img drawInRect:CGRectMake(0, 0, 500, h)];
	UIImage *scaleImg = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	CGFloat y = (scaleImg.size.height - cardHeight) / 2;
	
	CGImageRef sourceImageRef = [scaleImg CGImage];
	CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, CGRectMake(40, y, cardWidth, cardHeight));
	
	CGImageRef resultImgRef = CGImageCreateWithImageInRect(newImageRef, CGRectMake(0, 140, cardWidth, 60));
	UIImage *mm = [UIImage imageWithCGImage:resultImgRef];
	
#warning 记得删掉下面的
	//    static dispatch_once_t onceToken;
	//    dispatch_once(&onceToken, ^{
	//        UIImageWriteToSavedPhotosAlbum(scaleImg, nil, nil, nil);
	//        UIImageWriteToSavedPhotosAlbum([UIImage imageWithCGImage:newImageRef], nil, nil, nil);
	//        UIImageWriteToSavedPhotosAlbum(mm, nil, nil, nil);
	//    });
	
	return mm;
}

@end
