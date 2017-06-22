//
//  FindStockVC.m
//  NewRenWang
//
//  Created by JopYin on 2017/1/12.
//  Copyright © 2017年 尹争荣. All rights reserved.
//

#import "FindStockVC.h"
#import "WMXPickerTF.h"
#import "SearchView.h"
#import "StockDetailVC.h"
#import "StockModel.h"

@interface FindStockVC ()<WMXPickerTFDelegate,UIScrollViewDelegate,FindStockDelegate>

@property (nonatomic, strong) UIView *searchBackgroundView;

@property (nonatomic, strong) WMXPickerTF *searchTextField;

@property (nonatomic, strong)SearchView *searchView;

@end

@implementation FindStockVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawBackButton];
    // Do any additional setup after loading the view.
    self.searchView = [[SearchView alloc] initWithFrame:self.view.bounds];
    self.searchView.delegate = self;
    [self.view addSubview:self.searchView];
    // 搜索框
    CGFloat statueHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat searchBackgroundViewHeight = 25.0;
    self.searchBackgroundView = [[UIView alloc] initWithFrame:CGRectMake((self.view.width-250.0)/2, (44 - searchBackgroundViewHeight) / 2.0 + statueHeight, 250.0, searchBackgroundViewHeight)];
    self.searchBackgroundView.backgroundColor = [UIColor whiteColor];
    self.searchBackgroundView.layer.cornerRadius = 5.0;
    self.searchBackgroundView.layer.masksToBounds = YES;
    self.navigationItem.titleView = self.searchBackgroundView;
    
    UIImageView *searchIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];
    searchIconImageView.frame = CGRectMake(10.0, (self.searchBackgroundView.height - searchIconImageView.image.size.height) / 2.0, searchIconImageView.image.size.width, searchIconImageView.image.size.height);
    [self.searchBackgroundView addSubview:searchIconImageView];
    
    CGFloat textFieldXFloat = searchIconImageView.x + searchIconImageView.width + 10.0;
    self.searchTextField = [[WMXPickerTF alloc] initWithFrame:CGRectMake(textFieldXFloat, 0.0, self.searchBackgroundView.width - textFieldXFloat - 10.0, self.searchBackgroundView.height)];
    self.searchTextField.placeholder = @"代码/简拼";
    self.searchTextField.textColor = [UIColor blackColor];
    self.searchTextField.font = [UIFont systemFontOfSize:14.0];
//    self.searchTextField.returnKeyType = UIReturnKeySearch;
    [self.searchBackgroundView addSubview:self.searchTextField];
    self.searchTextField.pickerDelegate = self;
}
#pragma mark - 实现WMXPickerTFDelegate的代理方法
- (void)somethingChanged:(WMXPickerTF *)pickerTF {
    if (pickerTF == self.searchTextField) {
        if (![self.searchTextField.text isEqualToString:@""]) {
            [self.searchView searchKeywords:self.searchTextField.text];
        }else{
            [self.searchView clearInputTxtForShowHistoryView];
        }
        [self.searchTextField becomeFirstResponder];
    }
}

#pragma mark - 实现scrollView的代理 当tableView上下滚动则辞去输入框响应
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchTextField resignFirstResponder];
}


#pragma mark FindStockDelegate
- (void)pushStockDetailWithModel:(StockModel *)model{
    if (model.stockCode == nil) {
        return ;
    }
    StockDetailVC *stockVC = [[StockDetailVC alloc] initWithStockCode:model.stockCode withStockName:model.stockName];
    [self.navigationController pushViewController:stockVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
