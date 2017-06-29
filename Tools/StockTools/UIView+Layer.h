//
//  UIView+Layer.h
//  NewRenWang
//
//  Created by YJ on 17/1/20.
//  Copyright © 2017年 尹争荣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Layer)
- (void)setLayerCornerRadius:(CGFloat)cornerRadius
                 borderWidth:(CGFloat)borderWidth
                 borderColor:(UIColor *)borderColor;


/**
 *  边角半径
 */
@property (nonatomic, assign) CGFloat layerCornerRadius;
/**
 *  边线宽度
 */
@property (nonatomic, assign) CGFloat layerBorderWidth;
/**
 *  边线颜色
 */
@property (nonatomic, strong) UIColor *layerBorderColor;

/** 中心点X */
@property(assign,nonatomic)CGFloat centerX;
/** 中心点Y */
@property(assign,nonatomic)CGFloat centerY;
@end
