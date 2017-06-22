//
//  StockCell.m
//  NewRenWang
//
//  Created by JopYin on 2017/1/11.
//  Copyright © 2017年 尹争荣. All rights reserved.
//

#import "StockCell.h"
#import "ConfigHeader.h"

@interface StockCell ()
@property (weak, nonatomic) IBOutlet UILabel *stockNama;
@property (weak, nonatomic) IBOutlet UILabel *stockCode;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *rate;
@property (weak, nonatomic) IBOutlet UIView *rateView;

@end


@implementation StockCell

- (void)setModel:(QuoteModel *)model {
    _model = model;
    self.stockNama.text = model.stockName;
    self.stockCode.text = model.stockCode;
    self.price.text = model.price;
    self.rate.text = model.changeRate;
    
    if ([model.change floatValue] < 0) {
        self.rateView.backgroundColor = [UIColor colorWithHexString:@"#19BD9C"];
    }else if ([model.change floatValue] >0){
        self.rateView.backgroundColor = [UIColor colorWithHexString:@"#C90011" ];
    }else{
        self.rateView.backgroundColor = [UIColor colorWithHexString:@"#C90011" ];
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
