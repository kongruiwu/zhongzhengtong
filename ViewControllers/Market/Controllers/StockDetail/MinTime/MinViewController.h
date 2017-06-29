//
//  MinViewController.h
//  GuShang
//
//  Created by JopYin on 2016/12/1.
//  Copyright © 2016年 尹争荣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKLineChart.h"

@interface MinViewController : UIViewController

@property (nonatomic,copy)NSString *stockCode;

@property (nonatomic,copy)NSString *preClose;    //昨收价，这个数据不能通过请求分时接口获取只能通过实时行情接口获取

@property (weak, nonatomic) IBOutlet YKTimeLineView *minTimeView;

@property (nonatomic, assign)BOOL isExp;  //判断是否是指数

@end
