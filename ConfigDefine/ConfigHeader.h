//
//  ConfigHeader.h
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/15.
//  Copyright © 2017年 wurui. All rights reserved.
//

#ifndef ConfigHeader_h
#define ConfigHeader_h


#import "Factory.h"
#import <Masonry.h>
#import "NetWorkManager.h"
#import <ReactiveObjC.h>
#import "UserManager.h"
#import <SVProgressHUD.h>


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#import "NSArray+SHYUtil.h"
#import "UIView+Extension.h"
#import "UIColor+helper.h"
#import "YYCache/YYCache.h"
#import "Reachability.h"
#import "AFNetworking.h"
#define WEAKSELF() __weak __typeof(&*self)weakSelf = self;
#define kRGBAColor(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define kRGBColor(r,g,b) kRGBAColor(r,g,b,1.0f)
#define kFont(size) [UIFont systemFontOfSize:size]

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//全局返回通用配置选项
typedef NS_ENUM(NSInteger, SelectorBackType){
    SelectorBackTypePopBack = 0,
    SelectorBackTypeDismiss,
    SelectorBackTypePoptoRoot
};

#define WeCharUserID    @"gh_53368af0ad62"
#define WXAPPKEY        @"wx62b05b5904c384b3"
#define JPUSHKey        @""

//750状态下字体适配
#define font750(x) ((x)/ 1334.0f) * UI_HEGIHT
//750状态下像素适配宏
#define Anno750(x) ((x)/ 1334.0f) * UI_HEGIHT


#define UI_BOUNDS   [UIScreen mainScreen].bounds
#define UI_HEGIHT   [UIScreen mainScreen].bounds.size.height
#define UI_WIDTH    [UIScreen mainScreen].bounds.size.width


//规避空值
#define INCASE_EMPTY(str, replace) \
( ([(str) length]==0)?(replace):(str) )

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define isProduction YES
#else
#   define DLog(...)
#define isProduction NO
#endif

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGBA(rgbValue,sec) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:sec]

#define MainRed     [UIColor colorWithRed:0.80 green:0.22 blue:0.24 alpha:1.00]
#define GroundColor [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00]
#define HomeBtn1    [UIColor colorWithRed:0.91 green:0.33 blue:0.29 alpha:1.00]
#define HomeBtn2    [UIColor colorWithRed:0.96 green:0.71 blue:0.32 alpha:1.00]
#define HomeBtn3    [UIColor colorWithRed:0.44 green:0.69 blue:0.33 alpha:1.00]
#define HomeBtn4    [UIColor colorWithRed:0.90 green:0.42 blue:0.37 alpha:1.00]
#define HomeBtn5    [UIColor colorWithRed:0.12 green:0.76 blue:0.79 alpha:1.00]
#define HomeBtn6    [UIColor colorWithRed:0.28 green:0.56 blue:0.84 alpha:1.00]
#define TagColor    [UIColor colorWithRed:0.00 green:0.75 blue:0.92 alpha:1.00]
//字体主色调  黑色
#define KTColor_MainBlack   UIColorFromRGB(0x333333)
//字体浅灰色
#define KTColor_lightGray   UIColorFromRGB(0x999999)
//字体深灰色
#define KTColor_darkGray    UIColorFromRGB(0x666666)

#endif /* ConfigHeader_h */
