//
//  PKQImageCollectionViewController.h
//  FilmReview
//
//  Created by tarena on 15/10/27.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKQMoviesModel.h"
@interface PKQImageCollectionViewController : UICollectionViewController
@property (strong,nonatomic) PKQMoviesModel *movie;
@end
