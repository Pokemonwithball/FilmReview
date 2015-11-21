//
//  PKQCinemaReusableView.h
//  FilmReview
//
//  Created by tarena on 15/11/9.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKQCinemaMovieModel.h"
@class PKQCinemaReusableView;
@protocol PKQCinemaReusableViewDelegate <NSObject>

-(void)view:(PKQCinemaReusableView*)view goToMovieDetailWithMovieID:(NSString*)dbId withName:(NSString*)name;

-(void)view:(PKQCinemaReusableView *)view selectDate:(NSInteger)indexPath;

@end

@interface PKQCinemaReusableView : UICollectionReusableView
/*当前选择的电影信息*/
@property (strong,nonatomic) PKQCinemaMovieEntriesModel *model;
/*时间的数组*/
@property (strong,nonatomic) NSArray* dateArray;

@property (assign,nonatomic)NSInteger select;

@property (strong,nonatomic)id<PKQCinemaReusableViewDelegate> delegate;
@end
