//
//  HistoryStockView.h
//  NewRenWang
//
//  Created by JopYin on 2017/1/12.
//  Copyright © 2017年 尹争荣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindStockDelegate.h"

@interface HistoryStockView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) id<FindStockDelegate>delegate;

@property (nonatomic, strong)UITableView *hisTableView;
@property (nonatomic, strong)UIView *headerView;
@property (nonatomic, strong)NSMutableArray *hisStockArr;


@end
