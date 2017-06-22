//
//  StockNewsModel.h
//  NewRenWang
//
//  Created by JopYin on 2017/3/6.
//  Copyright © 2017年 尹争荣. All rights reserved.
//

#import "BaseModel.h"

@interface StockNewsModel : BaseModel

@property (nonatomic, assign) NSInteger newsId;
@property (nonatomic, assign) NSInteger categoryid;
@property (nonatomic, copy) NSString *newsTitle;
@property (nonatomic, copy) NSString *time;

@end
