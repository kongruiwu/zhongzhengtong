//
//  BannerModel.h
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/19.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "BaseModel.h"

@interface BannerModel : BaseModel

@property (nonatomic, strong) NSString * Id;

@property (nonatomic, strong) NSString * Title;
//图片链接
@property (nonatomic, strong) NSString * Posterimg;
//创建时间
@property (nonatomic, strong) NSString * CreatTime;
//详情内容
@property (nonatomic, strong) NSString * Content;
@end
