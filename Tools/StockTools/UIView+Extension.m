//
//  UIView+Extension.m
//  BigTimeStrategy
//
//  @Author: wsh on 16/6/15.
//  Copyright © 2016年 安徽黄埔. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

#pragma mark - X坐标的Setter/Getter
- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

#pragma mark - Y坐标的Setter/Getter
- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

#pragma mark - 宽度的Setter/Getter
- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

#pragma mark - 高度的Setter/Getter
- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

#pragma mark - 尺寸的Setter/Getter
- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

#pragma mark - 中心点X的Setter/Getter
- (CGFloat)centerX {
    return  self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

#pragma mark - 中心点Y的Setter/Getter
- (CGFloat)centerY {
    return  self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

@end
