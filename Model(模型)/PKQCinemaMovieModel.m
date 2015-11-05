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


@end




@implementation PKQCinemaMovieEntriesModel

-(NSDictionary*)replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

@end


@implementation PKQCinemaMovieEntriesSubjectModel
-(NSDictionary*)replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
@end


@implementation PKQCinemaMovieEntriesSubjectImagesModel

@end


@implementation PKQCinemaMovieEntriesHallModel
-(NSDictionary*)replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
@end


@implementation PKQCinemaMovieEntriesSiteModel
-(NSDictionary*)replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
@end


@implementation PKQCinemaMovieEntriesSiteImagesModel

@end


@implementation PKQCinemaMovieEntriesSiteImagesLocationModel

@end


@implementation PKQCinemaMovieEntriesSiteImagesLocationCoordinateModel

@end


