//
//  ChangePwdCell.h
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/16.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"


@protocol ChangePwdCellDelegate <NSObject>

- (void)userGetCode;

@end


@interface ChangePwdCell : UITableViewCell

@property (nonatomic, strong) UITextField * inputTextf;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, assign) id<ChangePwdCellDelegate> delegate;
@property (nonatomic, strong) UIButton * getcode;



@end
