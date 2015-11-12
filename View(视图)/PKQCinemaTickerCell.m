//
//  PKQCinemaTickerCell.m
//  FilmReview
//
//  Created by tarena on 15/11/9.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQCinemaTickerCell.h"
@interface PKQCinemaTickerCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *speakLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyTicketBtn;


@end
@implementation PKQCinemaTickerCell


-(void)setModel:(PKQCinemaMovieEntriesModel *)model{
    _model = model;
    self.buyTicketBtn.selected = NO;
    self.backgroundColor = PKQLoveColor;
    //判断是不是在购买时间里
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,要注意跟下面的dateString匹配，否则日起将无效
    NSDate *ticket = [dateFormat dateFromString:model.time];
    NSTimeInterval endTime = [ticket timeIntervalSinceReferenceDate];
    NSTimeInterval nowTime=[NSDate timeIntervalSinceReferenceDate];
    if (endTime - nowTime < 10*60) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.buyTicketBtn.selected = YES;
    }
    //能不能预定
    if (!model.bookable) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.buyTicketBtn.selected = YES;
    }
    
    
    NSInteger count = model.date.length;
    NSString *time = [model.time substringFromIndex:count+1];
    time = [time substringToIndex:5];
    
    self.timeLabel.text = time;
    self.speakLabel.text = [NSString stringWithFormat:@"%@%@",model.version,model.language];
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
    //    self.layer.contentsRect = 3;
    self.layer.cornerRadius = 3;}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    self.layer.cornerRadius =3;
    return self;
}
- (IBAction)goToBuyTicket:(UIButton*)sender {
    if (sender.selected) {
        
    }else{
        [self.delegate cell:self buyTicketWithModel:self.model];
    }
}


- (void)awakeFromNib {
    // Initialization code
}

@end
