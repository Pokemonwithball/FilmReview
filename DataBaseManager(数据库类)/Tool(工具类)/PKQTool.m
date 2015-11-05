//
//  PKQTool.m
//  FilmReview
//
//  Created by tarena on 15/10/20.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "PKQTool.h"
#import "MJExtension.h"
#import "PKQProvince.h"
#import "PKQCity.h"
@implementation PKQTool
static NSArray *_province;
+(NSArray*)province{
    if (!_province) {
        _province = [PKQProvince objectArrayWithFilename:@"ProvincesAndCities.plist"];
    }
    return _province;
}
NSArray *_city;
+(NSArray*)cityWith:(PKQProvince*)province{
    _city = [PKQCity objectArrayWithKeyValuesArray:province.cities];
    return _city;
}



@end
