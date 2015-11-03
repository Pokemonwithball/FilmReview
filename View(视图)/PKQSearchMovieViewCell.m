//
//  PKQSearchMovieViewCell.m
//  FilmReview
//
//  Created by tarena on 15/11/2.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQSearchMovieViewCell.h"
#import "UIImageView+WebCache.h"

@interface PKQSearchMovieViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;
@property (weak, nonatomic) IBOutlet UIImageView *averageImage;
@property (weak, nonatomic) IBOutlet UILabel *averageLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageNoLabel;



@end


@implementation PKQSearchMovieViewCell


-(void)setSubject:(PKQSearchMovieSubjectModel *)subject{
    _subject = subject;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:subject.images.medium] placeholderImage:[UIImage imageNamed:@"noImage"]];
    self.titleLabel.text = subject.title;
    self.subLabel.text = subject.original_title;
    
    if ([subject.rating.average isEqualToNumber:@(0)]) {
        self.averageImage.hidden = YES;
        self.averageLabel.hidden = YES;
        self.averageNoLabel.hidden = NO;
    }else{
        self.averageImage.hidden = NO;
        self.averageLabel.hidden = NO;
        self.averageNoLabel.hidden = YES;
        CGFloat average = [subject.rating.average floatValue];
        
        self.averageLabel.text = [NSString stringWithFormat:@"%.1f",average];
        
        //设置电影的评分图片
        if (average<1) {
            self.averageImage.image = [UIImage imageNamed:@"appraisal0"];
        }else if (1<=average&& average<2){
            self.averageImage.image = [UIImage imageNamed:@"appraisal2"];
        }else if (2<=average&& average<3.5){
            self.averageImage.image = [UIImage imageNamed:@"appraisal3"];
        }else if (3.5<=average && average<4.5){
            self.averageImage.image = [UIImage imageNamed:@"appraisal4"];
        }else if (4.5<=average && average<5.5){
            self.averageImage.image = [UIImage imageNamed:@"appraisal5"];
        }else if (5.5<=average && average<6.5){
            self.averageImage.image = [UIImage imageNamed:@"appraisal6"];
        }else if (6.5<=average && average<7.5){
            self.averageImage.image = [UIImage imageNamed:@"appraisal7"];
        }else if (7.5<=average && average<8.5){
            self.averageImage.image = [UIImage imageNamed:@"appraisal8"];
        }else if (8.5<=average && average<9.5){
            self.averageImage.image = [UIImage imageNamed:@"appraisal9"];
        }else if (9.5<=average && average<10){
            self.averageImage.image = [UIImage imageNamed:@"appraisal10"];
        }
        
        
    }
}

//- (void)awakeFromNib {
//    // Initialization code
//}



@end
