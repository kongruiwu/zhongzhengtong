//
//  StockDetailSectionView.m
//  ZhongZhengTong
//
//  Created by JopYin on 2017/6/29.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "StockDetailSectionView.h"
#import "ConfigHeader.h"

@interface StockDetailSectionView()
@property(nonatomic,weak)UIButton * selectBtn;
@property(nonatomic,weak)UIView * indicatorView;

@end

@implementation StockDetailSectionView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    self.backgroundColor = kRGBColor(245, 245, 245);
    
    CGFloat space = 40;
    CGFloat buttonW = (UI_WIDTH-40)/2;
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.tag = 1314;
    leftBtn.frame = CGRectMake(0, 10, buttonW, 15);
    [leftBtn setTitleColor:kRGBColor(102, 102, 102) forState:UIControlStateNormal];
    [leftBtn setTitleColor:kRGBColor(196, 54, 54) forState:UIControlStateDisabled];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:font750(28)];
    [leftBtn addTarget:self action:@selector(titleSelect:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setTitle:@"五档行情" forState:UIControlStateNormal];
    [self addSubview:leftBtn];
    
    
    UIButton * videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    videoBtn.tag = 1314+1;
    videoBtn.frame = CGRectMake(buttonW+space, 10, buttonW, 15);
    [videoBtn setTitleColor:kRGBColor(102, 102, 102) forState:UIControlStateNormal];
    [videoBtn setTitleColor:kRGBColor(196, 54, 54) forState:UIControlStateDisabled];
    videoBtn.titleLabel.font = [UIFont systemFontOfSize:font750(28)];
    [videoBtn addTarget:self action:@selector(titleSelect:) forControlEvents:UIControlEventTouchUpInside];
    [videoBtn setTitle:@"成交明细" forState:UIControlStateNormal];
    [self addSubview:videoBtn];
    
    
    UIView *indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 33, leftBtn.titleLabel.width, 2)];
    indicatorView.backgroundColor = kRGBColor(196, 54, 54);
    indicatorView.height = 2;
    indicatorView.y = 33;
    indicatorView.width = 40;
    
    indicatorView.centerX = leftBtn.centerX;
    
    self.indicatorView = indicatorView;
    [self addSubview:indicatorView];
    
    
    leftBtn.enabled = NO;
    self.selectBtn = leftBtn;
    
}

- (void)titleSelect:(UIButton *)btn{
    self.selectBtn.enabled = YES;
    btn.enabled = NO;
    self.selectBtn = btn;
    //改变指示器
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.centerX = btn.centerX;
    }];
    
    
    if (btn.tag == 1314) {
        self.dealType = FiveDang;
    }else if(btn.tag == 1315){
        self.dealType = DealDetail;
    }
    if (self.headClickBlock) {
        self.headClickBlock(self.dealType);
    }
}


@end
