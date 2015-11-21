//
//  SMFactory.m
//  JellyfishWeather
//
//  Created by tarena on 15/11/12.
//  Copyright © 2015年 yanmm. All rights reserved.
//

#import "SMFactory.h"


@implementation SMFactory

+ (NSString *)removeUnusedZero:(NSString *)num{
    NSString * s = nil;
    int offset = num.length - 1;
    while (offset)
    {
        s = [num substringWithRange:NSMakeRange(offset, 1)];
        if ([s isEqualToString:@"0"] || [s isEqualToString:@"."])
        {
            offset--;
        }
        else
        {
            break;
        }
    }
    NSString * outNumber = [num substringToIndex:offset+1];
    return outNumber;
}

@end

