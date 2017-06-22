//
//  Factory.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/15.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "Factory.h"

@implementation Factory

/**
creat tabview
*/
+ (UITableView *)creatTabviewWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    UITableView * tabview = [[UITableView alloc]initWithFrame:frame style:style];
    tabview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabview.showsVerticalScrollIndicator = NO;
    tabview.showsHorizontalScrollIndicator = NO;
    tabview.backgroundColor = [UIColor clearColor];
    return tabview;
}

/**
 creat Label
 */
+ (UILabel *)creatLabelWithText:(NSString *)title fontValue:(float)font textColor:(UIColor *)color textAlignment:(NSTextAlignment)alignment{
    UILabel * label = [[UILabel alloc]init];
    label.text = title;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:font];
    label.textAlignment = alignment;
    return label;
}
/**
 set label border
 */
+ (void)setLabel:(UILabel *)label BorderColor:(UIColor *)color with:(CGFloat)withValue cornerRadius:(CGFloat)radiusValue{
    label.layer.borderColor = color.CGColor;
    label.layer.borderWidth = withValue;
    label.layer.cornerRadius = radiusValue;
}
/**
 creat button
 */
+ (UIButton *)creatButtonWithTitle:(NSString *)title backGroundColor:(UIColor *)groundColor textColor:(UIColor *)textColor textSize:(float)fontValue{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundColor:groundColor];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:fontValue];
    
    return button;
}
+ (UIButton *)creatButtonWithNormalImage:(NSString *)normalImage selectImage:(NSString *)selectImage{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    if (selectImage != nil) {
        [button setImage:[UIImage imageNamed:selectImage] forState:UIControlStateSelected];
    }
    return button;
}

/**
 creat imgView with img
 */
+ (UIImageView *)creatImageViewWithImage:(NSString *)imageName{
    UIImageView * imgView = [[UIImageView alloc]init];
    imgView.image = [UIImage imageNamed:imageName];
    return imgView;
}

/**
 creat arrrowimage
 */
+ (UIImageView *)creatArrowImage{
    UIImageView * imgview = [[UIImageView alloc]init];
    imgview.image = [UIImage imageNamed:@"next"];
    return imgview;
}

/**
 creat line
 */
+ (UIView *)creatLineView{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.94 alpha:1.00];
    return view;
}

/**
 creat color view
 */
+ (UIView *)creatViewWithColor:(UIColor *)color{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = color;
    return view;
}
/**
 打电话
 */
+ (void)callPhoneStr:(NSString*)phoneStr withVC:(UIViewController *)selfvc{
    if (phoneStr.length >= 10) {
        NSString *str2 = [[UIDevice currentDevice] systemVersion];
        if ([str2 compare:@"10.2" options:NSNumericSearch] == NSOrderedDescending || [str2 compare:@"10.2" options:NSNumericSearch] == NSOrderedSame)
        {
            NSString* PhoneStr = [NSString stringWithFormat:@"telprompt://%@",phoneStr];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PhoneStr] options:@{} completionHandler:^(BOOL success) {
                NSLog(@"phone success");
            }];
            
        }else {
            NSMutableString* str1 = [[NSMutableString alloc]initWithString:phoneStr];// 存在堆区，可变字符串
            if (phoneStr.length == 10) {
                [str1 insertString:@"-"atIndex:3];// 把一个字符串插入另一个字符串中的某一个位置
                [str1 insertString:@"-"atIndex:7];// 把一个字符串插入另一个字符串中的某一个位置
            }else {
                [str1 insertString:@"-"atIndex:3];// 把一个字符串插入另一个字符串中的某一个位置
                [str1 insertString:@"-"atIndex:8];// 把一个字符串插入另一个字符串中的某一个位置
            }
            NSString * str = [NSString stringWithFormat:@"是否拨打电话\n%@",str1];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:str message: nil preferredStyle:UIAlertControllerStyleAlert];
            // 设置popover指向的item
            alert.popoverPresentationController.barButtonItem = selfvc.navigationItem.leftBarButtonItem;
            // 添加按钮
            [alert addAction:[UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                NSLog(@"点击了呼叫按钮10.2下");
                NSString* PhoneStr = [NSString stringWithFormat:@"tel://%@",phoneStr];
                if ([PhoneStr hasPrefix:@"sms:"] || [PhoneStr hasPrefix:@"tel:"]) {
                    UIApplication * app = [UIApplication sharedApplication];
                    if ([app canOpenURL:[NSURL URLWithString:PhoneStr]]) {
                        [app openURL:[NSURL URLWithString:PhoneStr]];
                    }
                }
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                NSLog(@"点击了取消按钮");
            }]];
            [selfvc presentViewController:alert animated:YES completion:nil];
        }
    }
}
/**
 MD5 转换
 */
+ (NSString *) MD5HashWithString:(NSString *)string {
    
    CC_MD5_CTX md5;
    CC_MD5_Init (&md5);
    CC_MD5_Update (&md5, [string UTF8String], (CC_LONG) [string length]);
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final (digest, &md5);
    NSString *s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0],  digest[1],
                   digest[2],  digest[3],
                   digest[4],  digest[5],
                   digest[6],  digest[7],
                   digest[8],  digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    
    return s;
    
}

+ (NSString *)encodeUrlString:(NSString *)string {
    return CFBridgingRelease(
                             CFURLCreateStringByAddingPercentEscapes(
                                                                     kCFAllocatorDefault,
                                                                     (__bridge CFStringRef)string,
                                                                     NULL,
                                                                     CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                     kCFStringEncodingUTF8)
                             );
}
/**
 get size
 */
+ (CGSize)getSize:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont*)font{
    CGSize sizeFirst = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:font} context:nil].size;
    return sizeFirst;
}
/**
 图片地址转换
 */
+ (NSURL *)getImageUlr:(NSString *)imgUrl{
    NSMutableString * imgStr = [NSMutableString stringWithFormat:@"%@%@",BaseImgUrl,[self encodeUrlString:imgUrl]];
    [imgStr stringByReplacingOccurrencesOfString:@"%5C" withString:@"/"];
    return [NSURL URLWithString:imgStr];
}
@end
