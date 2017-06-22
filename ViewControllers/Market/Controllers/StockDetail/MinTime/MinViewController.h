//
//  MinViewController.h
//  GuShang
//
//  Created by JopYin on 2016/12/1.
//  Copyright © 2016年 尹争荣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSFiveViewController.h"
#import "FSDetailTableViewController.h"
#import "YKLineChart.h"

@interface MinViewController : UIViewController

@property (nonatomic,copy)NSString *stockCode;

@property (nonatomic,copy)NSString *preClose;    //昨收价，这个数据不能通过请求分时接口获取只能通过实时行情接口获取

@property (weak, nonatomic) IBOutlet UIView *minDetailView;  //（仅仅是上面的视图 不包括 五档 和 成交明细 的按钮 ）

@property (weak, nonatomic) IBOutlet YKTimeLineView *minTimeView;

@property (weak, nonatomic) IBOutlet UIView *MinDetail;   //右侧整个五档视图 包括下面的2个按钮

@property (nonatomic, strong)FSFiveViewController *fiveViewController;

@property (nonatomic, strong)FSDetailTableViewController *detailTBVC;

@property (nonatomic, assign)BOOL isExp;  //判断是否是指数

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightWidth;

@end
