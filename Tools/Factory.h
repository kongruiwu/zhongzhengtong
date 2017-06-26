//
//  Factory.h
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/15.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import "API.h"
@interface Factory : NSObject

+ (UITableView *)creatTabviewWithFrame:(CGRect)frame style:(UITableViewStyle)style;

+ (UILabel *)creatLabelWithText:(NSString *)title fontValue:(float)font textColor:(UIColor *)color textAlignment:(NSTextAlignment)alignment;

+ (void)setLabel:(UILabel *)label BorderColor:(UIColor *)color with:(CGFloat)withValue cornerRadius:(CGFloat)radiusValue;

+ (UIButton *)creatButtonWithTitle:(NSString *)title backGroundColor:(UIColor *)groundColor textColor:(UIColor *)textColor textSize:(float)fontValue;

+ (UIButton *)creatButtonWithNormalImage:(NSString *)normalImage selectImage:(NSString *)selectImage;

+ (UIImageView *)creatImageViewWithImage:(NSString *)imageName;

+ (UIImageView *)creatArrowImage;

+ (UIView *)creatLineView;

+ (UIView *)creatViewWithColor:(UIColor *)color;

+ (void)callPhoneStr:(NSString*)phoneStr withVC:(UIViewController *)selfvc;

+ (NSString *) MD5HashWithString:(NSString *)string;

+ (NSString *)encodeUrlString:(NSString *)string ;

+ (CGSize)getSize:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont*)font;

+ (NSURL *)getImageUlr:(NSString *)imgUrl;

+ (NSString *)getTodayTimeType:(NSString *)timeStr;
@end
