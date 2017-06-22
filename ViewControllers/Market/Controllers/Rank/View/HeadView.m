//
//  HeadView.m
//  NewRenWang
//
//  Created by JopYin on 2017/1/13.
//  Copyright © 2017年 尹争荣. All rights reserved.
//

#import "HeadView.h"
#import "QuoteModel.h"
#import "iPhoneModel.h"
#import "ConfigHeader.h"

@interface HeadView ()

@property (weak, nonatomic) IBOutlet UIView  *SHView;
@property (weak, nonatomic) IBOutlet UILabel *SH_price;
@property (weak, nonatomic) IBOutlet UILabel *SH_rate;
@property (weak, nonatomic) IBOutlet UILabel *SH_change;

@property (weak, nonatomic) IBOutlet UIView  *SZView;
@property (weak, nonatomic) IBOutlet UILabel *SZ_price;
@property (weak, nonatomic) IBOutlet UILabel *SZ_rate;
@property (weak, nonatomic) IBOutlet UILabel *SZ_change;

@property (weak, nonatomic) IBOutlet UIView  *ZXView;
@property (weak, nonatomic) IBOutlet UILabel *ZX_price;
@property (weak, nonatomic) IBOutlet UILabel *ZX_rate;
@property (weak, nonatomic) IBOutlet UILabel *ZX_change;

@property (weak, nonatomic) IBOutlet UIView  *CYView;
@property (weak, nonatomic) IBOutlet UILabel *CY_price;
@property (weak, nonatomic) IBOutlet UILabel *CY_rate;
@property (weak, nonatomic) IBOutlet UILabel *CY_change;


@end


@implementation HeadView

- (void)layoutSubviews {
    [super layoutSubviews];
    self.height = 150;
    if ([[iPhoneModel iphoneType] isEqualToString:@"iPhone 5s"]||[[iPhoneModel iphoneType] isEqualToString:@"iPhone 5c"]) {
        self.SH_rate.font = kFont(11);
        self.SH_change.font = kFont(11);
        self.SZ_rate.font = kFont(11);
        self.SZ_change.font = kFont(10);
        self.ZX_rate.font = kFont(11);
        self.ZX_change.font = kFont(10);
        self.CY_rate.font = kFont(11);
        self.CY_change.font = kFont(11);
    }
}

+(instancetype)headView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)setDataArr:(NSMutableArray *)dataArr {
    _dataArr = dataArr;
    [dataArr enumerateObjectsUsingBlock:^(QuoteModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:obj.price];
            [AttributedStr addAttribute:NSFontAttributeName
                                  value:[UIFont fontWithName:@"Avenir-Roman" size:15.f]
                                  range:NSMakeRange(obj.price.length-2, 2)];
            self.SH_price.attributedText = AttributedStr;
            self.SH_change.text = obj.change;
            if ([obj.change floatValue] > 0) {
                self.SH_rate.text = [NSString stringWithFormat:@"↑%@",obj.changeRate];
                self.SHView.backgroundColor = UIColorFromRGB(0xC90011);//[UIColor colorWithHexString:@"C90011"];
            }else if ([obj.change floatValue] < 0){
                self.SH_rate.text = [NSString stringWithFormat:@"↓%@",obj.changeRate];
                self.SHView.backgroundColor = UIColorFromRGB(0x19BD9C);//[UIColor colorWithHexString:@"19BD9C"];
            }else {
                self.SH_rate.text = [NSString stringWithFormat:@"%@",obj.changeRate];
                self.SHView.backgroundColor = UIColorFromRGB(0xC90011);//[UIColor colorWithHexString:@"C90011"];
            }
        }else if (idx == 1){
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:obj.price];
            [AttributedStr addAttribute:NSFontAttributeName
                                  value:[UIFont fontWithName:@"Avenir-Roman" size:15.f]
                                  range:NSMakeRange(obj.price.length-2, 2)];
            self.SZ_price.attributedText = AttributedStr;
            self.SZ_change.text = obj.change;
            if ([obj.change floatValue] > 0) {
                self.SZ_rate.text = [NSString stringWithFormat:@"↑%@",obj.changeRate];
                self.SZView.backgroundColor = UIColorFromRGB(0xC90011);//[UIColor colorWithHexString:@"C90011"];
            }else if ([obj.change floatValue] < 0){
                self.SZ_rate.text = [NSString stringWithFormat:@"↓%@",obj.changeRate];
                self.SZView.backgroundColor = UIColorFromRGB(0x19BD9C);//[UIColor colorWithHexString:@"19BD9C"];
            }else {
                self.SZ_rate.text = [NSString stringWithFormat:@"%@",obj.changeRate];
                self.SZView.backgroundColor = UIColorFromRGB(0xC90011);//[UIColor colorWithHexString:@"C90011"];
            }
        }else if (idx == 2){
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:obj.price];
            [AttributedStr addAttribute:NSFontAttributeName
                                  value:[UIFont fontWithName:@"Avenir-Roman" size:15.f]
                                  range:NSMakeRange(obj.price.length-2, 2)];
            self.ZX_price.attributedText = AttributedStr;
            self.ZX_change.text = obj.change;
            if ([obj.change floatValue] > 0) {
                self.ZX_rate.text = [NSString stringWithFormat:@"↑%@",obj.changeRate];
                self.ZXView.backgroundColor = UIColorFromRGB(0xC90011);//[UIColor colorWithHexString:@"C90011"];
            }else if ([obj.change floatValue] < 0){
                self.ZX_rate.text = [NSString stringWithFormat:@"↓%@",obj.changeRate];
                self.ZXView.backgroundColor = UIColorFromRGB(0x19BD9C);//[UIColor colorWithHexString:@"19BD9C"];
            }else {
                self.ZX_rate.text = [NSString stringWithFormat:@"%@",obj.changeRate];
                self.ZXView.backgroundColor = UIColorFromRGB(0xC90011);//[UIColor colorWithHexString:@"C90011"];
            }
        }else if (idx == 3){
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:obj.price];
            [AttributedStr addAttribute:NSFontAttributeName
                                  value:[UIFont fontWithName:@"Avenir-Roman" size:15.f]
                                  range:NSMakeRange(obj.price.length-2, 2)];
            self.CY_price.attributedText = AttributedStr;
            self.CY_change.text = obj.change;
            if ([obj.change floatValue] > 0) {
                self.CY_rate.text = [NSString stringWithFormat:@"↑%@",obj.changeRate];
                self.CYView.backgroundColor = UIColorFromRGB(0xC90011);//[UIColor colorWithHexString:@"C90011"];
            }else if ([obj.change floatValue] < 0){
                self.CY_rate.text = [NSString stringWithFormat:@"↓%@",obj.changeRate];
                self.CYView.backgroundColor = UIColorFromRGB(0x19BD9C);//[UIColor colorWithHexString:@"19BD9C"];
            }else {
                self.CY_rate.text = [NSString stringWithFormat:@"%@",obj.changeRate];
                self.CYView.backgroundColor = UIColorFromRGB(0xC90011);//[UIColor colorWithHexString:@"C90011"];
            }
        }
    }];
}

- (IBAction)SHBtn:(id)sender {
//    if (![NetworkRequestTools isExistenceNetWork]) {
//        return;
//    }
    if (self.SHBlock) {
        self.SHBlock();
    }
}
- (IBAction)SZBtn:(id)sender {
//    if (![NetworkRequestTools isExistenceNetWork]) {
//        return;
//    }
    if (self.SZBlock) {
        self.SZBlock();
    }
}
- (IBAction)ZXBtn:(id)sender {
//    if (![NetworkRequestTools isExistenceNetWork]) {
//        return;
//    }
    if (self.ZXBlock) {
        self.ZXBlock();
    }
}
- (IBAction)CYBtn:(id)sender {
//    if (![NetworkRequestTools isExistenceNetWork]) {
//        return;
//    }
    if (self.CYBlock) {
        self.CYBlock();
    }
}

@end
