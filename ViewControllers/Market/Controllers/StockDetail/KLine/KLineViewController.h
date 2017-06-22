//
//  KLineViewController.h
//  GuShang
//
//  Created by JopYin on 2016/12/1.
//  Copyright © 2016年 尹争荣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLineViewController : UIViewController

@property (nonatomic,copy)NSString *stockCode;

@property (nonatomic,copy)NSString *klineType;

- (void)updateKLine;

@end
