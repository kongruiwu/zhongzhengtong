//
//  HeaderOptionalViewItemView.m
//  NewRenWang
//
//  Created by YJ on 17/1/17.
//  Copyright © 2017年 尹争荣. All rights reserved.
//

#import "HeaderOptionalViewItemView.h"

@implementation HeaderOptionalViewItemView
// 滑动进度
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [_fillColor set];
    
    CGRect newRect = rect;
    newRect.size.width = rect.size.width * self.progress;
    UIRectFillUsingBlendMode(newRect, kCGBlendModeSourceIn);
}

@end
