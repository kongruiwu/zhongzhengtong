//
//  InvestNoDataCell.m
//  CYX
//
//  Created by quanlonglong on 16/1/24.
//  Copyright © 2016年 Itachi. All rights reserved.
//

#import "InvestNoDataCell.h"

@implementation InvestNoDataCell

- (IBAction)addStock:(id)sender {
    if ([self.delegate respondsToSelector:@selector(pushFindStockVC)]) {
        [self.delegate pushFindStockVC];
    }
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
