//
//  PKQHeadViewController.m
//  FilmReview
//
//  Created by tarena on 15/10/23.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQHeadViewController.h"
#import "UIButton+WebCache.h"
#import "Masonry.h"
@interface PKQHeadViewController ()

@end

@implementation PKQHeadViewController
-(void)setMovie:(PKQMoviesModel *)movie{
    _movie = movie;
    
    //设置买电影票的显示隐藏
    self.buyMovie.hidden = !movie.has_ticket ;
    
    //设置圆角 以后直接设置圆角的图片
    self.wantSeeBtn.layer.cornerRadius = 5;
    self.didSeeBtn.layer.cornerRadius =5;
    self.ImageBtn.layer.cornerRadius = 10;
    
    [self.ImageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:movie.images[@"large"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"noImage"]];
    
    //电影评分
    NSNumber *number = movie.rating[@"average"];
    
    CGFloat average = [number floatValue];
    if (average == 0.0) {
        self.scoreNOLabel.hidden = NO;
        self.scoreImage.hidden = YES;
        self.scoreLabel.hidden = YES;
        self.scorePeople.hidden = YES;
    }else{
        
        self.scoreNOLabel.hidden = YES;
        self.scoreImage.hidden = NO;
        self.scoreLabel.hidden = NO;
        self.scorePeople.hidden = NO;
        
        self.scoreLabel.text = [NSString stringWithFormat:@"%.1f",average];
        
        //设置电影的评分图片
        if (average<1) {
            self.scoreImage.image = [UIImage imageNamed:@"appraisal0"];
        }else if (1<=average&& average<2){
            self.scoreImage.image = [UIImage imageNamed:@"appraisal2"];
        }else if (2<=average&& average<3.5){
            self.scoreImage.image = [UIImage imageNamed:@"appraisal3"];
        }else if (3.5<=average && average<4.5){
            self.scoreImage.image = [UIImage imageNamed:@"appraisal4"];
        }else if (4.5<=average && average<5.5){
            self.scoreImage.image = [UIImage imageNamed:@"appraisal5"];
        }else if (5.5<=average && average<6.5){
            self.scoreImage.image = [UIImage imageNamed:@"appraisal6"];
        }else if (6.5<=average && average<7.5){
            self.scoreImage.image = [UIImage imageNamed:@"appraisal7"];
        }else if (7.5<=average && average<8.5){
            self.scoreImage.image = [UIImage imageNamed:@"appraisal8"];
        }else if (8.5<=average && average<9.5){
            self.scoreImage.image = [UIImage imageNamed:@"appraisal9"];
        }else if (9.5<=average && average<10){
            self.scoreImage.image = [UIImage imageNamed:@"appraisal10"];
        }
        //评分人数
        self.scorePeople.text = [NSString stringWithFormat:@"%@人评分",movie.ratings_count];
    }
    self.movieTime.hidden = YES;
    //电影上映时间和票长
    if (movie.mainland_pubdate && movie.durations) {
         self.movieTime.text = [NSString stringWithFormat:@"%@ / %@",movie.mainland_pubdate,movie.durations[0]];
        self.movieTime.hidden = NO;
    }
    //电影属于国家
    self.countryLabel.text = movie.countries[0];
    //电影的类型
    NSString *str = @"";
    for (int i=0; i<movie.genres.count; i++) {
        if (i == movie.genres.count-1) {
            str = [NSString stringWithFormat:@"%@%@",str,movie.genres[i]];
        }else{
             str = [NSString stringWithFormat:@"%@%@/",str,movie.genres[i]];
        }
    }
    self.typeLabel.text = [NSString stringWithFormat:@"%@...",str];
    //设置简介
    self.dealLabel.text = movie.summary;
    
    NSDictionary *strAttrbutes = @{
                                   NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGRect newFrame = [movie.summary boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-20, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:strAttrbutes context:nil];
    self.titleH = newFrame.size.height;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.dealLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(95);
    }];
}





@end
