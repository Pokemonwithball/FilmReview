//
//  PKQHeadViewController.h
//  FilmReview
//
//  Created by tarena on 15/10/23.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKQMoviesModel.h"




@interface PKQHeadViewController : UIViewController
@property (strong,nonatomic)PKQMoviesModel *movie;

@property (weak, nonatomic) IBOutlet UIButton *wantSeeBtn;
@property (weak, nonatomic) IBOutlet UIButton *didSeeBtn;
@property (weak, nonatomic) IBOutlet UIButton *ImageBtn;
@property (weak, nonatomic) IBOutlet UIImageView *scoreImage;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *scorePeople;
@property (weak, nonatomic) IBOutlet UILabel *movieTime;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dealLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyMovie;
@property (weak, nonatomic) IBOutlet UILabel *scoreNOLabel;
//文本应该的高
@property (assign,nonatomic) CGFloat titleH;
@end
