//
//  UserModel.h
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/19.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "BaseModel.h"

@interface UserModel : BaseModel

@property (nonatomic, strong) NSString * ID;
@property (nonatomic, strong) NSString * UserName;
@property (nonatomic, strong) NSString * NickName;
@property (nonatomic, strong) NSString * TelPhone;
@property (nonatomic, strong) NSString * Email;
@property (nonatomic, strong) NSString * Pic;
@property (nonatomic, strong) NSString * Version;
//订单到期时间
@property (nonatomic, strong) NSString * OverdueDate;
@end
