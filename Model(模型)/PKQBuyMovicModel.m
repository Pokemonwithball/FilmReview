//
//  PKQBuyMovicModel.m
//  FilmReview
//
//  Created by tarena on 15/11/14.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQBuyMovicModel.h"

@implementation PKQBuyMovicModel


- (NSDictionary *)objectClassInArray{
    return @{@"entries" : [PKQBuyMovieEntriesModel class]};
}
@end
@implementation PKQBuyMovieEntriesModel

@end


@implementation PKQBuyMovieEntriesSiteModel

-(NSDictionary*)replacedKeyFromPropertyName{
    return @{@"ID" :@"id"};
}

@end


@implementation PKQBuyMovieEntriesImagesModel

@end


@implementation PKQBuyMovieEntriesLocationModel

@end


@implementation PKQBuyMovieEntriesLocationCoordinateModel

@end


