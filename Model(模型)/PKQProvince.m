//
//  PKQProvince.m
//  FilmReview
//
//  Created by tarena on 15/10/20.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "PKQProvince.h"
#import "MJExtension.h"
@implementation PKQProvince
//把desc在字典里的表示改成description 然后就快要成功的转了
-(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"state" : @"State",@"cities" : @"Cities"};
}
@end
