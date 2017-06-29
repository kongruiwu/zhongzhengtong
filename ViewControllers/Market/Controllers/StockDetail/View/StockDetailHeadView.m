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
@property (weak, nonatomic) IBOutlet UILabel *closePrice;
@property (weak, nonatomic) IBOutlet UILabel *jingLiu;  //资金金流入

@property (weak, nonatomic) IBOutlet UIButton *addStock;        //添加自选按钮

@property (weak, nonatomic) IBOutlet UIButton *fenShiBtn;
@property (weak, nonatomic) IBOutlet UIButton *dayBtn;
@property (weak, nonatomic) IBOutlet UIButton *weekBtn;
@property (weak, nonatomic) IBOutlet UIButton *monthBtn;
@property (weak, nonatomic) IBOutlet UIButton *hourBtn;

@property (weak, nonatomic) IBOutlet UIView *btnBackView;  //分时、日线、周线的背景view
@property (weak, nonatomic) IBOutlet UIView *headView;

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

- (void)setModel:(QuoteModel *)model {
    _model = model;
    
    if ([model.change floatValue] < 0) {
        self.headView.backgroundColor = kRGBColor(9, 201, 153);
    }else if ([model.change floatValue] >= 0){
        self.headView.backgroundColor = kRGBColor(239, 86, 74);
    }
    
    BOOL isFav = [[SearchStock shareManager] isExistInTable:model.stockCode];
    self.addStock.selected = isFav;
    
    self.price.text = model.price;
    self.change.text = model.change;
    self.rate.text = model.changeRate;
    
    self.closePrice.text = model.closePrice;
    self.openPrice.text = model.openPrice;
    self.highPrice.text = model.highPrice;
    self.lowPrice.text = model.lowPrice;
    self.VOL.text = [NSString stringWithFormat:@"%@",[StockPublic calculateFloat:[model.VOL floatValue]]];
    self.amount.text = [NSString stringWithFormat:@"%@",[StockPublic changePrice:[model.amount floatValue]]];
}

#pragma mark- 公共方法用于更新界面--- 用setModel代替
- (void)updateUI:(QuoteModel *)model{
    BOOL isFav = [[SearchStock shareManager] isExistInTable:model.stockCode];
    self.addStock.selected = isFav;
    
    self.price.text = model.price;
    self.change.text = model.change;
    self.rate.text = model.changeRate;
    
    self.closePrice.text = model.closePrice;
    self.openPrice.text = model.openPrice;
    self.highPrice.text = model.highPrice;
    self.lowPrice.text = model.lowPrice;
    self.VOL.text = [NSString stringWithFormat:@"%@",[StockPublic calculateFloat:[model.VOL floatValue]]];
    self.amount.text = [NSString stringWithFormat:@"%@",[StockPublic changePrice:[model.amount floatValue]]];
    
}

#pragma mark - 赋值资金金流入
- (void)updateZiJin:(NSString *)ziJin{
    self.jingLiu.text = [NSString stringWithFormat:@"%@",ziJin];
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


- (IBAction)addStock:(id)sender {
    self.addStock.selected = !self.addStock.selected;
    if ([[SearchStock shareManager] isExistInTable:self.model.stockCode]) {
        [StockPublic deleteStockFromServerWithStockCode:self.model.stockCode]; //向服务器删除自选
        [[SearchStock shareManager] deleteToTable:self.model.stockCode];
    }else {
        [StockPublic addStockFromServerWithStockCode:self.model.stockCode];  //向服务器添加自选
        [[SearchStock shareManager] insertToTable:self.model.stockCode];
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
    [self.addStock setLayerCornerRadius:2.0f borderWidth:1.0 borderColor:kRGBColor(255,255, 255)];
    
}



@end
