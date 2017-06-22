//
//  HeaderOptionalView.m
//  NewRenWang
//
//  Created by YJ on 17/1/17.
//  Copyright © 2017年 尹争荣. All rights reserved.
//

#import "HeaderOptionalView.h"
#import "HeaderOptionalViewItemView.h"
#import "ConfigHeader.h"
@interface HeaderOptionalView ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) CALayer *lineLayer;
@property (nonatomic, assign) NSInteger currentIndex;

@end
@implementation HeaderOptionalView

// 设置偏移量
- (void)setContentOffset:(CGPoint)contentOffset {
    _contentOffset = contentOffset;
    
    CGFloat offsetX = contentOffset.x;
    // 当前索引
    NSInteger index = offsetX / UI_WIDTH;
    
    HeaderOptionalViewItemView *leftItem = (HeaderOptionalViewItemView *)[self.scrollView viewWithTag:index + 1];
    // 下一个按钮 如果rightBtnLeftDelta > 0则下一个按钮开始渲染
    HeaderOptionalViewItemView *rightItem = (HeaderOptionalViewItemView *)[self.scrollView viewWithTag:index + 2];
    
    // right
    // 相对于当前屏幕的宽度
    CGFloat rightPageLeftDelta = offsetX - index * UI_WIDTH;
    CGFloat progress = rightPageLeftDelta / UI_WIDTH;
    
    if ([leftItem isKindOfClass:[HeaderOptionalViewItemView class]]) {
        leftItem.textColor = [UIColor redColor];
        leftItem.fillColor = [UIColor blackColor];
        leftItem.progress = progress;
    }
    if ([rightItem isKindOfClass:[HeaderOptionalViewItemView class]]) {
        rightItem.textColor = [UIColor blackColor];
        rightItem.fillColor = [UIColor redColor];
        rightItem.progress = progress;
    }
    
    for (HeaderOptionalViewItemView *itemView in self.scrollView.subviews) {
        if ([itemView isKindOfClass:[HeaderOptionalViewItemView class]]) {
            if (itemView.tag != index + 1 && itemView.tag != index + 2) {
                itemView.textColor = [UIColor blackColor];;
                itemView.fillColor = [UIColor yellowColor];
                itemView.progress = 0.0;
            }
        }
    }
    
    // 重置当前索引
    self.currentIndex = index;
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    
    // 标题
    if (titles.count) {
        for (int i = 0; i < titles.count; i++) {
            HeaderOptionalViewItemView *item = [[HeaderOptionalViewItemView alloc] init];
            [self.scrollView addSubview:item];
            item.text = titles[i];
            item.tag = i + 1;
            item.textAlignment = NSTextAlignmentCenter;
            item.userInteractionEnabled = YES;
            [item addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTapGest:)]];
        }
    }
    
    // 位置
    if (self.titles.count) {
        self.scrollView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 1);
        self.scrollView.contentSize = CGSizeMake(UI_WIDTH, self.scrollView.height - 1);
        CGFloat btnW = self.scrollView.contentSize.width / self.titles.count;
        for (int i = 0 ; i < self.titles.count; i++) {
            HeaderOptionalViewItemView *item = (HeaderOptionalViewItemView *)[self.scrollView viewWithTag:i + 1];
            item.frame = CGRectMake(btnW * i, 0, btnW, self.scrollView.height);
        }
    }
    // 分割线
    self.lineLayer.frame = CGRectMake(0, self.scrollView.height - 1, UI_WIDTH, 1);
}

// 点击item执行回调
- (void)itemTapGest:(UITapGestureRecognizer *)tapGest {
    HeaderOptionalViewItemView *item = (HeaderOptionalViewItemView *)tapGest.view;
    if (item) {
        
        if (self.homeHeaderOptionalViewItemClickHandle) {
            self.homeHeaderOptionalViewItemClickHandle(self, item.text, item.tag - 1);
        }
        self.currentIndex = item.tag - 1;
    }
}

- (UIScrollView *)scrollView {
    if(!_scrollView){
        UIScrollView *sc = [[UIScrollView alloc] init];
        sc.delegate = self;
        [self addSubview:sc];
        _scrollView = sc;
        sc.backgroundColor = [UIColor clearColor];
        sc.showsVerticalScrollIndicator = NO;
        sc.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (CALayer *)lineLayer {
    if (!_lineLayer) {
        CALayer *line = [CALayer layer];
        [self.scrollView.layer addSublayer:line];
        line.backgroundColor = [UIColor whiteColor].CGColor;
        _lineLayer = line;
    }
    return _lineLayer;
}
@end
