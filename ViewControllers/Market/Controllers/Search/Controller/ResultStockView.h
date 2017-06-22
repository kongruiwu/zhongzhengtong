//
//  ResultStockView.h
//  NewRenWang
//
//  Created by JopYin on 2017/1/12.
//  Copyright © 2017年 尹争荣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindStockDelegate.h"


@interface ResultStockView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) id<FindStockDelegate>delegate;

@property (nonatomic, strong)UITableView *resTableView;
@property (nonatomic, strong)UIView *headerView;
@property (nonatomic, strong)NSMutableArray *resStockArr;

- (void)showStock:(NSString *)keyWord;

@end
