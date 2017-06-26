//
//  NullQuestionView.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/23.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "NullQuestionView.h"

@implementation NullQuestionView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    self.backgroundColor = [UIColor whiteColor];
    self.messageLabel = [Factory creatLabelWithText:[NSString stringWithFormat:@"您尚未提过任何问题\n点我立即提问！"]
                                          fontValue:font750(30)
                                          textColor:KTColor_lightGray
                                      textAlignment:NSTextAlignmentCenter];
    self.messageLabel.numberOfLines = 0;
    [self addSubview:self.messageLabel];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.width.equalTo(@(Anno750(750)));
        make.centerY.equalTo(@(-Anno750(100)));
    }];
}
@end
