//
//  PKQSqlit.h
//  FilmReview
//
//  Created by tarena on 15/11/5.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKQCinemaMovieModel.h"
@interface PKQSqlit : NSObject
/**
 *获取该电影院的全部电影票信息
 *
 */
//+(NSArray*)movieTicketDeals;
/**
 *根据图片的url获取电影票信息
 *
 */
+(NSArray*)movieTicketDealsWith:(NSString*)url;

/**
 *移除电影院表中全部的电影票信息
 *
 */
+(void)removeAllMoviesTicketDeals;

/**
 *增加一个电影票信息
 *
 */
+(void)addmovieTicketDeals:(PKQCinemaMovieEntriesModel*)ticket;

@end
