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
//弄个静态变量
static FMDatabase *_db;
//一开始就调用一次(测试是这个文件的头文件写到了详情里面，当打开详情的时候这个方法就被调用了)
+(void)initialize{
     NSString *strpath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *file = [strpath stringByAppendingPathComponent:@"pkq.sqlite"];
    NSLog(@"电影院数据库的位置  %@",file);
    //创建数据库
    _db = [FMDatabase databaseWithPath:file];
    //打开数据库 如果失败的话就结束。成功就继续
    if (![_db open]) {
        return;
    }
    //IF NOT EXISTS  是如果没有就创建等待意思  这个是更新表的意思
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_ticket_movie(id integer PRIMARY KEY, tMovie blob NOT NULL, movie_image text NOT NULL);"];
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_cinema(id integer PRIMARY KEY, tCinemaDeatil blob NOT NULL, cinemaID text NOT NULL);"];
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_user(id integer primary KEY,tUser blob not null,account text not null,password text not null,isLogIn INTEGER not null)"];
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


//删除电影院电影票所有数据
+(void)removeAllMoviesTicketDeals{
    [_db executeUpdate:@"DELETE FROM t_ticket_movie"];
}




//收藏的全部的电影院的名字
+(NSArray*)allCinema{
    NSMutableArray *arr = [NSMutableArray new];
    //查，返回数控的数据  pos 是从第几个数据开始返回，size是返回多少数据  ORDER BY id DESC 是根据 id 的大小从大到小排列 。默认是从小到大
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_cinema ORDER BY id;"];
    //获取当前的数据库的数据
    while (set.next) {
        PKQCinemaDetailModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"tCinemaDeatil"]];
        [arr addObject:model];
    }
    return arr;
}

//根据ID移除收藏的电影院
+(void)removeCinemaDealsWithID:(NSString*)ID{
    [_db executeUpdateWithFormat:@"delete from t_cinema where cinemaID = %@",ID];
}
//增加一个电影院信息
+(void)addCinemaDealsWith:(PKQCinemaDetailModel*)cinema{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cinema];
    [_db executeUpdateWithFormat:@"INSERT INTO t_cinema(tCinemaDeatil,cinemaID) VALUES(%@,%@);",data,cinema.ID];
}
//根据ID判断有没有这个
+(BOOL)isCinemaDealsWithID:(NSString*)ID{
    //这个返回的一定是有数据的
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS cinema FROM t_cinema WHERE cinemaID = %@;",ID];
    [set next];
    //按照数据的名字来获取这个数据
    return [set intForColumn: @"cinema"] == 1;
}











/**
 *根据密码账号来获取一个对象
 *
 */
+(PKQMySelfModel*)getUserWithAccount:(NSString*)account password:(NSString*)pad{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_user where account = %@ and password = %@;",account,pad];
    [set next];
    PKQMySelfModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"tUser"]];
    return model;
}

/**
 *添加一个用户对象
 *
 */
+(void)addUserWithAccount:(PKQMySelfModel*)user{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
    
    [_db executeUpdateWithFormat:@"INSERT INTO t_user(tUser,account,password,isLogIn) VALUES(%@,%@,%@,%d);",data,user.account,user.password,(user.logeIn? 1:0)];
}
/**
 *根据是否登录了来获取用户信息
 *
 */
+(PKQMySelfModel*)getLogIn{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS isLogIn FROM t_user WHERE isLogIn = 1;"];
    [set next];
    //按照数据的名字来获取这个数据
    if ([set intForColumn: @"isLogIn"] == 1) {
        FMResultSet *set = [_db executeQueryWithFormat:@"select * from t_user where isLogIn = 1"];
        [set next];
        PKQMySelfModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"tUser"]];
        return model;
    }else{
        return [PKQMySelfModel new];
    }
}
/**
 *根据账号表格中登录的信息
 *
 */
+(void)getUser:(PKQMySelfModel*)user{
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
    [_db executeUpdateWithFormat:@"update t_user set isLogIn = %d ,tUser = %@ ,password = %@ where (account = %@);",(user.logeIn?1:0),data,user.password,user.account];
}

//删除用户所有数据
+(void)removeAllUserDeals{
    [_db executeUpdate:@"DELETE FROM t_user"];
}






@end
