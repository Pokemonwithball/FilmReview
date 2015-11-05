//
//  PKQMapViewController.m
//  FilmReview
//
//  Created by tarena on 15/11/4.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQMapViewController.h"

@interface PKQMapViewController ()

@end

@implementation PKQMapViewController


//需要截取html的信息；
- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *map = [UIWebView new];
    NSURL *url=[NSURL URLWithString:self.mapStr];
    NSLog(@"--%@",self.mapStr);
      NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [map loadRequest:request];
    [self.view addSubview:map];
    [map mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
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
