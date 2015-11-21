//
//  PKQMapViewController.m
//  FilmReview
//
//  Created by tarena on 15/11/4.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQMapViewController.h"

@interface PKQMapViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,assign)NSInteger num;
@end

@implementation PKQMapViewController

- (UIWebView *)webView{
    if (_webView == nil) {
        _webView = [[UIWebView alloc]init];
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    self.webView.hidden = YES;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.mapStr]]];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
#pragma mark -- UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSMutableString *js = [NSMutableString string];
    //删除广告
    [js appendString:@"var yyBg = document.getElementsByClassName('bg')[0];"];
    [js appendString:@"yyBg.parentNode.removeChild(yyBg);"];
    
    [js appendString:@"var yyTopNav = document.getElementsByClassName('top-nav')[0];"];
    [js appendString:@"yyTopNav.parentNode.removeChild(yyTopNav);"];
    
    [js appendString:@"var yySpNav = document.getElementsByClassName('sp-nav')[0];"];
    [js appendString:@"yySpNav.parentNode.removeChild(yySpNav);"];
    
    [js appendString:@"var yyDbInc = document.getElementsByClassName('db-inc')[0];"];
    [js appendString:@"yyDbInc.parentNode.removeChild(yyDbInc);"];
    self.num++;
    
    [webView stringByEvaluatingJavaScriptFromString:js];
    if (self.num == 5) {
        self.webView.hidden = NO;
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

@end
