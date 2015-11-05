//
//  PKQNaviCinemaCell.h
//  FilmReview
//
//  Created by tarena on 15/11/3.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKQNaviCinemaModel.h"
@class PKQNaviCinemaCell;

@protocol PKQNaviCinemaCellDelegate <NSObject>

-(void)getMap:(PKQNaviCinemaCell*)cell WithNSString:(NSString*)str;

@end


@interface PKQNaviCinemaCell : UITableViewCell
@property (strong,nonatomic) PKQNaviCinemaEntriesModel *model;
@property (weak,nonatomic) id<PKQNaviCinemaCellDelegate> delegate;
@end
