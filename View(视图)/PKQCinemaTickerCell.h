//
//  PKQCinemaTickerCell.h
//  FilmReview
//
//  Created by tarena on 15/11/9.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKQNaviCinemaModel.h"
@class PKQCinemaTickerCell;
@protocol PKQCinemaTickerCellDelegate <NSObject>

-(void)cell:(PKQCinemaTickerCell*)cell buyTicketWithModel:(PKQCinemaMovieEntriesModel*)model;

@end



@interface PKQCinemaTickerCell : UICollectionViewCell

@property (strong,nonatomic) PKQCinemaMovieEntriesModel *model;
@property (weak,nonatomic) id<PKQCinemaTickerCellDelegate> delegate;
@end
