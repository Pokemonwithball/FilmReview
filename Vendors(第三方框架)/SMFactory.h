//
//  SMFactory.h
//  JellyfishWeather
//
//  Created by tarena on 15/11/12.
//  Copyright © 2015年 yanmm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMFactory : NSObject

/** 去掉字符串后面无效的0 */
+ (NSString *)removeUnusedZero:(NSString *)num;

@end
