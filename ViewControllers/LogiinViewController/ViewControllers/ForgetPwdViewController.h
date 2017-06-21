//
//  ForgetPwdViewController.h
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/16.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger,LOGINTYPE){
    LOGINTYPEFOGET = 0, //忘记密码
    LOGINTYPEREGISTER,  //注册
    LOGINTYPESETPWD     //重置密码
};

@interface ForgetPwdViewController : BaseViewController
@property (nonatomic, assign) LOGINTYPE logType;
@end
