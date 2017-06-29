//
//  HistoryStockView.m
//  NewRenWang
//
//  Created by JopYin on 2017/1/12.
//  Copyright © 2017年 尹争荣. All rights reserved.
//

#import "HistoryStockView.h"
#import "SearchStockCell.h"
#import "SearchStock.h"
#import "SearchHistoryCacheManager.h"
#import "ConfigHeader.h"

static NSString *const FindCell = @"SearchStockCell";

@implementation HistoryStockView

#pragma mark - LifeCycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self createUI];
    }
    
    return self;
}

#pragma mark - Private Method
#pragma mark 创建视图
- (void)createUI {
    //从数据库中获取浏览的股票
    
    self.hisStockArr = [[SearchHistoryCacheManager shareInstance] searchHistoryKeywords];   //获取搜索历史
    self.hisTableView = [[UITableView alloc] initWithFrame:self.bounds];
    self.hisTableView.height = self.height-70;
    self.hisTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.hisTableView.backgroundColor =[UIColor whiteColor];//[UIColor colorWithHexString:@"#FFFFFF"];
    self.hisTableView.showsVerticalScrollIndicator = NO;
    UINib *nib = [UINib nibWithNibName:FindCell bundle:nil];
    [self.hisTableView registerNib:nib forCellReuseIdentifier:FindCell];
    [self.hisTableView deselectRowAtIndexPath:[self.hisTableView indexPathForSelectedRow] animated:YES];

    self.hisTableView.delegate = self;
    self.hisTableView.dataSource = self;
    [self addSubview:self.hisTableView];
}


#pragma mark - Table view data source
#pragma mark numberOfSectionsInTableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark heightForHeaderInSection
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

#pragma mark viewForFooterInSection
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (!_headerView) {
        CGFloat headerHeight = [self tableView:tableView heightForHeaderInSection:section];
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, headerHeight)];
        _headerView.backgroundColor = UIColorFromRGB(0xF6F6F6);//[UIColor colorWithHexString:@"#F6F6F6"];
        
        UILabel *headerLabel = [[UILabel alloc] init];
        headerLabel.font = [UIFont systemFontOfSize:15.0];
        headerLabel.textColor = UIColorFromRGB(0x7D7D7D);//[UIColor colorWithHexString:@"#7D7D7D"];
        headerLabel.text = @"最近浏览的股票";
        [headerLabel sizeToFit];
        [_headerView addSubview:headerLabel];
        headerLabel.x = 15.0;
        headerLabel.y = (headerHeight - headerLabel.height)/2;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _headerView.height - 0.5, _headerView.width, 0.5)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"D2D4D5"];
        [_headerView addSubview:lineView];
    }
    
    return _headerView;
}

#pragma mark numberOfRowsInSection
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.hisStockArr.count ;
}

#pragma mark  heightForRowAtIndexPath
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

#pragma mark cellForRowAtIndexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchStockCell *cell = [tableView dequeueReusableCellWithIdentifier:FindCell];
    if (cell == nil) {
        cell = [[SearchStockCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FindCell];
    }
    StockModel *model = [self.hisStockArr objectAtIndexCheck:indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.addBtnBlock = ^{
        BOOL isFav = [[SearchStock shareManager] isExistInTable:model.stockCode];
        if (isFav) {
            [StockPublic deleteStockFromServerWithStockCode:model.stockCode];
            [[SearchStock shareManager] deleteToTable:model.stockCode];
        } else {
            [StockPublic addStockFromServerWithStockCode:model.stockCode];
            [[SearchStock shareManager] insertToTable:model.stockCode];
        }
    };
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    StockModel *model = [self.hisStockArr objectAtIndexCheck:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(pushStockDetailWithModel:)]) {
        [self.delegate pushStockDetailWithModel:model];
    }
}

@end
