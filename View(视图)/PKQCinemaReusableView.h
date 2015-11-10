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

-(void)view:(PKQCinemaReusableView*)view goToMovieDetailWithMovieID:(NSString*)dbId;
@end

@interface PKQCinemaReusableView : UICollectionReusableView
@property (strong,nonatomic) PKQCinemaMovieEntriesModel *model;
@property (strong,nonatomic)id<PKQCinemaReusableViewDelegate> delegate;
@end
