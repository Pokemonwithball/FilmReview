//
//  PKQCinemaTableViewController.m
//  FilmReview
//
//  Created by tarena on 15/10/19.
//  Copyright (c) 2015年 tarena. All rights reserved.
//发送网络请求





#import "PKQCinemaViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <math.h>
#import "PKQNaviCinemaModel.h"
#import "PKQNaviCinemaCell.h"
#import "Masonry.h"
#import "PKQConst.h"
#import "PKQCollectCinemaCell.h"
#import "PKQMapViewController.h"
#import "PKQCinemaDetailViewController.h"
@interface PKQCinemaViewController ()<CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,PKQNaviCinemaCellDelegate>
@property (strong,nonatomic) CLLocationManager* manager;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//附近电影院的数量
@property (strong,nonatomic) NSArray *cinemaArray;
//收藏的电影院的数量
@property (strong,nonatomic) NSMutableArray *collectArray;
@end

@implementation PKQCinemaViewController

-(NSMutableArray *)collectArray{
    if (!_collectArray) {
        _collectArray = [NSMutableArray new];
    }
    return _collectArray;
}

-(NSArray *)cinemaArray{
    if (!_cinemaArray) {
        _cinemaArray = [NSArray new];
    }
    return _cinemaArray;
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


-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"影院";
        self.tabBarItem.image=[UIImage imageNamed:@"tabbar_item_selected"];
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //更新位置
    [self.manager startUpdatingLocation];
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:@"PKQNaviCinemaCell" bundle:nil] forCellReuseIdentifier:@"pkq"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PKQCollectCinemaCell" bundle:nil] forCellReuseIdentifier:@"PKQ"];
    
    
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
    if (self.cinemaArray.count) {
        label.hidden = NO;
    }else{
        label.hidden = YES;
    }
    
    UIButton *againBtn = [UIButton buttonWithType:1];
    [againBtn setTintColor:[UIColor whiteColor]];
    [againBtn setTitle:@"重新获取我的位置" forState:UIControlStateNormal];
    againBtn.titleLabel.font = [UIFont systemFontOfSize:19];
    againBtn.backgroundColor = PKQColor(207, 207, 207);
    againBtn.layer.cornerRadius = 4;
    [againBtn addTarget:self action:@selector(againNaviCinema) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:againBtn];
    CGFloat btnW = [UIScreen mainScreen].bounds.size.width*0.75;
    [againBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.centerX.mas_equalTo(view);
        make.width.mas_equalTo(btnW);
        make.height.mas_equalTo(40);
    }];
    
    UIButton *localBtn = [UIButton buttonWithType:1];
    [localBtn setTintColor:[UIColor whiteColor]];
    [localBtn setTitle:@"搜索本地影院" forState:UIControlStateNormal];
    localBtn.titleLabel.font = [UIFont systemFontOfSize:19];
    localBtn.backgroundColor = PKQColor(207, 207, 207);
    localBtn.layer.cornerRadius = 4;
    [localBtn addTarget:self action:@selector(getLocalCinema) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:localBtn];
    [localBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(againBtn.mas_bottom).mas_equalTo(15);
        make.centerX.mas_equalTo(view);
        make.width.mas_equalTo(btnW);
        make.height.mas_equalTo(40);
    }];
    
}

//重新定位
-(void)againNaviCinema{
    //更新位置
    [self.manager startUpdatingLocation];
}
//搜索本地的影院
-(void)getLocalCinema{
    //搜索本地的影院
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
/*发出获取附近的电影的请求*/
-(void)getNearWithCinemafor:(CLLocationCoordinate2D)coordinate{
    //http://api.douban.com/v2/movie/cinemas/nearby?
    //    lng=120.36898&
    //    apikey=0b2bdeda43b5688921839c8ecb20399b&
    //    city=%E6%9D%AD%E5%B7%9E&
    //    start=0&
    //    count=9&
    //    client=s%3Amobile%7Cy%3AAndroid+5.0.2%7Co%3A506306.6%7Cf%3A71%7Cv%3A2.7.5%7Cm%3A360_Market%7Cd%3A352443060767031%7Ce%3AHTC+htc_mectl%7Css%3A1080x1776&
    //    udid=ddc567546e329e30e8da0f42d07ac5034eef4e55&
    //    lat=30.309271
    NSString *path = @"http://api.douban.com/v2/movie/cinemas/nearby";
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[@"apikey"]=@"0b2bdeda43b5688921839c8ecb20399b";
    dict[@"client"]=@"s%3Amobile%7Cy%3AAndroid+5.0.2%7Co%3A506306.6%7Cf%3A71%7Cv%3A2.7.5%7Cm%3A360_Market%7Cd%3A352443060767031%7Ce%3AHTC+htc_mectl%7Css%3A1080x1776";
    dict[@"udid"]=@"ddc567546e329e30e8da0f42d07ac5034eef4e55";
    dict[@"count"]=@"9";
    dict[@"start"]=@"0";
    dict[@"city"]=@"杭州";
    double lng = coordinate.longitude;
    double lat = coordinate.latitude;
    lng = fabs(lng);
    lat = fabs(lat);
    NSString *strLng = [NSString stringWithFormat:@"%.5lf",lng];
    NSString *strLat = [NSString stringWithFormat:@"%.5lf",lat];
    dict[@"lng"]=strLng;
    dict[@"lat"]=strLat;
    
    
    //        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //        activity.color = PKQLoveColor;
    //        [activity startAnimating];
    //        [self.tableView addSubview:activity];
    //        [activity mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.center.mas_equalTo(self.view);
    //        }];
    kAddActivity
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:path parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        PKQNaviCinemaModel *model = [PKQNaviCinemaModel objectWithKeyValues:responseObject];
        self.cinemaArray = model.entries;
        [activity stopAnimating];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"-------%@",error);
        [MBProgressHUD showError:@"网络有问题，请稍后再试" toView:self.view];
    }];
    
}
#pragma mark --CellDegelate;
-(void)getMap:(PKQNaviCinemaCell *)cell WithNSString:(NSString *)str{
    PKQMapViewController *vc = [[PKQMapViewController alloc]init];
    vc.mapStr = str;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark --TableViewDegelate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (self.collectArray.count == 0) {
            return 1;
        }else{
            return self.collectArray.count;
        }
    }else{
        return self.cinemaArray.count;
    }
}
//分区头
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return section == 0 ? @"常去的影院" :@"附近的影院";
}




-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        PKQCollectCinemaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PKQ" forIndexPath:indexPath];
        if (self.collectArray.count == 0) {
            cell.model = nil;
        }else{
            cell.model = self.collectArray[indexPath.row];
        }
        return cell;
    }else{
        PKQNaviCinemaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pkq" forIndexPath:indexPath];
        cell.delegate = self;
        PKQNaviCinemaEntriesModel *model = self.cinemaArray[indexPath.row];
        cell.model = model;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
#pragma mark -- 设置表头有问题
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

kRemoveCellSeparator
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PKQCinemaDetailViewController *vc = [[PKQCinemaDetailViewController alloc]initWithNibName:@"PKQCinemaDetailViewController" bundle:nil];
   PKQNaviCinemaEntriesModel *model = self.cinemaArray[indexPath.row];
    vc.model = model;
//    http://api.douban.com/v2/movie/cinema/
//    118517?
//    alt=json&
//    apikey=0df993c66c0c636e29ecbb5344252a4a&
//    app_name=doubanmovie&
//    client=e%3AiPhone8%2C2%7Cy%3AiPhone%20OS_9.0.2%7Cs%3Amobile%7Cf%3Adoubanmovie_2%7Cv%3A3.6.7%7Cm%3A%E8%B1%86%E7%93%A3%E7%94%B5%E5%BD%B1%7Cudid%3A2f6386d033b0a1f01f6a32b4db14558ccc4abe57&
//    douban_udid=c3a8887c60f551117c1859548c56ea60f35b6295&
//    udid=2f6386d033b0a1f01f6a32b4db14558ccc4abe57&
//    version=2
    //发送电影详情的请求
    NSString *path = [NSString stringWithFormat:@"http://api.douban.com/v2/movie/cinema/%@",model.ID];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[@"alt"]=@"json";
    dict[@"apikey"]=@"0df993c66c0c636e29ecbb5344252a4a";
    dict[@"app_name"]=@"doubanmovie";
    dict[@"client"]=@"e%3AiPhone8%2C2%7Cy%3AiPhone%20OS_9.0.2%7Cs%3Amobile%7Cf%3Adoubanmovie_2%7Cv%3A3.6.7%7Cm%3A%E8%B1%86%E7%93%A3%E7%94%B5%E5%BD%B1%7Cudid%3A2f6386d033b0a1f01f6a32b4db14558ccc4abe57";
    dict[@"douban_udid"]=@"c3a8887c60f551117c1859548c56ea60f35b6295";
    dict[@"udid"]=@"2f6386d033b0a1f01f6a32b4db14558ccc4abe57";
    dict[@"version"]=@(2);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:path parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = (NSString*)responseObject[@"discount_policy"];
        vc.str = str;
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"-------%@",error);
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}



@end
