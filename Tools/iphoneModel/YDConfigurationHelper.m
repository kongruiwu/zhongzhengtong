//
//  YDConfigurationHelper.m
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

#import "YDConfigurationHelper.h"

@implementation YDConfigurationHelper
+(void)setApplicationStartupDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize]; 
    [defaults setBool:NO forKey:@"FirstLaunch"];
    [defaults synchronize];
}

/**********************************         get          **************************************/
+(BOOL)getBoolValueForConfigurationKey:(NSString *)_objectkey {
    //create an instance of NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize]; //let's make sure the object is synchronized
    return [defaults boolForKey:_objectkey];
}

+(NSString *)getStringValueForConfigurationKey:(NSString *)_objectkey {
    //create an instance of NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];                                 //let's make sure the object is synchronized
    if ([defaults stringForKey:_objectkey] == nil)
    {
        return @"";
    }
    else
    {
        return [defaults stringForKey:_objectkey];
    }
}
+(NSInteger)getIntergerValueForConfigurationKey:(NSString *)_objectkey
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    return [defaults integerForKey:_objectkey];
}

/**********************************         set           **************************************/
+(void)setBoolValueForConfigurationKey:(NSString *)_objectkey withValue:(BOOL)_boolvalue
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize]; //let's make sure the object is synchronized
    [defaults setBool:_boolvalue forKey:_objectkey];
    [defaults synchronize];//make sure you're synchronized again
}

+(void)setStringValueForConfigurationKey:(NSString *)_objectkey withValue:(NSString *)_value
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize]; //let's make sure the object is synchronized
    [defaults setObject:_value forKey:_objectkey];
    [defaults synchronize];//make sure you're synchronized again
}

+(void)setIntergerValueForConfigurationKey:(NSString*)_objectkey withValue:(NSInteger)_value
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    [defaults setInteger:_value forKey:_objectkey];
    [defaults synchronize];
}

/**********************************        remove         **************************************/
+ (void)removeUserDataForkey:(NSString *)_objectkey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:_objectkey];
    [defaults synchronize];
}

@end
