//
//  JSError.h
//  jianshebao
//
//  Created by 吴孔锐 on 16/8/4.
//  Copyright © 2016年 lmh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSError : NSObject
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *message;
@end
