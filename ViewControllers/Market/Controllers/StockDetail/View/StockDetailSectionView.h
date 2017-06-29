//
//  StockDetailSectionView.h
//  ZhongZhengTong
//
//  Created by JopYin on 2017/6/29.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    FiveDang,  //点击了五档
    DealDetail,   //点击了成交明细
}StockDetailType;

@interface StockDetailSectionView : UIView

@property(nonatomic,assign)StockDetailType dealType;

@property(nonatomic,copy) void(^ headClickBlock)(StockDetailType dealType);

@end
