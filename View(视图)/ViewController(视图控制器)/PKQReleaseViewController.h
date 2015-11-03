//
//  PKQReleaseViewController.h
//  FilmReview
//
//  Created by tarena on 15/10/19.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PKQReleaseViewController : UICollectionViewController
//获取网络请求的到的上映的电影信息
@property (strong,nonatomic) NSArray *array;
//是否显示尾部视图
@property (assign,nonatomic) BOOL isFood;
@end
