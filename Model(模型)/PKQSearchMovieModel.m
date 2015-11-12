//
//  PKQSearchMovieModel.m
//  FilmReview
//
//  Created by tarena on 15/11/2.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQSearchMovieModel.h"
#import "MJExtension.h"
@implementation PKQSearchMovieModel


- (NSDictionary *)objectClassInArray{
    return @{@"subjects" : [PKQSearchMovieSubjectModel class]};
}

@end
@implementation PKQSearchMovieSubjectModel

-(NSDictionary*)replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

- (NSDictionary *)objectClassInArray{
    return @{@"casts" : [PKQSearchMovieSubjectCastsModel class], @"directors" : [PKQSearchMovieSubjectDirectorsModel class]};
}


@end


@implementation PKQSearchMovieSubjectImagesModel

@end


@implementation PKQSearchMovieSubjectRatingModel

@end



@implementation PKQSearchMovieSubjectCastsModel
-(NSDictionary*)replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
@end


@implementation PKQSearchMovieSubjectCastsAvatarsModel

@end


@implementation PKQSearchMovieSubjectDirectorsModel
-(NSDictionary*)replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
@end


@implementation PKQSearchMovieSubjectDirectorsAvatarsModel

@end


