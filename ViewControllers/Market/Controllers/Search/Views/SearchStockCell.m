//
//  SearchStockCell.m
//  BigTimeStrategy
//
//  @Author: JopYin on 16/7/6.
//  Copyright © 2016年 安徽黄埔. All rights reserved.
//

#import "SearchStockCell.h"
#import "SearchStock.h"
#import "DertView.h"
@implementation SearchStockCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    DertView *line = [[DertView alloc] init];
    line.frame = CGRectMake(0, self.contentView.frame.size.height-0.5, self.contentView.frame.size.width, 0.5);
    line.backgroundColor =[UIColor clearColor];
    [self.contentView addSubview:line];
}

- (void)setModel:(StockModel *)model {
    _model = model;
    self.stockName.text = model.stockName;
    self.stockCode.text = model.stockCode;
    BOOL isFav = [[SearchStock shareManager] isExistInTable:model.stockCode];
    if (isFav) {
        self.addLabel.text = @"删除自选";
    }else {
        self.addLabel.text = @"添加自选";
    }
    self.addStockBtn.selected = isFav;
}
- (IBAction)addStock:(id)sender {
    self.addStockBtn.selected = !self.addStockBtn.selected;
    if (self.addStockBtn.selected) {
        self.addLabel.text = @"删除自选";
    }else {
        self.addLabel.text = @"添加自选";
    }
    if (self.addBtnBlock) {
        self.addBtnBlock();
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
