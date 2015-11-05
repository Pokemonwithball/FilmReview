//
//  PKQNaviCinemaCell.m
//  FilmReview
//
//  Created by tarena on 15/11/3.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQNaviCinemaCell.h"
@interface PKQNaviCinemaCell ()
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *haveImage;

@end

@implementation PKQNaviCinemaCell
-(void)setModel:(PKQNaviCinemaEntriesModel *)model{
    _model = model;
    [self.mapButton addTarget:self action:@selector(goToMap) forControlEvents:UIControlEventTouchUpInside];
    self.titleLabel.text = model.title;
    if (model.bookable) {
        self.haveImage.hidden = NO;
    }else{
        self.haveImage.hidden = YES;
    }
    
}


-(void)goToMap{
    
    [self.delegate getMap:self WithNSString:self.model.location.map_url];
}





- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
