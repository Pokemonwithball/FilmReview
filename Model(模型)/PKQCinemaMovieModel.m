//
//  PKQCinemaMovieModel.m
//  FilmReview
//
//  Created by tarena on 15/11/5.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQCinemaMovieModel.h"

@implementation PKQCinemaMovieModel



- (NSDictionary *)objectClassInArray{
    return @{@"entries" : [PKQCinemaMovieEntriesModel class]};
}
MJCodingImplementation

@end




@implementation PKQCinemaMovieEntriesModel

-(NSDictionary*)replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
MJCodingImplementation
@end


@implementation PKQCinemaMovieEntriesSubjectModel
-(NSDictionary*)replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
MJCodingImplementation
@end


@implementation PKQCinemaMovieEntriesSubjectImagesModel
MJCodingImplementation
@end


@implementation PKQCinemaMovieEntriesHallModel
-(NSDictionary*)replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
MJCodingImplementation
@end


@implementation PKQCinemaMovieEntriesSiteModel
-(NSDictionary*)replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
MJCodingImplementation
@end


@implementation PKQCinemaMovieEntriesSiteImagesModel
MJCodingImplementation
@end


@implementation PKQCinemaMovieEntriesSiteImagesLocationModel
MJCodingImplementation
@end


@implementation PKQCinemaMovieEntriesSiteImagesLocationCoordinateModel
MJCodingImplementation
@end


