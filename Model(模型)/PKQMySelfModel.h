//
//  PKQMySelfModel.h
//  FilmReview
//
//  Created by tarena on 15/11/17.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKQMySelfModel : NSObject
//头像
@property (copy,nonatomic) NSData* myImage;
//名字
@property (copy,nonatomic) NSString* myName;
//签名
@property (copy,nonatomic) NSString* signature;
//是否登录了
@property (assign,nonatomic)BOOL logeIn;
//账号
@property (copy,nonatomic)NSString* account;
//密码
@property (copy,nonatomic)NSString* password;
@end
