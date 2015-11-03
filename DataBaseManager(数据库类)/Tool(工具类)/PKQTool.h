//
//  PKQTool.h
//  FilmReview
//
//  Created by tarena on 15/10/20.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKQProvince.h"

@interface PKQTool : NSObject
/*返回省份列表*/
+(NSArray*)province;
/*输入省份返回的城市*/
+(NSArray*)cityWith:(PKQProvince*)province;
@end
