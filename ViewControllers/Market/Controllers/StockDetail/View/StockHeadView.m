//
//  StockHeadView.m
//  NewRenWang
//
//  Created by JopYin on 2017/2/7.
//  Copyright © 2017年 尹争荣. All rights reserved.
//

#import "StockHeadView.h"
#import "SGSegmentedControl.h"
#import "ConfigHeader.h"

@interface StockHeadView ()<SGSegmentedControlStaticDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) SGSegmentedControlStatic *topSView;

@end

@implementation StockHeadView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    self.contentView.backgroundColor = [UIColor whiteColor];
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = UIColorFromRGB(0x7D7D7D);//[UIColor colorWithHexString:@"7D7D7D"];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.height.equalTo(@0.5);
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
    }];
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = UIColorFromRGB(0x7D7D7D);//[UIColor colorWithHexString:@"7D7D7D"];
    [self addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(0);
        make.height.equalTo(@0.2);
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
    }];
//    NSArray *title_arr = @[@"新闻", @"股吧", @"公告", @"问答"];
    NSArray *title_arr = @[@"新闻",@"公告",@"研报"];
    self.topSView = [SGSegmentedControlStatic segmentedControlWithFrame:CGRectMake(0, 0, UI_WIDTH, 44) delegate:self childVcTitle:title_arr indicatorIsFull:NO];
    // 必须实现的方法
    [self.topSView SG_setUpSegmentedControlType:^(SGSegmentedControlStaticType *segmentedControlStaticType, NSArray *__autoreleasing *nomalImageArr, NSArray *__autoreleasing *selectedImageArr) {
        
    }];
    self.topSView.selectedIndex = 0;
    [self addSubview:_topSView];
}

- (void)SGSegmentedControlStatic:(SGSegmentedControlStatic *)segmentedControlStatic didSelectTitleAtIndex:(NSInteger)index {
    // 计算滚动的位置
    if ([self.delegate respondsToSelector:@selector(changeStockNewsStyleWith:)]) {
        [self.delegate changeStockNewsStyleWith:index];
    }
}
@end
