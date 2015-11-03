//
//  PKQReleas.m
//  FilmReview
//
//  Created by tarena on 15/10/20.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "PKQReleas.h"
#import "MJExtension.h"
@implementation PKQReleas
//把desc在字典里的表示改成description 然后就快要成功的转了
-(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"dbId" : @"id"};
}
//特殊规定 data对应的值 由特殊类解析
+ (NSDictionary *)objectClassInArray{
    return @{@"rating": [PKQRating class]};
}

@end

@implementation PKQRating



@end