//
//  PKQDirectorViewController.m
//  FilmReview
//
//  Created by tarena on 15/10/28.
//  Copyright © 2015年 tarena. All rights reserved.
//http://movie.douban.com/celebrity/1054395/mobile

#import "PKQDirectorViewController.h"
#import "Masonry.h"
#import "PKQConst.h"
@interface PKQDirectorViewController ()
@property (strong,nonatomic) UIScrollView *scrollView;
@property (strong,nonatomic) UIWebView *webView;
@end

@implementation PKQDirectorViewController

-(void)setID:(NSString *)ID{
    _ID = ID;
 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //类似导航栏的东西
    UIView *bkView = [UIView new];
    bkView.frame = self.view.frame;
    bkView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:bkView];
    UIView *view = [UIView new];
    view.backgroundColor = PKQColor(246, 246, 246);
    [bkView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(63);
    }];
    //灰色的线
    UIView *linView = [UIView new];
    linView.backgroundColor = PKQColor(207, 207, 207);
    [bkView addSubview:linView];
    [linView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(63);
        make.right.left.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    //返回按钮
    UIButton *button = [UIButton buttonWithType:1];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(presentBack) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
    }];
    //标题
    UILabel *label = [UILabel new];
    label.text = self.movieName;
    label.textColor = PKQLoveColor;
    label.frame = CGRectMake(25, 25,[UIScreen mainScreen].bounds.size.width-50, 40);
    label.textAlignment = NSTextAlignmentCenter;
    [bkView addSubview:label];
    
    

    
    //网页界面
//    UIScrollView *scrollView = [UIScrollView new];
//    scrollView.frame = CGRectMake(0, 32, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//    scrollView.contentSize = CGSizeMake(0,0);
//    self.scrollView = scrollView;
//    [bkView addSubview:scrollView];
    
    UIWebView *webView = [UIWebView new];
    NSString *str = [NSString stringWithFormat:@"http://movie.douban.com/celebrity/%@/mobile",self.ID];
    NSURL *url=[NSURL URLWithString:str];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    webView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.webView = webView;
    [webView loadRequest:request];
    [bkView addSubview:webView];

}

//搜索推出返回
-(void)presentBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
