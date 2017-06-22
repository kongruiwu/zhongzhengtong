//
//  FSDetailTableViewCell.m
//  YunZhangCaiJing
//
//  @Author: JopYin on 16/3/31.
//  Copyright © 2016年 JopYin. All rights reserved.
//

#import "FSDetailTableViewCell.h"
#import "StockPublic.h"
#import "ConfigHeader.h"

@implementation FSDetailTableViewCell

- (void)setModel:(FenBiModel *)model{
    _model = model;
    if ([model.Price floatValue]>= [model.preClose floatValue]) {
        self.priceLabel.textColor = UIColorFromRGB(0xC90011);//[UIColor colorWithHexString:@"#C90011"];
    }else{
        self.priceLabel.textColor = UIColorFromRGB(0x19BD9C);//[UIColor colorWithHexString:@"#19BD9C"];
    }
    self.timeLabel.text = model.time;
    self.priceLabel.text = model.Price;
    self.volumeLabel.text = [StockPublic caldata:model.VOL];
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
