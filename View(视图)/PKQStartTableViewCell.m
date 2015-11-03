//
//  PKQStartTableViewCell.m
//  FilmReview
//
//  Created by tarena on 15/10/25.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQStartTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface PKQStartTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *englishName;

@end

@implementation PKQStartTableViewCell
-(void)setDirector:(PKQMoviesDirectorsModel *)director{
    _director = director;
    [self.iconView sd_setImageWithURL:director.avatars[@"small"]];
    self.titleName.text = [NSString stringWithFormat:@"%@[导演]",director.name];
    self.englishName.text = director.name_en;
}
-(void)setCast:(PKQMoviesCastsModel *)cast{
    _cast = cast;
    [self.iconView sd_setImageWithURL:cast.avatars[@"small"] placeholderImage:[UIImage imageNamed:@"noImage"]];
    self.titleName.text = cast.name;
    self.englishName.text = cast.name_en;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
