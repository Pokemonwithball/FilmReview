//
//  PKQCinemaTickerCell.m
//  FilmReview
//
//  Created by tarena on 15/11/9.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQCinemaTickerCell.h"
@interface PKQCinemaTickerCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *speakLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;


@end
@implementation PKQCinemaTickerCell


-(void)setModel:(PKQCinemaMovieEntriesModel *)model{
    _model = model;
    self.timeLabel.text = model.date;
    self.speakLabel.text = [NSString stringWithFormat:@"%@%@",model.version,model.language];
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
//    self.layer.contentsRect = 3;
    self.layer.cornerRadius = 3;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    self.layer.cornerRadius =3;
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

@end
