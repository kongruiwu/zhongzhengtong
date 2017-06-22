//
//  SearchStockCell.h
//  BigTimeStrategy
//
//  @Author: JopYin on 16/7/6.
//  Copyright © 2016年 安徽黄埔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockModel.h"
typedef void(^addButtonBlock)();

@interface SearchStockCell : UITableViewCell

@property (nonatomic, strong) StockModel *model;

@property (weak, nonatomic) IBOutlet UILabel *stockName;
@property (weak, nonatomic) IBOutlet UILabel *stockCode;
@property (weak, nonatomic) IBOutlet UIButton *addStockBtn;
@property (weak, nonatomic) IBOutlet UILabel *addLabel;
@property (copy,nonatomic)addButtonBlock addBtnBlock;

@end
