//
//  YDConfigurationHelper.h
//  MyPersonalLibrary
//  This file is part of source code lessons that are related to the book
//  Title: Professional IOS Programming
//  Publisher: John Wiley & Sons Inc
//  ISBN 978-1-118-66113-0
//  Author: Peter van de Put
//  Company: YourDeveloper Mobile Solutions
//  Contact the author: www.yourdeveloper.net | info@yourdeveloper.net
//  Copyright (c) 2013 with the author and publisher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDConfigurationHelper : NSObject

+(void)setApplicationStartupDefaults;

+(BOOL)getBoolValueForConfigurationKey:(NSString *)_objectkey;

+(void)setBoolValueForConfigurationKey:(NSString *)_objectkey withValue:(BOOL)_boolvalue;


+(NSString *)getStringValueForConfigurationKey:(NSString *)_objectkey;

+(void)setStringValueForConfigurationKey:(NSString *)_objectkey withValue:(NSString *)_value;

+(NSInteger)getIntergerValueForConfigurationKey:(NSString *)_objectkey;

+(void)setIntergerValueForConfigurationKey:(NSString*)_objectkey withValue:(NSInteger)_value;

+ (void)removeUserDataForkey:(NSString *)_objectkey;

@end
