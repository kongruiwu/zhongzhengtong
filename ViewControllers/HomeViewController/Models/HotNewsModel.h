//
//  HotNewsModel.h
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/20.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "BaseModel.h"

@interface HotNewsModel : BaseModel
@property (nonatomic, strong) NSString * ID;
/**资讯标题*/
@property (nonatomic, strong) NSString * NEWSTITLE;
/**资讯类型  A股*/
@property (nonatomic, strong) NSString * NEWSTYPE;
@property (nonatomic, strong) NSString * LISTIMG;
@property (nonatomic, strong) NSString * NEWSSOURCE;
@property (nonatomic, strong) NSString * CREATEDATE;
@property (nonatomic, strong) NSString * NEWSSUMMARY;
@property (nonatomic, strong) NSString * JUMPURL;
@property (nonatomic, strong) NSString * GUESTNUM;
//是否展开
@property (nonatomic, assign) BOOL isOpen;
@end
