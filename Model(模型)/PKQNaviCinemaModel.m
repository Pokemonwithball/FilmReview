//
//  PKQNaviCinemaModel.m
//  FilmReview
//
//  Created by tarena on 15/11/3.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQNaviCinemaModel.h"
#import "MJExtension.h"


@implementation PKQSimpleCinemaModel



@end



@implementation PKQNaviCinemaModel


- (NSDictionary *)objectClassInArray{
    return @{@"entries" : [PKQNaviCinemaEntriesModel class]};
}
MJCodingImplementation
@end
@implementation PKQNaviCinemaEntriesModel
-(NSDictionary*)replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
MJCodingImplementation
@end


@implementation PKQNaviCinemaEntriesImagesModel
MJCodingImplementation
@end


@implementation PKQNaviCinemaEntriesLocationModel
MJCodingImplementation
@end


@implementation PKQNaviCinemaEntriesLocationCoordinateModel
MJCodingImplementation
@end


