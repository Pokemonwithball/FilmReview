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
@property (weak, nonatomic) IBOutlet UIButton *goToButton;
//选中的那个buton
@property (strong,nonatomic)UIButton *selectBtn;
//创建一个放按钮的视图
@property (strong,nonatomic)UIView * btnView;


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

-(void)setDateArray:(NSArray *)dateArray{
    
    [self.btnView removeFromSuperview];
    
    
    _dateArray = dateArray;
    //把日期转换成其他 今天 明天 星期三。。。
    //配置今天，和明天2个
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *newStr = [fmt stringFromDate:[NSDate date]];
    NSDate *torDate = [NSDate date];
    torDate = [torDate dateByAddingTimeInterval:24 * 60 * 60];
    NSString *torStr = [fmt stringFromDate:torDate];
    
    NSMutableArray *array = [NSMutableArray new];
    for (NSString *str in dateArray) {
        if ([str isEqualToString:newStr]) {
            [array addObject:@"今天"];
        }else if ([str isEqualToString:torStr]) {
            [array addObject:@"明天"];
        }else{
            NSArray *arr = [str componentsSeparatedByString:@"-"];
            [array addObject:[self weekDayWithNSArry:arr]];
        }
    }
    
    //把button全部放在一个视图里面
    UIView *btnView = [UIView new];
    [self addSubview:btnView];
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.goToButton.mas_bottom).mas_equalTo(5);
        make.width.mas_equalTo(kWindowW);
    }];
    self.btnView = btnView;
    
    
    UIView *lastview = nil;
    CGFloat buttonW = kWindowW/dateArray.count;
    for (int i=0; i<dateArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [btnView addSubview:button];
        if (!lastview) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
                make.top.mas_equalTo(0);
                make.width.mas_equalTo(buttonW);
            }];
        }else{
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(lastview.mas_right).mas_equalTo(0);
                make.bottom.mas_equalTo(0);
                make.top.mas_equalTo(0);
                make.width.mas_equalTo(buttonW);
            }];
        }
        lastview = button;
        button.tag = i*100;
        [button setTintColor:[UIColor whiteColor]];
        [button setTitle:array[i] forState:UIControlStateNormal];
        if (i == 0) {
            [button setBackgroundImage:[UIImage imageNamed:@"background"] forState:UIControlStateNormal];
        }else{
            [button setBackgroundImage:[UIImage imageNamed:@"backgroundblock"] forState:UIControlStateNormal];
        }
//        [button setBackgroundImage:[UIImage imageNamed:@"background"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(selectorDate:) forControlEvents:UIControlEventTouchUpInside];
        self.selectBtn = button;
    }
    
}
//按钮被点击了
-(void)selectorDate:(UIButton*)btn{
    [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"backgroundblock"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"bangcolor"] forState:UIControlStateNormal];
    self.selectBtn = btn;
    [self.delegate view:self selectDate:btn.tag/100];
}



//判断是星期几
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

- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)goMovieDeatil:(id)sender {
    [self.delegate view:self goToMovieDetailWithMovieID:self.model.subject.ID];
}

@end
