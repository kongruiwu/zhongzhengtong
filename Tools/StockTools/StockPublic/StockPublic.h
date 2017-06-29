//
//  StockPublic.h
//  BigTimeStrategy
//
//  @Author: JopYin on 16/7/4.
//  Copyright © 2016年 安徽黄埔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface StockPublic : NSObject
/**
 *  @author JopYin, 2016-07-04
 *
 *  设置股票的背景色（红绿黑）
 *
 *  @param value1 昨收价
 *  @param value2 现价
 *  @param label  此股票的显示控件
 */
+ (void)compareValue1:(NSString *)value1 Value2:(NSString *)value2 withLabel:(UILabel *)label;

/**
 *  @author JopYin, 2016-07-04
 *  判断网络链接的方式
 *  @return 返回的值：0:没有链接网络  1:使用的WLAN 2:使用的WiFi
 */
+ (int)isWiFiOK;

/**
 *  @author JopYin, 2016-07-05
 *  加工股票代码，给代码加前缀
 *  @param code 股票代码
 *  @return  带有前缀的股票代码
 */
+ (NSString *)prefixStockCode:(NSString *)code;

/**
 *  @author JopYin, 2016-07-07
 *
 *  处理分笔数据
 *
 *  @param str 行情返回的字符串形式的数值
 *
 *  @return 除以/1000带小数点的数值
 */
+ (NSString*)caldata:(NSString*)str;

/**
 *  @author JopYin, 2016-07-07
 *
 *  处理成交量，处理后为万、亿，改变单位
 *
 *  @param value 需要处理的值
 *
 *  @return 处理后返回的字符串
 */
+ (NSString *)calculateFloat:(CGFloat)value;

/**
 *  @author JopYin, 2016-07-07
 *
 *  数值改变
 */
+ (NSString *)changePrice:(CGFloat)price;

/**
 *  @author JopYin, 2016-07-11
 *
 *  @brief 将提供的字符串类型的日期转换成特定的格式返回
 *
 *  @param currentInt 提供的字符串类型的日期
 *
 *  @return 返回字符串类型的日期
 */
+ (NSString *)intTOTime:(NSString *)currentInt;

/**
 *  @author wsh, 2016-05-11
 *
 *  @brief 根据字符串的内容，字体大小以及宽度来计算其高度
 *
 *  @param text  字符串的内容
 *  @param font  字符串的字体大小
 *  @param width 字符串的宽度
 *
 *  @return 返回字符串的高度
 */
+ (CGFloat)calculateStringHeight:(NSString *)text withFont:(UIFont *)font withMaxWidth:(CGFloat)width;

/**
 *  @author wsh, 2016-08-23
 *
 *  @brief 获取一个数组中最小的值
 *
 *  @param arr NSArray
 *
 *  @return 返回最小值
 */
+ (CGFloat)getSmallerFromArrary:(NSArray *)arr;

/**
 *  @author wsh, 2016-08-23
 *
 *  @brief 获取一个数组中最大的值
 *
 *  @param arr NSArray
 *
 *  @return 返回最大值
 */
+ (CGFloat)getBiggerFromArrary:(NSArray *)arr;

/**
 *  @author wsh, 2016-09-12
 *
 *  @brief 四舍五入
 *
 *  @param number   需要处理的数字
 *  @param position 保留小数点第几位
 *
 *  @return 返回处理后的数据
 */
+ (NSString *)roundUp:(float)number afterPoint:(int)position;

/**
 *  @author JopYin, 2016-07-11
 *
 *  通知服务器添加自选股
 *
 *  @param stockCode 股票代码
 */
+ (void)addStockFromServerWithStockCode:(NSString *)stockCode;

/**
 *  @author JopYin, 2016-07-11
 *
 *  通知服务器删除自选股
 *
 *  @param stockCode 要删除的股票代码
 */
+ (void)deleteStockFromServerWithStockCode:(NSString *)stockCode;
@end
