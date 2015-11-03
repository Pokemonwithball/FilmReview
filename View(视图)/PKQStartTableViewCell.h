//
//  PKQStartTableViewCell.h
//  FilmReview
//
//  Created by tarena on 15/10/25.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKQMoviesModel.h"
@interface PKQStartTableViewCell : UITableViewCell
@property (strong,nonatomic) PKQMoviesDirectorsModel *director;
@property (strong,nonatomic) PKQMoviesCastsModel *cast;
@end
