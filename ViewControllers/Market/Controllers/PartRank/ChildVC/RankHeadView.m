//
//  RankHeadView.m
//  NewRenWang
//
//  Created by JopYin on 2017/1/18.
//  Copyright © 2017年 尹争荣. All rights reserved.
//

#import "RankHeadView.h"

@implementation RankHeadView

- (IBAction)rankRate:(id)sender {
    self.rateBtn.selected = !self.rateBtn.selected;
    BOOL isFall = self.rateBtn.selected;
    if ([self.delegate respondsToSelector:@selector(rankHeadView:changeRate:)]) {
        [self.delegate rankHeadView:self changeRate:isFall];
    }
}

+(instancetype)headView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

@end
