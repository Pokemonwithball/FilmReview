//
//  PKQUpMovieModel.m
//  FilmReview
//
//  Created by tarena on 15/10/30.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQUpMovieModel.h"
#import "MJExtension.h"
@implementation PKQUpMovieModel
-(NSDictionary*)objectClassInArray{
    return @{@"entries":[PKQUpMovieEntriesModel class]};
}


@end


@implementation PKQUpMovieEntriesModel
-(NSDictionary*)replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

@end