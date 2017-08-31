//
//  RRGlobalMetrics.h
//  RRExtension
//
//  Created by 连伟钦 on 16/3/1.
//  Copyright © 2016年 Panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifndef RRGlobalMetrics_h
#define RRGlobalMetrics_h

CGFloat viewWidth();

CGFloat viewHeight();

CGFloat viewRatio320();

CGFloat viewRatio375();

#if defined __cplusplus
extern "C" {
#endif
    
    CGRect NIRectInset(CGRect rect, UIEdgeInsets insets);
    
#if defined __cplusplus
};
#endif


#endif /* RRGlobalMetrics_h */
