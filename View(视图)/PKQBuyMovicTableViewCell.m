//
//  PKQBuyMovicTableViewCell.m
//  FilmReview
//
//  Created by tarena on 15/11/14.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQBuyMovicTableViewCell.h"
@interface PKQBuyMovicTableViewCell ()
@property (strong,nonatomic) UILabel *titleLabel;
@property (strong,nonatomic) UILabel *subLabel;
@property (strong,nonatomic) UIButton *mapButton;
@property (strong,nonatomic) UIImageView *haveTicket;

@end


@implementation PKQBuyMovicTableViewCell

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    return _titleLabel;
}

-(UILabel *)subLabel{
    if (!_subLabel) {
        _subLabel = [UILabel new];
        _subLabel.textColor = [UIColor lightGrayColor];
        _subLabel.font = [UIFont systemFontOfSize:13];
    }
    return _subLabel;
}

-(UIButton *)mapButton{
    if (!_mapButton) {
        _mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mapButton setImage:[UIImage imageNamed:@"map"] forState:UIControlStateNormal];
        [_mapButton addTarget:self action:@selector(goToCinema:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mapButton;
}

-(UIImageView *)haveTicket{
    if (!_haveTicket) {
        _haveTicket = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_detail_showtimes_selected@2x-1"]];
    }
    return _haveTicket;
}

-(void)setModel:(PKQBuyMovieEntriesModel *)model{
    _model = model;
    self.titleLabel.text = model.site.abbreviated_title;
    NSString *subText = nil;
    if (model.left_show_count == 0) {
        subText = [NSString stringWithFormat:@"%@元起 今日已映完",model.min_price];
    }else{
        subText = [NSString stringWithFormat:@"%@元起 余%ld场",model.min_price,model.left_show_count];
    }
    self.subLabel.text = subText;
}



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    //如果需要增加其他的uiView，就再这里添加
        
        
        
    }
    return  self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    //所有的子控件都再这里设置Frmae
    [self addSubview:self.mapButton];
    [self.mapButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(8);
    }];
    
    [self addSubview:self.haveTicket];
    [self.haveTicket mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(35);
        make.right.mas_equalTo(-8);
    }];
    
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mapButton.mas_right).mas_equalTo(8);
        make.right.mas_equalTo(self.haveTicket.mas_left).mas_equalTo(-8);
        make.top.mas_equalTo(10);
    }];
    
    
    [self addSubview:self.subLabel];
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mapButton.mas_right).mas_equalTo(8);
        make.right.mas_equalTo(self.haveTicket.mas_left).mas_equalTo(-8);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_equalTo(5);
    }];
    
}

-(void)goToCinema:(NSString*)map{
    NSLog(@"皮卡丘");
}



- (void)awakeFromNib {
    // Initialization code
}



@end
