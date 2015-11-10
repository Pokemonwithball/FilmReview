//
//  PKQCinemaReusableView.m
//  FilmReview
//
//  Created by tarena on 15/11/9.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQCinemaReusableView.h"
@interface PKQCinemaReusableView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fractionNOLabel;


@end
@implementation PKQCinemaReusableView
-(void)setModel:(PKQCinemaMovieEntriesModel *)model{
    _model = model;
    self.titleLabel.text = model.subject.title;
    self.fractionNOLabel.hidden = YES;
    //电影评分
    NSString *str = model.subject.rating;
    CGFloat average = [str floatValue];
    if (average == 0.0) {
        self.iconLabel.hidden = YES;
        self.numberLabel.hidden = YES;
        self.peopleLabel.hidden = YES;
        self.fractionNOLabel.hidden = NO;
        
    }else{
        self.iconLabel.hidden = NO;
        self.numberLabel.hidden = NO;
        self.peopleLabel.hidden = NO;
        self.fractionNOLabel.hidden = YES;
        self.numberLabel.text = [NSString stringWithFormat:@"%.1f",average];
        
        //设置电影的评分图片
        if (average<1) {
            self.iconLabel.image = [UIImage imageNamed:@"appraisal0"];
        }else if (1<=average&& average<2){
            self.iconLabel.image = [UIImage imageNamed:@"appraisal2"];
        }else if (2<=average&& average<3.5){
            self.iconLabel.image = [UIImage imageNamed:@"appraisal3"];
        }else if (3.5<=average && average<4.5){
            self.iconLabel.image = [UIImage imageNamed:@"appraisal4"];
        }else if (4.5<=average && average<5.5){
            self.iconLabel.image = [UIImage imageNamed:@"appraisal5"];
        }else if (5.5<=average && average<6.5){
            self.iconLabel.image = [UIImage imageNamed:@"appraisal6"];
        }else if (6.5<=average && average<7.5){
            self.iconLabel.image = [UIImage imageNamed:@"appraisal7"];
        }else if (7.5<=average && average<8.5){
            self.iconLabel.image = [UIImage imageNamed:@"appraisal8"];
        }else if (8.5<=average && average<9.5){
            self.iconLabel.image = [UIImage imageNamed:@"appraisal9"];
        }else if (9.5<=average && average<10){
            self.iconLabel.image = [UIImage imageNamed:@"appraisal10"];
        }
        
    }
    self.peopleLabel.text = [NSString stringWithFormat:@"%ld人评分",model.subject.collection];

    
}


- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)goMovieDeatil:(id)sender {
    [self.delegate view:self goToMovieDetailWithMovieID:self.model.subject.ID];
}

@end
