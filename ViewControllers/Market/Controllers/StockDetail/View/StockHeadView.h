//
//  StockHeadView.h
//  NewRenWang
//
//  Created by JopYin on 2017/2/7.
//  Copyright © 2017年 尹争荣. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol StockNewsDelegate <NSObject>

- (void)changeStockNewsStyleWith:(NSInteger )index;

@end

@interface StockHeadView : UITableViewHeaderFooterView

@property (nonatomic ,weak)id <StockNewsDelegate> delegate;

@end
