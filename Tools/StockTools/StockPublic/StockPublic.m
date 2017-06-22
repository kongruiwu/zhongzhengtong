//
//  StockPublic.m
//  BigTimeStrategy
//
//  @Author: JopYin on 16/7/4.
//  Copyright © 2016年 安徽黄埔. All rights reserved.
//

#import "StockPublic.h"
#import "SearchStock.h"
#import "ConfigHeader.h"


@implementation StockPublic

#pragma mark -设置股票的背景色
+ (void)compareValue1:(NSString *)value1 Value2:(NSString *)value2 withLabel:(UILabel *)label {
    if ([value1 floatValue] < [value2 floatValue])
    {
        label.textColor = [UIColor colorWithHexString:@"dd2123"];
    }
    else if ([value1 floatValue] > [value2 floatValue])
    {
        label.textColor = [UIColor colorWithHexString:@"#41a72d"];
    }
    else
    {
        label.textColor = [UIColor colorWithHexString:@"#000000"];
    }
}

#pragma mark - 判断链接网络方式
+ (int)isWiFiOK {
    Reachability *rrr = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    int returnNum;
    switch ([rrr currentReachabilityStatus]) {
        case NotReachable:// 没有网络连接
            returnNum = 0;
            break;
        case ReachableViaWWAN:// 使用3G网络
            returnNum = 1;
            break;
        case ReachableViaWiFi:// 使用WiFi网络
            returnNum = 2;
            break;
    }
    return returnNum;
}

#pragma mark - 给股票代码加前缀
+ (NSString *)prefixStockCode:(NSString *)code {
    if ([code isEqualToString:@""]) {
        return nil;
    }
    NSString *str = @"";
    if ([code hasPrefix:@"60"] || [code hasPrefix:@"1A"] || [code hasPrefix:@"90"])
    {
        str = @"sh";
    }
    else
    {
        str = @"sz";
    }
    NSString *resultStr = [[NSString alloc] initWithFormat:@"%@%@",str,code];
    return resultStr;
}

#pragma mark - 处理行情返回的分笔数据
+ (NSString*)caldata:(NSString*)str {
    CGFloat _float = [str floatValue];
    if (_float > 1000)
    {
        return [[NSString alloc] initWithFormat:@"%.2fk",_float/1000];
    }else{
        return [[NSString alloc] initWithFormat:@"%.0f",_float];
    }
}

#pragma mark - 处理成交量的数据，改变单位
+ (NSString *)calculateFloat:(CGFloat)value {
    NSString *strTemp;
        if (value < 10000.0) {
            strTemp = [[NSString alloc] initWithFormat:@"%.0f手",value];
        }else if (value > 10000.0 && value < 100000000.0){
            value = value / 10000;
            strTemp = [[NSString alloc] initWithFormat:@"%.2f万手",value];
        }else{
            value = value / 100000000;
            strTemp = [[NSString alloc] initWithFormat:@"%.3f亿手",value];
        }
    return strTemp;
}

#pragma mark - 数值变化  ---处理成交额的数值
+ (NSString *)changePrice:(CGFloat)price {
    CGFloat newPrice = 0;
    NSString *danwei = @"";
    NSString *newstr = @"";
    if (price > 10000.00) {
        danwei = @"万";
        newPrice = price / 10000 ;
        newstr = [[NSString alloc] initWithFormat:@"%.1f%@",newPrice,danwei];
    }
    if (price > 100000000.00) {
        newPrice = price / 100000000 ;
        danwei = @"亿";
        newstr = [[NSString alloc] initWithFormat:@"%.3f%@",newPrice,danwei];
    }
    return newstr;
}

#pragma mark - 将提供的字符串类型的日期转换成特定的格式返回
+ (NSString *)intTOTime:(NSString *)currentInt {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[currentInt intValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return  confromTimespStr;
}

#pragma mark - 根据字符串的内容，字体大小以及宽度来计算其高度
+ (CGFloat)calculateStringHeight:(NSString *)text withFont:(UIFont *)font withMaxWidth:(CGFloat)width {
    
    CGSize size = CGSizeMake(width, MAXFLOAT);
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    
    size = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    
    return size.height;
}


#pragma mark - 获取一个数组中最小的值
+ (CGFloat)getSmallerFromArrary:(NSArray *)arr {
    CGFloat minValue = CGFLOAT_MAX;
    for (int i = 0; i < arr.count; i++) {
        if ([arr[i] floatValue] < minValue) {
            minValue = [arr[i] floatValue];
        }
    }
    return minValue;
}

#pragma mark - 获取一个数组中最大的值
+ (CGFloat)getBiggerFromArrary:(NSArray *)arr {
    CGFloat maxValue = 0.0;
    for (int i = 0; i < arr.count; i++) {
        if ([arr[i] floatValue] > maxValue) {
            maxValue = [arr[i] floatValue];
        }
    }
    return maxValue;
}

#pragma mark - number:需要处理的数字， position：保留小数点第几位
+ (NSString *)roundUp:(float)number afterPoint:(int)position {
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundUp scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:number];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}
@end
