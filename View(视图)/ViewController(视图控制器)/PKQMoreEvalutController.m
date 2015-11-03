//
//  PKQMoreEvalutController.m
//  FilmReview
//
//  Created by tarena on 15/10/28.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQMoreEvalutController.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+MJ.h"
@interface PKQMoreEvalutController ()
@property (strong,nonatomic) UIScrollView *scrollView;
@property (strong,nonatomic) UIButton *useGood;
@property (strong,nonatomic) UIButton *useBad;
@end

@implementation PKQMoreEvalutController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"影评";
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    self.scrollView = scrollView;
  NSString *str = self.review.content;
    NSDictionary *strAttrbutes = @{
                                   NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGRect newFrame = [str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-20, 99999) options:NSStringDrawingUsesLineFragmentOrigin attributes:strAttrbutes context:nil];
    self.scrollView.frame = [UIScreen mainScreen].bounds;
//    CGRect rectOfText = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-20, 9999);
//    rectOfText = [contentLabel textRectForBounds:rectOfText limitedToNumberOfLines:0];
    
    self.scrollView.contentSize = CGSizeMake(0,newFrame.size.height+200);
    [self.view addSubview:self.scrollView];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, newFrame.size.height+200);
    [self.scrollView addSubview:view];
    
    //设置标题
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = self.review.title;
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:25];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    //设置头像
    PKQMoviesPopular_commentsAuthorModel *author = self.review.author;
    UIImageView *imageView = [UIImageView new];
    [imageView sd_setImageWithURL:[NSURL URLWithString:author.avatar] placeholderImage:[UIImage imageNamed:@"noImage"]];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(10);
    }];
    
    //设置名字
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = author.name;
    nameLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(imageView);
        make.left.mas_equalTo(imageView.mas_right).mas_equalTo(5);
    }];
    //设置评价的星级
    NSInteger integer = [self.review.rating[@"value"] integerValue];
    UIImageView *valueImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"appraisal%ld",integer*2]]];
    [view addSubview:valueImage];
    [valueImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(imageView);
        make.left.mas_equalTo(nameLabel.mas_right).mas_equalTo(5);
    }];
    
    //设置评价的内容
    UILabel *contentLabel = [UILabel new];
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.text = self.review.content;
    [view addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageView.mas_bottom).mas_equalTo(15);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    //2个按钮的位置
    CGFloat btnW = 100;
    CGFloat btnInset = [UIScreen mainScreen].bounds.size.width/2-btnW-10;
    
    UIButton *useGood = [UIButton buttonWithType:UIButtonTypeCustom];
    [useGood setTintColor:[UIColor whiteColor]];
    [useGood setTitle:[NSString stringWithFormat:@"有用 %@",self.review.useful_count] forState:UIControlStateNormal];
    [useGood setTitle:[NSString stringWithFormat:@"有用 %@",self.review.useful_count] forState:UIControlStateSelected];
    useGood.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    useGood.layer.cornerRadius = 15;
    [useGood addTarget:self action:@selector(goodBtnUpInside:) forControlEvents:UIControlEventTouchUpInside];
    self.useGood = useGood;
    [view addSubview:useGood];
    [useGood mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(btnInset);
        make.width.mas_equalTo(btnW);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(view.mas_bottom).mas_equalTo(-20);
    }];
    
    UIButton *useBad = [UIButton buttonWithType:UIButtonTypeCustom];
    [useBad setTintColor:[UIColor whiteColor]];
    [useBad setTitle:[NSString stringWithFormat:@"没用 %@",self.review.useless_count] forState:UIControlStateNormal];
    [useBad setTitle:[NSString stringWithFormat:@"没用 %@",self.review.useless_count] forState:UIControlStateSelected];
    useBad.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    [useBad addTarget:self action:@selector(badBtnUpInside:) forControlEvents:UIControlEventTouchUpInside];
    useBad.layer.cornerRadius = 15;
    self.useBad = useBad;
    [view addSubview:useBad];
    [useBad mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-btnInset);
        make.width.mas_equalTo(btnW);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(view.mas_bottom).mas_equalTo(-20);
    }];
    
    
}

-(void)goodBtnUpInside:(UIButton*)btn{
    if (btn.selected == YES) {
        //没有什么反应
        [MBProgressHUD showError:@"请不要在次点评" toView:self.view];
        NSLog(@"请不要在次点评");
    }else{
        btn.backgroundColor = [UIColor blueColor];
        btn.selected = YES;
        self.useBad.selected = !btn.selected;
        self.useBad.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        NSLog(@"发出影评点赞的网络信息");
        [MBProgressHUD showSuccess:@"正在投票" toView:self.view];
    }
}

-(void)badBtnUpInside:(UIButton*)btn{
    if (btn.selected == YES) {
        //没有什么反应
        [MBProgressHUD showError:@"请不要在次点评" toView:self.view];
        NSLog(@"请不要在次点评");
    }else{
        btn.selected = YES;
        btn.backgroundColor = [UIColor blueColor];
        self.useGood.selected = !btn.selected;
        self.useGood.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        NSLog(@"发出影评差评的网络信息");
        [MBProgressHUD showSuccess:@"正在投票" toView:self.view];
    }
}





@end
