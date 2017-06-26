//
//  WkWebViewController.h
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/16.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>
@interface WkWebViewController : BaseViewController
@property (nonatomic, strong) WKWebView * webView;
- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content time:(NSString *)time navTitle:(NSString *)navTitle;
- (instancetype)initWithTitle:(NSString *)title url:(NSURL *)url;
@end
