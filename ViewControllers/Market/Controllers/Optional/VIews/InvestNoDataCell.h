//
//  InvestNoDataCell.h
//  CYX
//
//  Created by quanlonglong on 16/1/24.
//  Copyright © 2016年 Itachi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InvestNoDataCell;

@protocol InvestNoDelegate <NSObject>

- (void)pushFindStockVC;

@end

@interface InvestNoDataCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (weak, nonatomic) id<InvestNoDelegate>delegate;


@end
