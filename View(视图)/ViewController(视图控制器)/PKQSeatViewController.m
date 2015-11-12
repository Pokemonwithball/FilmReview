//
//  PKQSeatViewController.m
//  FilmReview
//
//  Created by tarena on 15/11/10.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQSeatViewController.h"

@interface PKQSeatViewController ()

@end

@implementation PKQSeatViewController

-(void)setModel:(PKQCinemaMovieEntriesModel *)model{
    _model = model;
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    CGFloat viewW = kWindowW-20;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(viewW);
        make.top.mas_equalTo(64+5);
        make.height.mas_equalTo(50);
    }];
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds = NO;
    NSArray *array = [model.date componentsSeparatedByString:@"-"];
    
    NSString *timeStr = [[model.time substringFromIndex:11] substringToIndex:5];
    NSString *weekStr = [self weekDayWithNSArry:array];
    NSString *dayStr = [model.date substringFromIndex:5];
    NSArray *dayArray = [dayStr componentsSeparatedByString:@"-"];
    
    
    UILabel *timeLabel = [UILabel new];
    timeLabel.textColor = PKQLoveColorMore;
    timeLabel.text = [NSString stringWithFormat:@"%@月%@日%@ %@",dayArray[0],dayArray[1],weekStr,timeStr];
    [view addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(-5);
    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = PKQLoveColorMore;
    titleLabel.text = model.subject.title;
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(5);
        make.right.mas_equalTo(timeLabel.mas_left).mas_equalTo(-5);
    }];
    
    
    UILabel *detailLabel = [UILabel new];
    detailLabel.textColor = [UIColor lightGrayColor];
    detailLabel.font = [UIFont systemFontOfSize:12];
    detailLabel.text = [NSString stringWithFormat:@"%@ %@ %ld分钟 豆瓣售价%@元",model.version,model.language,model.duration,model.price];
    [view addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_equalTo(5);
        make.right.mas_equalTo(-5);
    }];
    
    
    
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





- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = PKQColor(247, 247, 247);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
