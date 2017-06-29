//
//  ResultStockView.m
//  NewRenWang
//
//  Created by JopYin on 2017/1/12.
//  Copyright © 2017年 尹争荣. All rights reserved.
//

#import "ResultStockView.h"
#import "SearchStock.h"
#import "SearchStockCell.h"
#import "StockDetailVC.h"
#import "ConfigHeader.h"

static NSString *const FindCell = @"SearchStockCell";

@implementation ResultStockView

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
    self.resTableView = [[UITableView alloc] initWithFrame:self.bounds];
    self.resTableView.height = self.height-70;
    self.resTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.resTableView.backgroundColor = UIColorFromRGB(0xFFFFFF);//[UIColor colorWithHexString:@"#FFFFFF"];
    self.resTableView.showsVerticalScrollIndicator = NO;
    UINib *nib = [UINib nibWithNibName:FindCell bundle:nil];
    [self.resTableView registerNib:nib forCellReuseIdentifier:FindCell];
    [self.resTableView deselectRowAtIndexPath:[self.resTableView indexPathForSelectedRow] animated:YES];
    
    self.resTableView.delegate = self;
    self.resTableView.dataSource = self;
    [self addSubview:self.resTableView];
}

- (void)showStock:(NSString *)keyWord{
    if ([self isChar:keyWord]) {
        self.resStockArr = [[SearchStock shareManager] searchStockJP:keyWord];
    }else {
        self.resStockArr = [[SearchStock shareManager] searchStockCode:keyWord];
    }
    [self.resTableView reloadData];
}

#pragma mark -判断输入的字符是否有效
- (BOOL)isChar:(NSString *)strSource {
    for (int i = 0; i < strSource.length; ++i)
    {
        if(([strSource characterAtIndex:i] >= 'A' && [strSource characterAtIndex:i] <= 'Z') ||
           ([strSource characterAtIndex:i] >= 'a' && [strSource characterAtIndex:i] <= 'z')) {
            return YES;
        }
    }
    return  NO;
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
        headerLabel.text = @"搜索结果";
        [headerLabel sizeToFit];
        [_headerView addSubview:headerLabel];
        headerLabel.x = 20.0;
        headerLabel.y = (headerHeight - headerLabel.height)/2;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _headerView.height - 0.5, _headerView.width, 0.5)];
        lineView.backgroundColor = UIColorFromRGB(0xD2D4D5);//[UIColor colorWithHexString:@"D2D4D5"];
        [_headerView addSubview:lineView];
    }
    
    return _headerView;
}

#pragma mark numberOfRowsInSection
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resStockArr.count ;
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
    StockModel *model = [self.resStockArr objectAtIndexCheck:indexPath.row];
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
    StockModel *model = [self.resStockArr objectAtIndexCheck:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(pushStockDetailWithModel:)]) {
        [self.delegate pushStockDetailWithModel:model];
    }
//    StockDetailVC *stockVC = [[StockDetailVC alloc] initWithStockCode:model.stockCode withStockName:model.stockName];
//    [self.navigationController pushViewController:stockVC animated:YES];
}


@end
