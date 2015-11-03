//
//  PKQDirectorViewController.m
//  FilmReview
//
//  Created by tarena on 15/10/28.
//  Copyright © 2015年 tarena. All rights reserved.
//http://movie.douban.com/celebrity/1054395/mobile

#import "PKQDirectorViewController.h"

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
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    scrollView.contentSize = CGSizeMake(0,[UIScreen mainScreen].bounds.size.height);
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    UIWebView *webView = [UIWebView new];
    NSString *str = [NSString stringWithFormat:@"http://movie.douban.com/celebrity/%@/mobile",self.ID];
    NSURL *url=[NSURL URLWithString:str];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    webView.frame = scrollView.frame;
    self.webView = webView;
    [webView loadRequest:request];
    [scrollView addSubview:webView];

}



@end
