//
//  PKQReleas.h
//  FilmReview
//
//  Created by tarena on 15/10/20.
//  Copyright (c) 2015年 tarena. All rights reserved.
// https://api.douban.com/v2/movie/in_theaters?city=%E6%9D%AD%E5%B7%9E

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface PKQReleas : NSObject
/*包含评分的字典  average是评分的key*/

@property (strong,nonatomic) NSDictionary* rating;
/*标题*/
@property (strong,nonatomic) NSString* title;
/*图片  medium是我们需要的图片 */
@property (strong,nonatomic) NSDictionary* images;
/*ID*/
@property (strong,nonatomic) NSString* dbId;

@end

@interface PKQRating : NSObject

@property(assign,nonatomic) CGFloat average;
@property(assign,nonatomic) CGFloat max;
@property(assign,nonatomic) CGFloat min;
@property(strong,nonatomic) NSString* stars;

@end
/*
 "rating":{
 "max":10,
 "average":8,
 "stars":"40",
 "min":0
 },
 "genres":[
 "动作",
 "科幻",
 "冒险"
 ],
 "collect_count":41670,
 "casts":Array[3],
 "title":"蚁人",
 "original_title":"Ant-Man",
 "subtype":"movie",
 "directors":Array[1],
 "year":"2015",
 "images":{
 "small":"https://img3.doubanio.com/view/movie_poster_cover/ipst/public/p2266823371.jpg",
 "large":"https://img3.doubanio.com/view/movie_poster_cover/lpst/public/p2266823371.jpg",
 "medium":"https://img3.doubanio.com/view/movie_poster_cover/spst/public/p2266823371.jpg"
 },
 "alt":"http://movie.douban.com/subject/1866473/",
 "id":"1866473"
 
 - (void)viewDidLoad {
 [super viewDidLoad];
 NSString *strUrl = @"https://api.douban.com/v2/movie/in_theaters";
 [self request: strUrl withHttpArg: nil];
 }
 -(void)request: (NSString*)strUrl withHttpArg: (NSString*)HttpArg{
 NSString *urlstr = [[NSString alloc]initWithFormat:@"%@?city=杭州",strUrl];
 urlstr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 NSURL *url = [NSURL URLWithString:urlstr];
 NSLog(@"%@",url);
 NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
 [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
 NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
 NSLog(@"%@",dic);
 }];
 }

 */


