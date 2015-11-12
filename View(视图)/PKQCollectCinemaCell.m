//
//  PKQCollectCinemaCell.m
//  FilmReview
//
//  Created by tarena on 15/11/3.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQCollectCinemaCell.h"

@interface PKQCollectCinemaCell ()
@property (weak, nonatomic) IBOutlet UIImageView *collectImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation PKQCollectCinemaCell

-(void)setModel:(PKQNaviCinemaModel *)model{
    _model = model;
    if (model == nil) {
        self.collectImage.image = [UIImage imageNamed:@"icon_collect"];
        self.titleLabel.textColor = [UIColor lightGrayColor];
        self.titleLabel.text = @"点击添加我常去的影院";
    }else{
        self.collectImage.image = [UIImage imageNamed:@"icon_collect_highlighted@2x"];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.text = model.title;
    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
