//
//  PKQMoviesModel.h
//  FilmReview
//
//  Created by tarena on 15/10/23.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PKQMoviesCastsModel;
@class PKQMoviesDirectorsModel;
@class PKQMoviesPopular_commentsAuthorModel;


@interface PKQMoviesModel : NSObject

@property (strong,nonatomic) NSString * dbId;
//评分人数
@property (strong,nonatomic) NSNumber* ratings_count;
/*包含评分的字典  average是评分的key  价钱是里面的stars */
@property (strong,nonatomic) NSDictionary* rating;
/*large*/
@property (strong,nonatomic) NSDictionary* images;
//名字
@property (strong,nonatomic) NSString* title;
//简介
@property (strong,nonatomic) NSString* summary;
//国家数组
@property (strong,nonatomic) NSArray* countries;
/*类型数组*/
@property (strong,nonatomic) NSArray* genres;
/*上映时间*/
@property (strong,nonatomic)NSString* mainland_pubdate;
/*片长*/
@property (strong,nonatomic)NSArray* durations;
/*演员*/
@property (strong,nonatomic) NSArray  *casts;
/*导演*/
@property (strong,nonatomic) NSArray *directors;
/*评论*/
@property (strong,nonatomic) NSArray *popular_comments;
/*上映日期*/
@property (strong,nonatomic) NSString *pubdate;
/*有没有票*/
@property (assign,nonatomic)BOOL has_ticket;


@end

//短评
@interface PKQMoviesCommentsModel : NSObject
@property (strong,nonatomic) NSArray *comments;
@end

//影评
@interface PKQMoviesReviewsModel : NSObject
@property (strong,nonatomic) NSArray *reviews;
@end

@interface PKQMoviesReviewsReviewsModel : NSObject
@property (strong,nonatomic) NSString* ID;
@property (strong,nonatomic) NSDictionary *rating;
@property (strong,nonatomic) NSNumber* useful_count;
@property (strong,nonatomic) NSNumber* useless_count;
@property (strong,nonatomic) NSString* title;
@property (strong,nonatomic) PKQMoviesPopular_commentsAuthorModel *author;
@property (strong,nonatomic) NSString* content;

@end


@interface PKQMoviesPopular_commentsModel : NSObject
@property (strong,nonatomic) NSDictionary *rating;
//点赞的人数
@property (strong,nonatomic) NSNumber *useful_count;
@property (strong,nonatomic) NSNumber *useless_count;
@property (strong,nonatomic)PKQMoviesPopular_commentsAuthorModel *author;
//评价内容
@property (strong,nonatomic) NSString *content;


@end

@interface PKQMoviesPopular_commentsAuthorModel : NSObject
@property (strong,nonatomic) NSNumber *ID;
//头像
@property (strong,nonatomic) NSString *avatar;
@property (strong,nonatomic) NSString *name;
@end


@interface PKQMoviesCastsModel : NSObject
/*
 "name":"保罗·路德",
 "name_en":"Paul Rudd",
 "id":"1002667",
 "avatars":{
 "small":"http://img4.douban.com/img/celebrity/small/49.jpg", 70 *100
 "large":"http://img4.douban.com/img/celebrity/large/49.jpg",
 "medium":"http://img4.douban.com/img/celebrity/medium/49.jpg"
 }
 */
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *name_en;
@property (strong,nonatomic) NSString *ID;
/*small*/
@property (strong,nonatomic) NSDictionary *avatars;
@end


@interface PKQMoviesDirectorsModel : NSObject
/*
 "name":"佩顿·里德",
 "name_en":"Peyton Reed",
 "id":"1009586",
 "avatars":{
 "small":"http://img3.douban.com/img/celebrity/small/38984.jpg",
 "large":"http://img3.douban.com/img/celebrity/large/38984.jpg",
 "medium":"http://img3.douban.com/img/celebrity/medium/38984.jpg"
 }
 */
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *name_en;
@property (strong,nonatomic) NSString *ID;
@property (strong,nonatomic) NSDictionary *avatars;

@end
