//
//  SSImageTool.h
//  SSCardRecognize
//
//  Created by 张家铭 on 2017/8/31.
//  Copyright © 2017年 753331342@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SSImageTool : NSObject

/**
 *  将CMSampleBufferRef转成UIImage对象
 
 *  @param sampleBuffer sampleBuffer
 *  @return image
 */
+ (UIImage *)imageWithSampleBuffer:(CMSampleBufferRef)sampleBuffer;

/**
 *  根据rect裁剪图片
 
 *  @param image image
 *  @param rect rect
 *  @return image
 */
+ (UIImage *)imageWithImage:(UIImage *)image inRect:(CGRect)rect;

/** 裁剪银行卡号所在的区域 */
+ (UIImage *)cropImageFromImage:(UIImage *)img;


@end
