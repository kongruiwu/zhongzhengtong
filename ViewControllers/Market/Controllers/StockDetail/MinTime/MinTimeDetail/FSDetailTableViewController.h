//
//  FSDetailTableViewController.h
//  YunZhangCaiJing
//
//  @Author: JopYin on 16/3/31.
//  Copyright © 2016年 JopYin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSDetailTableViewController : UITableViewController

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,copy)NSString *stockCode;

@property (nonatomic,copy)NSString *preClose;    //昨收价，这个数据不能通过请求分时接口获取只能通过实时行情接口获取


@end
