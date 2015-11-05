//
//  PKQMoviesViewController.m
//  FilmReview
//
//  Created by tarena on 15/10/20.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "PKQMoviesViewController.h"
#import "PKQMovieViewController.h"
#import "PKQScrollView.h"
#import "PKQReleaseViewController.h"
#import "PKQProvince.h"
#import "PKQCity.h"
#import "PKQReleas.h"
#import "PKQScrollViewController.h"
#import "PKQMoviesModel.h"
#import "PKQSearchController.h"


@interface PKQMoviesViewController ()<UITableViewDelegate,UITableViewDataSource>
/*遮盖视图*/
@property (weak, nonatomic) IBOutlet UIView *coverView;
//上映电影视图
@property (strong,nonatomic) PKQReleaseViewController *releaseMovie;
//上映电影内容
@property (strong,nonatomic) NSArray* releaseArray;
//省列表
@property (weak, nonatomic) IBOutlet UITableView *provinceTableView;
//城市列表
@property (weak, nonatomic) IBOutlet UITableView *cityTableView;
/*主要的列表*/
@property (weak, nonatomic) IBOutlet UIView *mainView;
/*区域数组*/
@property (strong,nonatomic) NSArray* provinceArray;
/*城市数组*/
@property (strong,nonatomic) NSArray* cityArray;
/*城市信息的存放地址*/
@property (strong,nonatomic) NSString* cityPath;
/*pageViewControll*/
//@property (strong,nonatomic) PKQScrollViewController* scrollVC;
/*电影详情*/
@property (strong,nonatomic) PKQMoviesModel* movie;
//当前选择的城市
@property (strong,nonatomic) NSString *selectCity;


@end

@implementation PKQMoviesViewController


//城市文件的地址
-(NSString *)cityPath{
    if (!_cityPath) {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        _cityPath  = [path stringByAppendingPathComponent:@"city.txt"];
    }
    return _cityPath;
}

-(NSArray *)provinceArray{
    if (!_provinceArray) {
        _provinceArray = [PKQTool province];
    }
    return _provinceArray;
}

-(PKQReleaseViewController *)releaseMovie{
    if (!_releaseMovie) {
        PKQReleaseViewController *rele = [[PKQReleaseViewController alloc]init];
        
        rele.view.frame = CGRectMake(0, 64, self.mainView.frame.size.width,self.mainView.frame.size.height - 100);
        [self.mainView addSubview:rele.view];
        _releaseMovie = rele;
    }
    return _releaseMovie;
}


//设定一些基本属性
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"当前上映";
        self.tabBarItem.image=[UIImage imageNamed:@"tabbar_item_store"];
        //self.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbar_selected_back"];
        //self.tabBarController.tabBar.selectionIndicatorImage = ~~~
    }
    return self;
}
/*程序结束的时候调用*/
-(void)dealloc{
    //移除所有的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    //接受通知
    [PKQNotificationCenter addObserver:self selector:@selector(cityChange:) name:PKQCityDidChangeNotification object:nil];
    [PKQNotificationCenter addObserver:self selector:@selector(UpInside:) name:PKQMovieButtonUpInsideNotification object:nil];
    
    //设置导航栏上面的城市选择
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"城市" style:UIBarButtonItemStyleDone target:self action:@selector(changCiry:)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(serachWithName:) image:@"icon_search" highImage:@"icon_search_highlighted"];
    
    
    //设置一些视图的hidden
    [self viewIsHiddemn];
    
    //读取本地城市文件
        NSString *cityName = [NSString stringWithContentsOfFile:self.cityPath encoding:NSUTF8StringEncoding error:nil];
    if (cityName) {
        [PKQNotificationCenter postNotificationName:PKQCityDidChangeNotification object:nil userInfo:@{PKQSelectCity : cityName}];
    }

}
-(void)viewIsHiddemn{
    //遮盖一开始隐藏
    self.coverView.hidden = YES;
    //遮盖上的点击事件
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(coverViewisHidden)];
    [self.coverView addGestureRecognizer:tapGR];
    //区域和城市列表的一些基本属性
    self.provinceTableView.bounces = NO;
    self.provinceTableView.hidden =YES;
    self.cityTableView.tableFooterView = [UIView new];
    self.cityTableView.bounces = NO;
    self.cityTableView.hidden = YES;
    self.cityTableView.backgroundColor = [UIColor clearColor];
}

#pragma mark -通知事件
/*城市改变的通知*/
-(void)cityChange:(NSNotification*)notification{
    NSString *cityName = notification.userInfo[PKQSelectCity];
    //设置导航栏上面的城市按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:cityName style:UIBarButtonItemStyleDone target:self action:@selector(changCiry:)];
    //保存当前城市的名字
    self.selectCity = cityName;
    //发送网络请求然后刷新表格
    NSString *strUrl = @"https://api.douban.com/v2/movie/in_theaters";
    NSString *urlstr = [[NSString alloc]initWithFormat:@"%@?city=%@",strUrl,cityName];
    urlstr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *url = [NSURL URLWithString:urlstr];
//    NSLog(@"---%@",urlstr);
    self.releaseMovie.array = nil;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlstr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //获取上映的电影信息，然后传给 self.releaseMovie
        self.releaseArray = [PKQReleas objectArrayWithKeyValuesArray:responseObject[@"subjects"]];
        self.releaseMovie.array = self.releaseArray;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD showError:@"网络有问题，请稍后再试" toView:self.view];
    }];
    
    //写到本地文件中去
    [cityName writeToFile:self.cityPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}

#pragma mark - 电影详情
-(void)UpInside:(NSNotification*)notification{
    NSString *dbId = notification.userInfo[PKQSelectMovie];
    //推出的时候发送网络请求
    //http://api.douban.com/v2/movie/subject/1866473?alt=json&apikey=0df993c66c0c636e29ecbb5344252a4a&app_name=doubanmovie&city=%E5%8C%97%E4%BA%AC&client=e%3AiPhone8%2C2%7Cy%3AiPhone%20OS_9.0.2%7Cs%3Amobile%7Cf%3Adoubanmovie_2%7Cv%3A3.6.7%7Cm%3A%E8%B1%86%E7%93%A3%E7%94%B5%E5%BD%B1%7Cudid%3A2f6386d033b0a1f01f6a32b4db14558ccc4abe57&douban_udid=c3a8887c60f551117c1859548c56ea60f35b6295&udid=2f6386d033b0a1f01f6a32b4db14558ccc4abe57&version=2
//    NSString *str = @"http://api.douban.com/v2/movie/subject/26094129 ?alt=json&
//    apikey=0df993c66c0c636e29ecbb5344252a4a&
//    app_name=doubanmovie&
//    city=%E5%8C%97%E4%BA%AC&
//    client=e%3AiPhone8%2C2%7Cy%3AiPhone%20OS_9.0.2%7Cs%3Amobile%7Cf%3Adoubanmovie_2%7Cv%3A3.6.7%7Cm%3A%E8%B1%86%E7%93%A3%E7%94%B5%E5%BD%B1%7Cudid%3A2f6386d033b0a1f01f6a32b4db14558ccc4abe57&
//    douban_udid=c3a8887c60f551117c1859548c56ea60f35b6295&
//    udid=2f6386d033b0a1f01f6a32b4db14558ccc4abe57&
//    version=2";
    
    
    NSString *str = [NSString stringWithFormat:@"http://api.douban.com/v2/movie/subject/%@",dbId];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"alt"] = @"json";
    dict[@"apikey"] = @"0df993c66c0c636e29ecbb5344252a4a";
    dict[@"app_name"] = @"doubanmovie";
    dict[@"client"] = @"e%3AiPhone8%2C2%7Cy%3AiPhone%20OS_9.0.2%7Cs%3Amobile%7Cf%3Adoubanmovie_2%7Cv%3A3.6.7%7Cm%3A%E8%B1%86%E7%93%A3%E7%94%B5%E5%BD%B1%7Cudid%3A2f6386d033b0a1f01f6a32b4db14558ccc4abe57";
    dict[@"douban_udid"] = @"c3a8887c60f551117c1859548c56ea60f35b6295";
    dict[@"udid"] = @"2f6386d033b0a1f01f6a32b4db14558ccc4abe57";
    dict[@"version"] = @"2";
    dict[@"city"] = self.selectCity;
    
    PKQScrollViewController *scrollVC = [[PKQScrollViewController alloc]initWithControllers];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:str parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.movie = [PKQMoviesModel objectWithKeyValues:responseObject];
        self.movie.dbId = dbId;
        scrollVC.movie = self.movie;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD showError:@"网络有问题，请稍后再试" toView:self.view];
    }];
    [self.navigationController pushViewController:scrollVC animated:YES];
}


#pragma mark ---点击事件
//遮盖的点击事件
-(void)coverViewisHidden{
    self.cityTableView.hidden = YES;
    self.provinceTableView.hidden = YES;
    self.coverView.hidden = YES;
}
//点击城市按钮响应
-(void)changCiry:(UIBarButtonItem*)item{
    
    //每次provinceTableView 都滚动到第一行
    [self viewDidAppear:YES];
    self.provinceTableView.hidden = !self.provinceTableView.hidden;
    self.cityTableView.hidden = YES;
    self.coverView.hidden = self.provinceTableView.hidden;
}

-(void)serachWithName:(id)search
{
    PKQSearchController *vc = [[PKQSearchController alloc]initWithNibName:@"PKQSearchController" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark-tableView的代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.provinceTableView) {
        return self.provinceArray.count;
    }else{
        return self.cityArray.count;
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //尝试按照定好的标识去队列取，看看有没有可以取
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCell"];
    }
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    if (tableView == self.provinceTableView) {
        PKQProvince *province = self.provinceArray[indexPath.row];
        cell.textLabel.text= province.state;
    }else{
        PKQCity *city = self.cityArray[indexPath.row];
        cell.textLabel.text = city.city;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.provinceTableView) {
        self.cityArray = nil;
        PKQProvince *province = self.provinceArray[indexPath.row];
        self.cityArray = [PKQTool cityWith:province];
        self.provinceTableView.hidden = YES;
        self.cityTableView.hidden = NO;
        [self.provinceTableView reloadData];
        [self.cityTableView reloadData];
    }else{
        [self.cityTableView reloadData];
        self.cityTableView.hidden = YES;
        self.coverView.hidden = YES;
        //发出网络请求和改变按钮的文字(发出通知)
        PKQCity *city = self.cityArray[indexPath.row];
        NSString *cityName = city.city;
        [PKQNotificationCenter postNotificationName:PKQCityDidChangeNotification object:nil userInfo:@{PKQSelectCity : cityName}];
    }
}

//在试图显示完成后表格滚动到最顶部
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
    [self.provinceTableView scrollToRowAtIndexPath:firstIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
}


@end
