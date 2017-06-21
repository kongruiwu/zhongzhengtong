//
//  NothingView.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/21.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "NothingView.h"

@implementation NothingView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    self.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.00];
    self.iconImg = [Factory creatImageViewWithImage:@"banner"];
    self.messageLabel = [Factory creatLabelWithText:[NSString stringWithFormat:@"\n点我刷新"]
                                          fontValue:font750(30)
                                          textColor:KTColor_lightGray
                                      textAlignment:NSTextAlignmentCenter];
    self.messageLabel.numberOfLines = 0;
    
    [self addSubview:self.iconImg];
    [self addSubview:self.messageLabel];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@(Anno750(-200)));
        make.width.equalTo(@(Anno750(750)));
        make.height.equalTo(@(Anno750(364)));
    }];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.width.equalTo(@(Anno750(750)));
        make.top.equalTo(self.iconImg.mas_bottom);
    }];
}
- (void)setMessage:(NSString *)message{
    _message = message;
    self.messageLabel.text = [NSString stringWithFormat:@"%@\n\n点我刷新试试",message];
}
@end
