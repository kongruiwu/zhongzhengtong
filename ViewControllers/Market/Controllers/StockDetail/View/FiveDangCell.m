//
//  FiveDangCell.m
//  JinShiDai
//
//  Created by JopYin on 2017/6/29.
//  Copyright © 2017年 尹争荣. All rights reserved.
//

#import "FiveDangCell.h"
#import "ConfigHeader.h"
@interface FiveDangCell()
@property (weak, nonatomic) IBOutlet UILabel *sell5A;
@property (weak, nonatomic) IBOutlet UILabel *sell5B;
@property (weak, nonatomic) IBOutlet UILabel *sell4A;
@property (weak, nonatomic) IBOutlet UILabel *sell4B;
@property (weak, nonatomic) IBOutlet UILabel *sell3A;
@property (weak, nonatomic) IBOutlet UILabel *sell3B;
@property (weak, nonatomic) IBOutlet UILabel *sell2A;
@property (weak, nonatomic) IBOutlet UILabel *sell2B;
@property (weak, nonatomic) IBOutlet UILabel *sell1A;
@property (weak, nonatomic) IBOutlet UILabel *sell1B;


@property (weak, nonatomic) IBOutlet UILabel *buy1A;
@property (weak, nonatomic) IBOutlet UILabel *buy1B;
@property (weak, nonatomic) IBOutlet UILabel *buy2A;
@property (weak, nonatomic) IBOutlet UILabel *buy2B;
@property (weak, nonatomic) IBOutlet UILabel *buy3A;
@property (weak, nonatomic) IBOutlet UILabel *buy3B;
@property (weak, nonatomic) IBOutlet UILabel *buy4A;
@property (weak, nonatomic) IBOutlet UILabel *buy4B;
@property (weak, nonatomic) IBOutlet UILabel *buy5A;
@property (weak, nonatomic) IBOutlet UILabel *buy5B;

@end

@implementation FiveDangCell

- (void)setModel:(QuoteModel *)model {
    if (model == nil) {
        return ;
    }
    _model = model;
    NSArray *sellPriceArr = [[NSArray alloc] initWithObjects:_sell1A, _sell2A,_sell3A,_sell4A,_sell5A, nil];
    NSArray *sellVolArr = [[NSArray alloc] initWithObjects:_sell1B, _sell2B,_sell3B,_sell4B,_sell5B, nil];
    NSArray *buyPriceArr = [[NSArray alloc] initWithObjects:_buy1A, _buy2A,_buy3A,_buy4A,_buy5A, nil];
    NSArray *buyVolArr = [[NSArray alloc] initWithObjects:_buy1B, _buy2B,_buy3B,_buy4B,_buy5B, nil];
    for (int i=0; i < 5; i++) {
        UILabel *sellPrice = sellPriceArr[i];
        UILabel *sellVol = sellVolArr[i];
        UILabel *buyPrice = buyPriceArr[i];
        UILabel *buyVol = buyVolArr[i];
        
        sellPrice.text = model.sellPrice[i];
        sellVol.text = [StockPublic caldata:model.sellVOL[i]];
        buyPrice.text = model.buyPrice[i];
        buyVol.text  = [StockPublic caldata:model.buyVOL[i]];
        
        if ([model.sellPrice[i] floatValue] >= [model.closePrice floatValue]) {
            sellPrice.textColor = [UIColor colorWithHexString:@"#EF564A"];
        }else{
            sellPrice.textColor = [UIColor colorWithHexString:@"#09C999"];
        }
        if ([model.buyPrice[i] floatValue] >= [model.closePrice floatValue]) {
            buyPrice.textColor = [UIColor colorWithHexString:@"#EF564A"];
        }else{
            buyPrice.textColor = [UIColor colorWithHexString:@"#09C999"];
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
