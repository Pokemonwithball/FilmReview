//
//  PKQSqlit.h
//  FilmReview
//
//  Created by tarena on 15/11/5.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKQCinemaMovieModel.h"
#import "PKQCinemaDetailModel.h"
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
+(void)addmovieTicketDeals:(PKQCinemaDetailModel*)ticket;


//收藏的全部的电影院名字
+(NSArray*)allCinema;

//根据ID移除收藏的电影院
+(void)removeCinemaDealsWithID:(NSString*)ID;
//增加一个电影院
+(void)addCinemaDealsWith:(PKQCinemaDetailModel*)cinema;
//根据ID判断有没有这个
+(BOOL)isCinemaDealsWithID:(NSString*)ID;

@end
