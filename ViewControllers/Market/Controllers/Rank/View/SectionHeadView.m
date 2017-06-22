//
//  SectionHeadView.m
//  NewRenWang
//
//  Created by JopYin on 2017/1/13.
//  Copyright © 2017年 尹争荣. All rights reserved.
//

#import "SectionHeadView.h"

@implementation SectionHeadView

- (IBAction)moreBtn:(id)sender {
    if (self.moreBlock) {
        self.moreBlock();
    }
}

+(instancetype)sectionHeadView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

@end
