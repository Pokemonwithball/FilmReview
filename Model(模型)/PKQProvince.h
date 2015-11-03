//
//  PKQProvince.h
//  FilmReview
//
//  Created by tarena on 15/10/20.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKQProvince : NSObject
/*省份的名字*/
@property (strong,nonatomic) NSString *state;
/*详细的城市区域*/
@property (strong,nonatomic) NSArray *cities;
@end
