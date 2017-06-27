//
//  QuestionModel.h
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/20.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "BaseModel.h"

@interface QuestionModel : BaseModel
/**问题*/
@property (nonatomic, strong) NSString * Question;
/**答案*/
@property (nonatomic, strong) NSString * Answer;
/**回复人id*/
@property (nonatomic, strong) NSString * StrategyId;
/**回复人姓名*/
@property (nonatomic, strong) NSString * StrategyTitle;
/**回复人图像*/
@property (nonatomic, strong) NSString * StrategyThumb;
/**用户头像*/
@property (nonatomic, strong) NSString * Pic;
@property (nonatomic, strong) NSString * QTime;
@property (nonatomic, strong) NSString * ATime;
@property (nonatomic, strong) NSString * NickName;
/**用户名称*/
@property (nonatomic, strong) NSString * UserName;
@property (nonatomic, assign) BOOL nameOpen;
@property (nonatomic, assign) BOOL isOpen;
@end
