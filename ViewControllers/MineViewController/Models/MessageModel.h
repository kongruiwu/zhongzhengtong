//
//  MessageModel.h
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/20.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "BaseModel.h"

@interface MessageModel : BaseModel
@property (nonatomic, strong) NSString * ID;
@property (nonatomic, strong) NSString * MsgContent;
@property (nonatomic, strong) NSString * MsgType;
/**是否已读*/
@property (nonatomic, assign) BOOL IsAppRead;
@property (nonatomic, strong) NSString * SendDate;
/**电话*/
@property (nonatomic, strong) NSString * Mobile;
@property (nonatomic, strong) NSString * ReceiveID;
/**1:成功的计划2：发布计划 0:失败计划  3 3.0策略  4策略股池 5问答 6股池超过5% 7消息管理）*/
@property (nonatomic, strong) NSString * Flag;
@property (nonatomic, assign) BOOL isOpen;
@end
