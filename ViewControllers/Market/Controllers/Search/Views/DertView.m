//
//  DertView.m
//  虚线
//
//  Created by 乔乔智祥 on 16/12/21.
//  Copyright © 2016年 QiaoZhiXiang. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "DertView.h"
#import "ConfigHeader.h"
@implementation DertView

- (void)drawRect:(CGRect)rect
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame))];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    // 设置虚线颜色为blackColor [shapeLayer setStrokeColor:[[UIColor blackColor] CGColor]];
    [shapeLayer setStrokeColor:UIColorFromRGB(0xD2D4D5).CGColor];
    // 3.0f设置虚线的宽度 [shapeLayer setLineWidth:1.0f];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(self.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    int num =3; int lineSpaceing =4;
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:num], [NSNumber numberWithInt:lineSpaceing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(self.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [self.layer addSublayer:shapeLayer];
    
}
@end
