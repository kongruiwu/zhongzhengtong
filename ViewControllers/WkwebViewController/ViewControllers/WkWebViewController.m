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
@property (nonatomic, strong) NSURL * url;

@end

@implementation WkWebViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content{
    self = [super init];
    if (self) {
        self.titleName = title;
        self.contentStr = content;
        
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title url:(NSURL *)url{
    self = [super init];
    if (self) {
        self.titleName = title;
        self.url = url;
        
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
    if (self.contentStr && self.contentStr.length>0) {
        [self.webView loadHTMLString:self.contentStr baseURL:nil];
    }else if(self.url){
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    }
    
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
