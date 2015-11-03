//
//  PKQMoviesModel.m
//  FilmReview
//
//  Created by tarena on 15/10/23.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQMoviesModel.h"
#import "MJExtension.h"
#import "NSObject+MJCoding.h"
//电影
@implementation PKQMoviesModel
-(NSDictionary *)objectClassInArray{
    return @{@"casts":[PKQMoviesCastsModel class],@"directors":[PKQMoviesDirectorsModel class],@"popular_comments":[PKQMoviesPopular_commentsModel class]};
}

@end
//短评
@implementation PKQMoviesCommentsModel

-(NSDictionary*)objectClassInArray{
    return @{@"comments":[PKQMoviesPopular_commentsModel class]};
}

@end



@implementation PKQMoviesPopular_commentsModel

-(NSDictionary *)objectClassInArray{
    return @{@"author":[PKQMoviesPopular_commentsAuthorModel class]};
}

@end

@implementation PKQMoviesPopular_commentsAuthorModel

-(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

@end


@implementation PKQMoviesCastsModel
-(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}
@end

@implementation PKQMoviesDirectorsModel
-(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}
@end


//影评
@implementation PKQMoviesReviewsModel
-(NSDictionary*)objectClassInArray{
    return @{@"reviews":[PKQMoviesReviewsReviewsModel class]};
}

@end

@implementation PKQMoviesReviewsReviewsModel
-(NSDictionary*)replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

-(NSDictionary*)objectClassInArray{
    return @{@"author":[PKQMoviesPopular_commentsAuthorModel class]};
}

@end








