//
//  PKQMovieViewCell.h
//  FilmReview
//
//  Created by tarena on 15/10/19.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKQReleas.h"
#import "PKQUpMovieModel.h"
@interface PKQMovieViewCell : UICollectionViewCell
@property (strong,nonatomic) PKQReleas* movie;
@property (strong,nonatomic) PKQUpMovieEntriesModel *upMovie;
@end
