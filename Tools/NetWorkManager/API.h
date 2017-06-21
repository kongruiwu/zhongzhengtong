//
//  API.h
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/16.
//  Copyright © 2017年 wurui. All rights reserved.
//

#ifndef API_h
#define API_h

#define APPID           @"201609021530300235"
#define SIGNKEY         @"0987654321"
#define BaseImgUrl      @"http://back.zzt123.com.cn/"
#define BaseUrl         @"http://api.zzt123.com.cn/api/"
//获取token
#define Token           @"token"

//发送短信验证码
#define Page_SendSms    @"SendSmsCode/SendSms"
//用户注册
#define Page_Register   @"User/UserRegister"
//用户登陆
#define Page_login      @"User/UserLogin"
//获取用户信息
#define Page_UserInfo   @"User/UserLoginCheck"
//首页banner
#define Page_Banner     @"HomePage/PostersView"
//首页banner详情
#define Page_BannerInfo @"HomePage/PostersViewInfo"
//热点追踪
#define Page_HotNews    @"OtherPages/GetCounsel"
//核心内参
#define Page_SoleList   @"SoleInternal/SoleInternalList"
//专家诊股
#define Page_AllQuest   @"QuestionAnswer/SelectAllQuestionAnswer"
//我的问题
#define Page_MineQuest  @"QuestionAnswer/SelectMyQuestionAnswer"
//提问
#define Page_AskQuest   @"QuestionAnswer/AskQuestions"
//高手秘籍
#define Page_MasterList @"Information/SelectNewList"
//牛股来了
#define Page_Quotation  @"StrategyPool/GetStrategyPoolList"

//推送信息
#define Page_PushMes    @"Message/GetUserPopupMessagebyApp"


#endif /* API_h */
