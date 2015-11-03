//
//  PKQCity.h
//  FilmReview
//
//  Created by tarena on 15/10/20.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKQCity : NSObject
/*城市名*/
@property (strong,nonatomic) NSString* city;
/*经纬度*/
@property (strong,nonatomic) NSNumber* lat;
@property (strong,nonatomic) NSNumber* lon;
@end
