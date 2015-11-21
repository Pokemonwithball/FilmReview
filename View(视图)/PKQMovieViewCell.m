//
//  PKQMovieViewCell.m
//  FilmReview
//
//  Created by tarena on 15/10/19.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "PKQMovieViewCell.h"
#import "UIButton+WebCache.h"
#import "MJExtension.h"
#import "PKQConst.h"
@interface PKQMovieViewCell ()
//点击进入详情界面
@property (weak, nonatomic) IBOutlet UIButton *movieButton;
//电影名字
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//电影评价图
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//电影评分
@property (weak, nonatomic) IBOutlet UILabel *fractionLabel;

@property (strong,nonatomic) NSString* dbId;
@property (strong,nonatomic) NSString* name;
//没有评分
@property (weak, nonatomic) IBOutlet UILabel *fractionNOLabel;
/*上映的日期*/
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@end
@implementation PKQMovieViewCell
//里面设置cell的各种信息
-(void)setMovie:(PKQReleas *)movie{
    self.dayLabel.hidden = YES;
    if (movie == nil) {
        self.hidden = YES;
    }else{
        _movie = movie;
        //电影的标题
        self.titleLabel.text = movie.title;
        //电影评分
        NSNumber *number = movie.rating[@"average"];
        CGFloat average = [number floatValue];
        if (average == 0.0) {
            self.imageView.hidden = YES;
            self.fractionLabel.hidden = YES;
            self.fractionNOLabel.hidden = NO;
            
        }else{
            self.imageView.hidden = NO;
            self.fractionLabel.hidden = NO;
            self.fractionNOLabel.hidden = YES;
            self.fractionLabel.text = [NSString stringWithFormat:@"%.1f",average];
            
            //设置电影的评分图片
            if (average<1) {
                self.imageView.image = [UIImage imageNamed:@"appraisal0"];
            }else if (1<=average&& average<2){
                self.imageView.image = [UIImage imageNamed:@"appraisal2"];
            }else if (2<=average&& average<3.5){
                self.imageView.image = [UIImage imageNamed:@"appraisal3"];
            }else if (3.5<=average && average<4.5){
                self.imageView.image = [UIImage imageNamed:@"appraisal4"];
            }else if (4.5<=average && average<5.5){
                self.imageView.image = [UIImage imageNamed:@"appraisal5"];
            }else if (5.5<=average && average<6.5){
                self.imageView.image = [UIImage imageNamed:@"appraisal6"];
            }else if (6.5<=average && average<7.5){
                self.imageView.image = [UIImage imageNamed:@"appraisal7"];
            }else if (7.5<=average && average<8.5){
                self.imageView.image = [UIImage imageNamed:@"appraisal8"];
            }else if (8.5<=average && average<9.5){
                self.imageView.image = [UIImage imageNamed:@"appraisal9"];
            }else if (9.5<=average && average<10){
                self.imageView.image = [UIImage imageNamed:@"appraisal10"];
            }

        }
         //[self.movieButton removeTarget:self action:@selector(upMovieGoDetail:) forControlEvents:UIControlEventTouchUpInside];
        [self.movieButton sd_setBackgroundImageWithURL:[NSURL URLWithString:movie.images[@"large"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"noImage"]];
        [self.movieButton addTarget:self action:@selector(goDetail:) forControlEvents:UIControlEventTouchUpInside];
        
        self.dbId = self.movie.dbId;
        self.name = self.movie.title;
    }
}
-(void)setUpMovie:(PKQUpMovieEntriesModel *)upMovie{
   
    _upMovie = upMovie;
    
    self.dayLabel.hidden = NO;
    NSArray *array = [upMovie.pubdate componentsSeparatedByString:@"-"];
    NSString * strDay = [upMovie.pubdate substringFromIndex:5];
    NSString *week = [self weekDayWithNSArry:array];
    self.dayLabel.text = [NSString stringWithFormat:@"%@ %@",strDay,week];
    
    [self.movieButton sd_setBackgroundImageWithURL:[NSURL URLWithString:upMovie.images[@"large"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"noImage"]];
    
    self.imageView.hidden = YES;
    self.fractionLabel.hidden = YES;
    self.fractionNOLabel.hidden = YES;
    //电影的标题
    self.titleLabel.text = upMovie.title;
    self.dbId = self.upMovie.ID;
    self.name = self.upMovie.title;
    
}



-(void)goDetail:(UIButton*)item{
    //发送点击了button的通知
    [PKQNotificationCenter postNotificationName:PKQMovieButtonUpInsideNotification object:nil userInfo:@{PKQSelectMovie : self.dbId,PKQSelectNameMovie : self.name}];
}

//这样设置就不会自动拉伸
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

-(NSString*)weekDayWithNSArry:(NSArray*)array{
    NSDateComponents *_comps = [[NSDateComponents alloc] init];
    [_comps setDay:[array[2] intValue]];
    [_comps setMonth:[array[1] intValue]];
    [_comps setYear:[array[0] intValue]];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *_date = [gregorian dateFromComponents:_comps];
    NSDateComponents *weekdayComponents =
    [gregorian components:NSWeekdayCalendarUnit fromDate:_date];
    NSInteger weekday = [weekdayComponents weekday];
    NSString *week = nil ;
    switch (weekday) {
        case 1:
            week = @"周日";
            break;
        case 2:
            week = @"周一";
            break;
        case 3:
            week = @"周二";
            break;
        case 4:
            week = @"周三";
            break;
        case 5:
            week = @"周四";
            break;
        case 6:
            week = @"周五";
            break;
        case 7:
            week = @"周六";
            break;
        default:
            break;
    }
    return week;
}












@end
