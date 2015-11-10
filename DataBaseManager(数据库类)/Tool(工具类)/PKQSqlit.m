//
//  PKQSqlit.m
//  FilmReview
//
//  Created by tarena on 15/11/5.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQSqlit.h"
#import "FMDB.h"
@implementation PKQSqlit

static FMDatabase *_db;
+(void)initialize{
     NSString *strpath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *file = [strpath stringByAppendingPathComponent:@"pkq.sqlite"];
    NSLog(@"电影院数据库的位置%@",file);
    //创建数据库
    _db = [FMDatabase databaseWithPath:file];
    //打开数据库 如果失败的话就结束。成功就继续
    if (![_db open]) {
        return;
    }
    //IF NOT EXISTS  是如果没有就创建等待意思  这个是更新表的意思
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_ticket_movie(id integer PRIMARY KEY, tMovie blob NOT NULL, movie_image text NOT NULL);"];
}


+(NSArray*)movieTicketDealsWith:(NSString*)url{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_ticket_movie where movie_image = %@",url];
    NSMutableArray *movies = [NSMutableArray array];
    //获取当前的数据库的数据
    while (set.next) {
        //解码
        PKQCinemaMovieEntriesModel *deal = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"tMovie"]];
        [movies addObject:deal];
    }
    return movies;
}




//添加一个数据
+(void)addmovieTicketDeals:(PKQCinemaMovieEntriesModel*)ticket{
    //但是数据库只能放nsdata 的数据所以要把自定义的对象转过去,然后要在模型对象中实现归档   有框架在的话只需要MJCodingImplementation
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:ticket];
    [_db executeUpdateWithFormat:@"INSERT INTO t_ticket_movie(tMovie, movie_image) VALUES(%@,%@);",data, ticket.subject.images.medium];
}


//删除电影院所有数据
+(void)removeAllMoviesTicketDeals{
    [_db executeUpdate:@"DELETE FROM t_ticket_movie"];
}


@end
