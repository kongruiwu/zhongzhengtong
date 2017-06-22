//
//  SectionHeadView.h
//  NewRenWang
//
//  Created by JopYin on 2017/1/13.
//  Copyright © 2017年 尹争荣. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MoreBlock)();

@interface SectionHeadView : UIView

@property (copy,nonatomic)MoreBlock moreBlock;

@property (weak, nonatomic) IBOutlet UIView *line;

@property (weak, nonatomic) IBOutlet UILabel *title;

//初始化加载xib视图
+(instancetype)sectionHeadView;

@end
