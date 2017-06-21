//
//  WkWebViewController.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/16.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "WkWebViewController.h"

@interface WkWebViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) NSString * titleName;
@property (nonatomic, strong) NSString * contentStr;

@end

@implementation WkWebViewController

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content{
    self = [super init];
    if (self) {
        self.titleName = title;
        self.contentStr = content;
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:self.titleName];
    [self drawBackButton];
    [self creatUI];

}

- (void)creatUI{
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT - 64)];
    [self.webView loadHTMLString:self.contentStr baseURL:nil];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    //修改字体大小 300%
    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '250%'" completionHandler:nil];
    
    //修改字体颜色
    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#666666'" completionHandler:nil];
    
}
@end
