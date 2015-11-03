//
//  PKQUpMovieModel.h
//  FilmReview
//
//  Created by tarena on 15/10/30.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKQUpMovieModel : NSObject
@property (strong,nonatomic) NSArray* entries;
@end


@interface PKQUpMovieEntriesModel : NSObject
@property (strong,nonatomic) NSDictionary* images;
@property (strong,nonatomic) NSString* title;
@property (strong,nonatomic) NSString* ID;
@property (strong,nonatomic) NSString* pubdate;
@end
