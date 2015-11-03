//
//  PKQImageViewLayout.m
//  FilmReview
//
//  Created by tarena on 15/10/27.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQImageViewLayout.h"

@implementation PKQImageViewLayout
//创建布局对象时，设置与布局有关的参数信息
- (id)init{
    self = [super init];
    if (self) {
        //配置参数
        //由于继承自flowLayout,所以才有以下属性，
        //如果继承自UICollectionViewLayout，则没有如下属性
        self.itemSize = CGSizeMake(80, 80);
        self.minimumInteritemSpacing = 10;
        self.minimumLineSpacing = 10;
        //分区间的内边距
        self.sectionInset = UIEdgeInsetsMake(110, 30, 110, 30);
        // 滚动方向
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return self;
}
@end
