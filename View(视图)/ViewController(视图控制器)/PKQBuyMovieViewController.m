//
//  PKQBuyMovieViewController.m
//  FilmReview
//
//  Created by tarena on 15/11/14.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQBuyMovieViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "PKQNaviCinemaController.h"
#import "PKQBuyMovicTableViewCell.h"
#import "PKQBuyMovicModel.h"
#import "PKQBuyMovieTicketViewController.h"

@interface PKQBuyMovieViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
@property (strong,nonatomic)UITableView *tableView;
//有没有获取到位置
@property (strong,nonatomic)UILabel *whereLabel;
@property (strong,nonatomic) CLLocationManager* manager;
@property (strong,nonatomic) NSString *cityPath;
//当前电影院的信息
@property (strong,nonatomic) NSArray* cinemaTickct;
//收藏的电影
@property (strong,nonatomic) NSArray* collectArray;
@property (strong,nonatomic) UIActivityIndicatorView *activity;

@end

@implementation PKQBuyMovieViewController


-(UIActivityIndicatorView *)activity{
    if (!_activity) {
        _activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activity.color = PKQLoveColor;
        [_activity startAnimating];
        [self.tableView addSubview:_activity];
        [_activity mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
        }];
    }
    return _activity;
}

-(NSArray *)collectArray{
    if (!_collectArray) {
        _collectArray = [NSArray new];
    }
    return _collectArray;
}


-(NSArray *)cinemaTickct{
    if (!_cinemaTickct) {
        _cinemaTickct = [NSArray new];
    }
    return _cinemaTickct;
}


//城市文件的地址
-(NSString *)cityPath{
    if (!_cityPath) {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        _cityPath  = [path stringByAppendingPathComponent:@"city.txt"];
    }
    return _cityPath;
}


-(CLLocationManager *)manager{
    if (_manager == nil) {
        _manager = [[CLLocationManager alloc]init];
        _manager.delegate = self;
    }
    if ([UIDevice currentDevice].systemVersion.floatValue>=8.0) {
        [_manager requestAlwaysAuthorization];
        [_manager requestWhenInUseAuthorization];
    }
    return _manager;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title = [NSString stringWithFormat:@"%@的影讯",self.movicName];
    self.title = title;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.tableView registerClass:[PKQBuyMovicTableViewCell class] forCellReuseIdentifier:@"pkq"];
    
    
    //加一个footView
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,200);
    self.tableView.tableFooterView = view;
    
    //设置2个按钮和文本框
    
    UILabel *label = [UILabel new];
    label.text = @"没有获取到你的位置,无法显示附近的电影院";
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.right.mas_equalTo(0);
    }];
    label.hidden = YES;
    //    if (self.cinemaArray.count <2) {
    //        label.hidden = NO;
    //    }else{
    //        label.hidden = YES;
    //    }
    self.whereLabel = label;
    
    
    FUIButton *againBtn = [FUIButton buttonWithType:0];
    [againBtn setTintColor:[UIColor whiteColor]];
    
    againBtn.buttonColor = [UIColor turquoiseColor];
    againBtn.shadowColor = [UIColor greenSeaColor];
    againBtn.shadowHeight = 3.0f;
    againBtn.cornerRadius = 6.0f;
    againBtn.titleLabel.font = [UIFont boldFlatFontOfSize:19];
    [againBtn setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [againBtn setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    [againBtn setTitle:@"重新获取我的位置" forState:UIControlStateNormal];
    [againBtn addTarget:self action:@selector(againNaviCinema) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:againBtn];
    CGFloat btnW = [UIScreen mainScreen].bounds.size.width*0.75;
    [againBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.centerX.mas_equalTo(view);
        make.width.mas_equalTo(btnW);
        make.height.mas_equalTo(40);
    }];
    
    FUIButton *localBtn = [FUIButton buttonWithType:0];
    [localBtn setTintColor:[UIColor whiteColor]];
    localBtn.buttonColor = [UIColor turquoiseColor];
    localBtn.shadowColor = [UIColor greenSeaColor];
    localBtn.shadowHeight = 3.0f;
    localBtn.cornerRadius = 6.0f;
    localBtn.titleLabel.font = [UIFont boldFlatFontOfSize:19];
    [localBtn setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [localBtn setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    [localBtn setTitle:@"搜索本地影院" forState:UIControlStateNormal];
    localBtn.layer.cornerRadius = 4;
    [localBtn addTarget:self action:@selector(getLocalCinema) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:localBtn];
    [localBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(againBtn.mas_bottom).mas_equalTo(15);
        make.centerX.mas_equalTo(view);
        make.width.mas_equalTo(btnW);
        make.height.mas_equalTo(40);
    }];

    
    //更新位置
    [self.manager startUpdatingLocation];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    //把数据库的所有收藏的数组赋值
    self.collectArray = [[PKQSqlit allCinema]copy];
    [self.tableView reloadData];
}


//重新定位
-(void)againNaviCinema{
    //更新位置
    [self.manager startUpdatingLocation];
    [MBProgressHUD showSuccess:@"开始更新位置" toView:self.view];
}
//搜索本地的影院
-(void)getLocalCinema{
    //搜索本地的影院
    PKQNaviCinemaController *vc = [[PKQNaviCinemaController alloc]init];
    vc.name = @"搜索本地影院";
    [self.navigationController pushViewController:vc animated:YES];
}


//当定位到用户信息以后，会在下方方法中返回位置
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = locations.firstObject;
    NSLog(@"location %@", location);
    //只定位一次，即定位完成后 停止更新位置
    [self.manager stopUpdatingLocation];
    //定位好更新附近的电影院
    [self getNearWithCinemafor:location.coordinate];
}

-(void)getNearWithCinemafor:(CLLocationCoordinate2D)coordinate{
//    http://api.douban.com/v2/movie/subject/25881786/schedule_sites?
//    alt=json&
//    apikey=0df993c66c0c636e29ecbb5344252a4a&
//    app_name=doubanmovie&
//    city=%E5%8C%97%E4%BA%AC&
//    client=e%3AiPhone8%2C2%7Cy%3AiPhone%20OS_9.0.2%7Cs%3Amobile%7Cf%3Adoubanmovie_2%7Cv%3A3.6.7%7Cm%3A%E8%B1%86%E7%93%A3%E7%94%B5%E5%BD%B1%7Cudid%3A2f6386d033b0a1f01f6a32b4db14558ccc4abe57&
//    count=6&
//    douban_udid=c3a8887c60f551117c1859548c56ea60f35b6295&
//    start=0&
//    udid=2f6386d033b0a1f01f6a32b4db14558ccc4abe57&
//    version=2
    NSString *path = [NSString stringWithFormat:@"http://api.douban.com/v2/movie/subject/%@/schedule_sites",self.dbID];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[@"alt"] = @"json";
    dict[@"apikey"]=@"0b2bdeda43b5688921839c8ecb20399b";
    dict[@"client"]=@"s%3Amobile%7Cy%3AAndroid+5.0.2%7Co%3A506306.6%7Cf%3A71%7Cv%3A2.7.5%7Cm%3A360_Market%7Cd%3A352443060767031%7Ce%3AHTC+htc_mectl%7Css%3A1080x1776";
    dict[@"app_name"]= @"doubanmovie";
    dict[@"udid"]=@"2f6386d033b0a1f01f6a32b4db14558ccc4abe57";
    dict[@"douban_udid"]=@"c3a8887c60f551117c1859548c56ea60f35b6295";
    dict[@"count"]=@"6";
    dict[@"start"]=@"0";
    //本地的城市文件
    NSString *cityName =[NSString stringWithContentsOfFile:self.cityPath encoding:NSUTF8StringEncoding error:nil];
    dict[@"city"]= cityName;
    dict[@"version"]=@"2";
    
    [self.activity startAnimating];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:path parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        PKQBuyMovicModel *model = [PKQBuyMovicModel objectWithKeyValues:responseObject];
        self.cinemaTickct = model.entries;
        [self.activity stopAnimating];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [MBProgressHUD showSuccess:@"网络有问题请稍候在试。" toView:self.view];
    }];
    
    
    
    
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? self.collectArray.count: self.cinemaTickct.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     PKQBuyMovicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pkq" forIndexPath:indexPath];
    if (indexPath.section == 0 ) {
        
    }else{
        PKQBuyMovieEntriesModel *model = self.cinemaTickct[indexPath.row];
        cell.model = model;
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
kRemoveCellSeparator
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PKQBuyMovieTicketViewController *vc = [[PKQBuyMovieTicketViewController alloc]init];
    PKQBuyMovieEntriesModel *model = self.cinemaTickct[indexPath.row];
    vc.cinemaID = model.site.ID;
    vc.movieID = self.dbID;
    vc.cinemaName = model.site.title;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}

//设置分区头
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.collectArray.count <1) {
            return nil;
        }else{
            UILabel *label = [UILabel new];
            label.text = @"常去的影院";
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = PKQLoveColor;
            return label;
        }
    }else{
        UILabel *label = [UILabel new];
        label.text = @"附近的影院";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = PKQLoveColor;
        return label;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

@end
