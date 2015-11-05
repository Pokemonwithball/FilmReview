//
//  PKQNaviCinemaModel.m
//  FilmReview
//
//  Created by tarena on 15/11/3.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQNaviCinemaModel.h"
#import "MJExtension.h"
@implementation PKQNaviCinemaModel


- (NSDictionary *)objectClassInArray{
    return @{@"entries" : [PKQNaviCinemaEntriesModel class]};
}
@end
@implementation PKQNaviCinemaEntriesModel
-(NSDictionary*)replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

@end


@implementation PKQNaviCinemaEntriesImagesModel

@end


@implementation PKQNaviCinemaEntriesLocationModel

@end


@implementation PKQNaviCinemaEntriesLocationCoordinateModel

@end


