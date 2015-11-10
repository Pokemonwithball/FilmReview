//
//  PKQImageCollectionViewCell.m
//  FilmReview
//
//  Created by tarena on 15/10/25.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQImageCollectionViewCell.h"
@interface PKQImageCollectionViewCell()


@end

@implementation PKQImageCollectionViewCell

-(void)setIconView:(UIImageView *)iconView{
    _iconView = iconView;
    iconView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)awakeFromNib {
    // Initialization code
}

@end
