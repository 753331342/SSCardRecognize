//
//  RRGlobalMetrics.m
//  RRExtension
//
//  Created by 连伟钦 on 16/3/1.
//  Copyright © 2016年 Panda. All rights reserved.
//

#import "RRGlobalMetrics.h"
#import <UIKit/UIKit.h>

CGFloat viewWidth() {
    static CGFloat viewWidth = 0;
    if (viewWidth == 0) {
        viewWidth = [UIScreen mainScreen].bounds.size.width;
    }
    
    return viewWidth;
}

CGFloat viewHeight() {
    static CGFloat viewHeight = 0;
    if (viewHeight == 0) {
        viewHeight = [UIScreen mainScreen].bounds.size.height;
    }
    
    return viewHeight;
}

CGFloat viewRatio320(){
    static CGFloat viewRatio320 = 0;
    if (viewRatio320 == 0){
        viewRatio320 = viewWidth() / 320;
    }
    return viewRatio320;
}

CGFloat viewRatio375(){
    static CGFloat viewRatio375 = 0;
    if (viewRatio375 == 0){
        viewRatio375 = viewWidth() / 375;
    }
    return viewRatio375;
}

CGRect NIRectInset(CGRect rect, UIEdgeInsets insets) {
    return CGRectMake(rect.origin.x + insets.left,
                      rect.origin.y + insets.top,
                      rect.size.width - insets.left - insets.right,
                      rect.size.height - insets.top - insets.bottom);
}
