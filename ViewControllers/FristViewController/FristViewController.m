//
//  FristViewController.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/21.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "FristViewController.h"
#import "ConfigHeader.h"
#import "RootViewController.h"
@interface FristViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * mainScroll;
@property (nonatomic, strong) NSArray * images;

@end

@implementation FristViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}

- (void)creatUI{
    self.view.backgroundColor = GroundColor;
    [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"Frist"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSArray * images = @[@"1-2",@"1-3",@"1-4",@"1-5"];
    self.images = images;
    self.mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT)];
    self.mainScroll.pagingEnabled = YES;
    self.mainScroll.contentSize = CGSizeMake(UI_WIDTH * images.count, UI_HEGIHT);
    self.mainScroll.showsVerticalScrollIndicator =NO;
    self.mainScroll.showsHorizontalScrollIndicator =NO;
    [self.view addSubview:self.mainScroll];
    for (int i = 0; i<images.count; i++) {
        UIImageView * imgView = [Factory creatImageViewWithImage:images[i]];
        imgView.frame = CGRectMake(UI_WIDTH * i, 0, UI_WIDTH, UI_HEGIHT);
        
        if (i == images.count - 1) {
            UIButton * buton = [Factory creatButtonWithNormalImage:@"" selectImage:@""];
            buton.frame = CGRectMake(0, Anno750(1000), UI_WIDTH, Anno750(336));
            [imgView addSubview:buton];
            imgView.userInteractionEnabled = YES;
            [buton addTarget:self action:@selector(pushToHome) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self.mainScroll addSubview:imgView];
    }
    self.mainScroll.delegate = self;
}
- (void)pushToHome{
    
    [[UIApplication sharedApplication].keyWindow setRootViewController:[RootViewController new]];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%f",scrollView.contentOffset.x);
    if (scrollView.contentOffset.x > UI_WIDTH * (self.images.count - 1) + 20) {
        [[UIApplication sharedApplication].keyWindow setRootViewController:[RootViewController new]];
    }
}


@end
