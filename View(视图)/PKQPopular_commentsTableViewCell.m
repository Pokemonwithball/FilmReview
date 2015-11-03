//
//  PKQPopular_commentsTableViewCell.m
//  FilmReview
//
//  Created by tarena on 15/10/26.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQPopular_commentsTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface PKQPopular_commentsTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end

@implementation PKQPopular_commentsTableViewCell

-(void)setPopular_comments:(PKQMoviesPopular_commentsModel *)popular_comments{
    _popular_comments = popular_comments;
    self.titleLabel.text = popular_comments.author.name;
    self.contentLabel.text = popular_comments.content;
    NSInteger rating = [popular_comments.rating[@"value"] integerValue];
    self.iconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"appraisal%ld",rating*2]];
    
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
