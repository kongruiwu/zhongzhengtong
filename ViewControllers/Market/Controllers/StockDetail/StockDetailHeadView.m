//
//  StockDetailHeadView.m
//  NewRenWang
//
//  Created by JopYin on 2017/1/20.
//  Copyright © 2017年 尹争荣. All rights reserved.
//

#import "StockDetailHeadView.h"
#import <QuartzCore/QuartzCore.h>
#import "StockPublic.h"
#import "ConfigHeader.h"

@interface StockDetailHeadView()
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *rate;
@property (weak, nonatomic) IBOutlet UILabel *change;
@property (weak, nonatomic) IBOutlet UILabel *openPrice;
@property (weak, nonatomic) IBOutlet UILabel *highPrice;
@property (weak, nonatomic) IBOutlet UILabel *lowPrice;
@property (weak, nonatomic) IBOutlet UILabel *VOL;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UILabel *jingLiu;  //资金金流入

@property (weak, nonatomic) IBOutlet UIButton *fenShiBtn;
@property (weak, nonatomic) IBOutlet UIButton *dayBtn;
@property (weak, nonatomic) IBOutlet UIButton *weekBtn;
@property (weak, nonatomic) IBOutlet UIButton *monthBtn;
@property (weak, nonatomic) IBOutlet UIButton *hourBtn;

@property (weak, nonatomic) IBOutlet UIView *btnBackView;  //分时、日线、周线的背景view

@property (weak,nonatomic) UIButton *tmpBtn;

@end


@implementation StockDetailHeadView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.dayBtn.enabled = NO;
    self.dayBtn.backgroundColor = [UIColor colorWithHexString:@"114068"];
    self.tmpBtn = self.dayBtn;
}

#pragma mark - 更新上部分
- (void)updateUI:(QuoteModel *)model{
    if ([model.change floatValue] < 0) {
        UIColor *color = [UIColor colorWithHexString:@"19BD9C"];
        self.price.textColor = color;
        self.rate.textColor = color;
        self.change.textColor = color;
        self.rate.text = [NSString stringWithFormat:@"↓%@",model.changeRate];
    }else if ([model.change floatValue] > 0){
        UIColor *color = [UIColor colorWithHexString:@"C90011"];
        self.price.textColor = color;
        self.change.textColor = color;
        self.rate.textColor = color;
        self.rate.text = [NSString stringWithFormat:@"↑%@",model.changeRate];
    }else{
        UIColor *color = [UIColor blackColor];
        self.price.textColor = color;
        self.change.textColor = color;
        self.rate.textColor = color;
        self.rate.text = model.changeRate;
    }
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:model.price];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont fontWithName:@"Avenir-Roman" size:14.f]
                          range:NSMakeRange(model.price.length-2, 2)];
    self.price.attributedText = AttributedStr;
    self.change.text = model.change;
    self.openPrice.text = [NSString stringWithFormat:@"  开盘:%@",model.openPrice];
    self.highPrice.text = [NSString stringWithFormat:@"  最高:%@",model.highPrice];
    self.lowPrice.text = [NSString stringWithFormat:@"  最低:%@",model.lowPrice];
    self.VOL.text = [NSString stringWithFormat:@"成交量:%@",[StockPublic calculateFloat:[model.VOL floatValue]]];
    self.amount.text = [NSString stringWithFormat:@"成交额:%@",[StockPublic changePrice:[model.amount floatValue]]];
    
}

#pragma mark - 赋值资金金流入
- (void)updateZiJin:(NSString *)ziJin{
    self.jingLiu.text = [NSString stringWithFormat:@"净流:%@",ziJin];
}


#pragma mark -LifeCycle

+(instancetype)headView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (IBAction)fenShi:(UIButton *)sender {
    [self setSelectButton:sender];
    if ([self.delegate respondsToSelector:@selector(fenShiLine)]) {
        [self.delegate fenShiLine];
    }
}

- (IBAction)day:(UIButton *)sender {
    [self setSelectButton:sender];
    if ([self.delegate respondsToSelector:@selector(dayKLine)]) {
        [self.delegate dayKLine];
    }
}

- (IBAction)week:(UIButton *)sender {
    [self setSelectButton:sender];
    if ([self.delegate respondsToSelector:@selector(weekLine)]) {
        [self.delegate weekLine];
    }
}

- (IBAction)month:(UIButton *)sender {
    [self setSelectButton:sender];
    if ([self.delegate respondsToSelector:@selector(monthKLine)]) {
        [self.delegate monthKLine];
    }
}

- (IBAction)hour:(UIButton *)sender {
    [self setSelectButton:sender];
    if ([self.delegate respondsToSelector:@selector(hourKLine)]) {
        [self.delegate hourKLine];
    }
    
}

#pragma mark - 还原未点击的按钮状态 设置被点击按钮状态
- (void)setSelectButton:(UIButton *)selBtn{
    self.tmpBtn.enabled = YES;
    selBtn.enabled = NO;
    selBtn.backgroundColor = [UIColor colorWithHexString:@"114068"];
    self.tmpBtn.backgroundColor = [UIColor clearColor];
    self.tmpBtn = selBtn;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.btnBackView.layer.borderWidth = 0.5;
    self.btnBackView.layer.borderColor = [[UIColor colorWithHexString:@"7D7D7D"] CGColor];
    
}



@end
