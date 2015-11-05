//
//  PKQCinemaDetailViewController.h
//  FilmReview
//
//  Created by tarena on 15/11/4.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKQNaviCinemaModel.h"
@interface PKQCinemaDetailViewController : UIViewController
@property (strong,nonatomic)PKQNaviCinemaEntriesModel *model;
@property (strong,nonatomic)NSString *str;
@end
