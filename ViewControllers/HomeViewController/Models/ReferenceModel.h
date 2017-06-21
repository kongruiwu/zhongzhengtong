//
//  ReferenceModel.h
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/20.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "BaseModel.h"

@interface ReferenceModel : BaseModel

@property (nonatomic, strong) NSString * iTotalCount;
@property (nonatomic, strong) NSString * iCount;
@property (nonatomic, strong) NSString * ID;
@property (nonatomic, strong) NSString * Title;
@property (nonatomic, strong) NSString * LinkUrl;
@property (nonatomic, strong) NSString * Pic;
@property (nonatomic, strong) NSString * CreateDate;
@property (nonatomic, assign) BOOL IsDel;
@property (nonatomic, assign) BOOL IsRecommend;
@property (nonatomic, strong) NSString * Content;
@property (nonatomic, assign) BOOL IsUrl;
@end
