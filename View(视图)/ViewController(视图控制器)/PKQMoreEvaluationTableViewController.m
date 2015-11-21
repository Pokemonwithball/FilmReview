//
//  PKQMoreEvaluationTableViewController.m
//  FilmReview
//
//  Created by tarena on 15/10/23.
//  Copyright © 2015年 tarena. All rights reserved.
//   http://api.douban.com/v2/movie/subject/1866473/reviews?
//alt=json&
//apikey=0df993c66c0c636e29ecbb5344252a4a&
//app_name=doubanmovie&
//client=e%3AiPhone8%2C2%7Cy%3AiPhone%20OS_9.0.2%7Cs%3Amobile%7Cf%3Adoubanmovie_2%7Cv%3A3.6.7%7Cm%3A%E8%B1%86%E7%93%A3%E7%94%B5%E5%BD%B1%7Cudid%3A2f6386d033b0a1f01f6a32b4db14558ccc4abe57&
//count=20&
//douban_udid=c3a8887c60f551117c1859548c56ea60f35b6295&
//start=0&
//udid=2f6386d033b0a1f01f6a32b4db14558ccc4abe57
//&version=2

#import "PKQMoreEvaluationTableViewController.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "PKQMoviesModel.h"
#import "MJExtension.h"
#import "PKQMoreCell.h"
#import "PKQConst.h"
#import "PKQMoreEvalutController.h"
#import "Masonry.h"
@interface PKQMoreEvaluationTableViewController ()
@property (assign,nonatomic) NSInteger count;
@property (assign,nonatomic) NSInteger start;
@property (strong,nonatomic) NSMutableArray *reviewArray;
@property (strong,nonatomic) UIImageView *imageView;
@end

@implementation PKQMoreEvaluationTableViewController

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noImage"]];
    }
    return _imageView;
}


-(NSMutableArray *)reviewArray{
    if (!_reviewArray) {
        _reviewArray = [NSMutableArray new];
    }
    return _reviewArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.mas_equalTo(kWindowW);
        make.height.mas_equalTo(kWindowH);
    }];
    self.imageView.hidden = YES;
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PKQMoreCell" bundle:nil] forCellReuseIdentifier:@"pkq"];
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMore)];
    self.count = 20;
    [self refresh];
    
}
/*刷新*/
-(void)refresh{
    
    self.start = 0;
    NSString *path = [NSString stringWithFormat:@"http://api.douban.com/v2/movie/subject/%@/reviews",self.dbId];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"alt"] = @"json";
    dict[@"apikey"] = @"0df993c66c0c636e29ecbb5344252a4a";
    dict[@"app_name"] = @"doubanmovie";
    dict[@"client"] = @"e%3AiPhone8%2C2%7Cy%3AiPhone%20OS_9.0.2%7Cs%3Amobile%7Cf%3Adoubanmovie_2%7Cv%3A3.6.7%7Cm%3A%E8%B1%86%E7%93%A3%E7%94%B5%E5%BD%B1%7Cudid%3A2f6386d033b0a1f01f6a32b4db14558ccc4abe57";
    dict[@"douban_udid"] = @"c3a8887c60f551117c1859548c56ea60f35b6295";
    dict[@"udid"] = @"2f6386d033b0a1f01f6a32b4db14558ccc4abe57";
    dict[@"version"] = @"2";
    dict[@"start"] = @(self.start);
    dict[@"count"] = @(self.count);
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.color = PKQLoveColor;
    [activity startAnimating];
    [self.view addSubview:activity];
    [activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];
    
    [[AFHTTPRequestOperationManager manager] GET:path parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        PKQMoviesReviewsModel *reviews = [PKQMoviesReviewsModel objectWithKeyValues:responseObject];
        if (self.start == 0) {
            [self.reviewArray removeAllObjects];
        }
        [activity stopAnimating];
        [self.reviewArray addObjectsFromArray:reviews.reviews];
        
        if (self.reviewArray.count <1) {
            self.imageView.hidden = NO;
        }else{
            self.imageView.hidden = YES;
        }
        
        
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络有问题，请稍后再试" toView:self.view];
    }];
}
-(void)getMore{
    self.start = self.start+self.count;
    NSString *path = [NSString stringWithFormat:@"http://api.douban.com/v2/movie/subject/%@/reviews",self.dbId];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"alt"] = @"json";
    dict[@"apikey"] = @"0df993c66c0c636e29ecbb5344252a4a";
    dict[@"app_name"] = @"doubanmovie";
    dict[@"client"] = @"e%3AiPhone8%2C2%7Cy%3AiPhone%20OS_9.0.2%7Cs%3Amobile%7Cf%3Adoubanmovie_2%7Cv%3A3.6.7%7Cm%3A%E8%B1%86%E7%93%A3%E7%94%B5%E5%BD%B1%7Cudid%3A2f6386d033b0a1f01f6a32b4db14558ccc4abe57";
    dict[@"douban_udid"] = @"c3a8887c60f551117c1859548c56ea60f35b6295";
    dict[@"udid"] = @"2f6386d033b0a1f01f6a32b4db14558ccc4abe57";
    dict[@"version"] = @"2";
    dict[@"start"] = @(self.start);
    dict[@"count"] = @(self.count);
    
    [[AFHTTPRequestOperationManager manager] GET:path parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        PKQMoviesReviewsModel *reviews = [PKQMoviesReviewsModel objectWithKeyValues:responseObject];
        if (self.start == 0) {
            [self.reviewArray removeAllObjects];
        }
        [self.reviewArray addObjectsFromArray:reviews.reviews];
        [self.tableView.footer endRefreshing];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络有问题，请稍后再试" toView:self.view];
    }];
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reviewArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PKQMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pkq" forIndexPath:indexPath];
    PKQMoviesReviewsReviewsModel *review = self.reviewArray[indexPath.row];
    cell.titleLabel.text = review.title;
    cell.contentLabel.text = review.content;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
kRemoveCellSeparator
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PKQMoviesReviewsReviewsModel *review = self.reviewArray[indexPath.row];
    PKQMoreEvalutController *moreVC = [[PKQMoreEvalutController alloc]initWithNibName:@"PKQMoreEvalutController" bundle:nil];
    moreVC.review = review;
    if (self.navigationController == nil) {
        [self presentViewController:moreVC animated:YES completion:nil];
    }else{
        [self.navigationController pushViewController:moreVC animated:YES];
    }
    
}


@end
