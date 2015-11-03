//
//  PKQSearchController.m
//  FilmReview
//
//  Created by tarena on 15/10/31.
//  Copyright © 2015年 tarena. All rights reserved.
//http://api.douban.com/v2/movie/search?alt=json&apikey=0df993c66c0c636e29ecbb5344252a4a&app_name=doubanmovie&client=e%3AiPhone8%2C2%7Cy%3AiPhone%20OS_9.0.2%7Cs%3Amobile%7Cf%3Adoubanmovie_2%7Cv%3A3.6.7%7Cm%3A%E8%B1%86%E7%93%A3%E7%94%B5%E5%BD%B1%7Cudid%3A2f6386d033b0a1f01f6a32b4db14558ccc4abe57&count=20&douban_udid=c3a8887c60f551117c1859548c56ea60f35b6295&q=%E4%BB%8A%E5%A4%A9&start=0&udid=2f6386d033b0a1f01f6a32b4db14558ccc4abe57&version=2

#import "PKQSearchController.h"
#import "PKQConst.h"
#import "AFNetworking.h"
#import "PKQSearchMovieModel.h"
#import "MJExtension.h"
#import "Masonry.h"
#import "PKQConst.h"
#import "MBProgressHUD+MJ.h"
#import "PKQSearchMovieViewCell.h"
#import "MJRefresh.h"
#import "PKQScrollViewController.h"
#import "PKQMoviesModel.h"
@interface PKQSearchController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searText;
//遮盖
@property (strong, nonatomic)  UIView *coverView;
//搜索数组
@property (strong,nonatomic) NSMutableArray* searArray;
//搜索内容的路径
@property (strong,nonatomic) NSString* searPath;
/*搜索结果表*/
@property (strong,nonatomic) UITableView* searchTableView;
/*搜索结果的数组*/
@property (strong,nonatomic) NSMutableArray* searchArray;
//当前
@property (assign,nonatomic) NSInteger start;
//最大
@property (assign,nonatomic) NSInteger total;

@property (strong,nonatomic) PKQMoviesModel* movie;

@end

@implementation PKQSearchController

-(NSMutableArray *)searchArray{
    if (!_searchArray) {
        _searchArray = [NSMutableArray new];
    }
    return _searchArray;
}


-(NSString *)searPath{
    if (!_searPath) {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *strPath = [path stringByAppendingPathComponent:@"sear.txt"];
        NSFileManager *manager=[NSFileManager defaultManager];
        if (![manager fileExistsAtPath:_searPath]) {
            [manager createFileAtPath:_searPath contents:nil attributes:nil];
        }
        _searPath = strPath;
        NSLog(@"%@",strPath);
    }
    return _searPath;
}
-(NSMutableArray *)searArray{
    if (!_searArray) {
        _searArray = [NSMutableArray new];
    }
    return _searArray;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    //创建搜索
    _searchTableView = [[UITableView alloc]init];
    _searchTableView.delegate = self;
    _searchTableView.dataSource = self;
    _searchTableView.hidden = YES;
    _searchTableView.tableFooterView = [UIView new];
    
    [self.view addSubview:_searchTableView];
    [_searchTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    
    UIView *coverView = [UIView new];
    [self.view addSubview:coverView];
    [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.left.right.bottom.mas_equalTo(0);
    }];
    self.coverView.backgroundColor = [UIColor redColor];
//    self.coverView.alpha = 0;
    self.coverView = coverView;
    self.coverView.hidden = YES;
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tag)];
    [self.coverView addGestureRecognizer:tapGR];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    self.searArray = [NSMutableArray arrayWithContentsOfFile:self.searPath];
    [self.tableView reloadData];
    self.tableView.tableFooterView = [UIView new];
    [self.searchTableView registerNib:[UINib nibWithNibName:@"PKQSearchMovieViewCell" bundle:nil] forCellReuseIdentifier:@"PKQ"];
    //下拉刷新
    self.searchTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.start = 0;
        [self.searchArray removeAllObjects];
        [self.searchTableView reloadData];
        [self getSearMovieWithNSString:self.searArray[0]];
        [self.searchTableView.header endRefreshing];
    }];
    //上拉更多
    self.searchTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //没有设置  没有更多信息的提示
        [self getSearMovieWithNSString:self.searArray[0]];
        [self.searchTableView.footer endRefreshing];
    }];
    
}

-(void)openKeyboard:(NSNotification *)notification{
    self.coverView.hidden = NO;
}

- (void)closeKeyboard:(NSNotification *)notification{
    
    self.coverView.hidden = YES;
}
//遮盖点击
-(void)tag{
    [self.searText resignFirstResponder];
    self.coverView.hidden = YES;
}

//点击返回按钮
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


//搜索
- (IBAction)seacrch:(UITextField*)sender {
    NSString *str = self.searText.text;
    //截取由空格隔开的字符串 判断有没有值
    NSArray *array = [str componentsSeparatedByString:@" "];
    int all = 0;
    for (NSString *ary in array) {
        if ([ary isEqualToString:@""]) {
            all++;
        }
        if (all == array.count) {
            self.searText.text = nil;
            [MBProgressHUD showError:@"请输入东西" toView:self.view];
            return;
        }
    }
    //隐藏第一个表格
    self.tableView.hidden = YES;
    //
    NSMutableArray *arr = [NSMutableArray new];
    NSInteger x = 0 ;
    for (int i=0; i<self.searArray.count; i++) {
        if ([self.searArray[i] isEqualToString:self.searText.text]) {
            [self.searArray removeObjectAtIndex:i];
            arr = [self.searArray copy];
            [self.searArray removeAllObjects];
            [self.searArray addObject:str];
            [self.searArray addObjectsFromArray:arr];
            x++;
            break;
        }
    }
    if (x == 0) {
        arr = [self.searArray copy];
        [self.searArray removeAllObjects];
        [self.searArray addObject:str];
        [self.searArray addObjectsFromArray:arr];
    }
    
    [self.searArray writeToFile:self.searPath atomically:YES];
    //刷新表格
    [self.tableView reloadData];
    [self.searText resignFirstResponder];
    [self.searchTableView.header beginRefreshing];
    self.searText.text = nil;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        return self.searArray.count;
    }else{
        //搜索没有东西的时候的背景图
//        if (self.searchArray.count) {
//            self.searchTableView.backgroundView = nil;
//        }else{
//            self.searchTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noImage"]];
//        }
        return self.searchArray.count;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pkq"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pkq"];
        }
        cell.textLabel.text = self.searArray[indexPath.row];
        return cell;
    }else{
        PKQSearchMovieViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"PKQ" forIndexPath:indexPath];
        PKQSearchMovieSubjectModel *subject = self.searchArray[indexPath.row];
        cell2.subject = subject;
        return cell2;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView == self.tableView ? 40 : 100;
}

kRemoveCellSeparator
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.tableView) {
        //隐藏第一个表格
        self.tableView.hidden = YES;
        NSMutableArray *arr = [NSMutableArray new];
        NSString *str = self.searArray[indexPath.row];
        [self.searArray removeObjectAtIndex:indexPath.row];
        arr = [self.searArray copy];
        [self.searArray removeAllObjects];
        [self.searArray addObject:str];
        [self.searArray addObjectsFromArray:arr];
        [self.searArray writeToFile:self.searPath atomically:YES];
        [self getSearMovieWithNSString:str];
    }else{
        PKQSearchMovieSubjectModel *subject = self.searchArray[indexPath.row];
        [self getMovieDetailWithID:subject.ID];
    }
}

#pragma mark ---网络请求
//发送网络请求
-(void)getSearMovieWithNSString:(NSString*)q{
    
    
    self.searchTableView.hidden = NO;
    
    /*
     http://api.douban.com/v2/movie/search?
     alt=json&
     apikey=0df993c66c0c636e29ecbb5344252a4a&
     app_name=doubanmovie&
     client=e%3AiPhone8%2C2%7Cy%3AiPhone%20OS_9.0.2%7Cs%3Amobile%7Cf%3Adoubanmovie_2%7Cv%3A3.6.7%7Cm%3A%E8%B1%86%E7%93%A3%E7%94%B5%E5%BD%B1%7Cudid%3A2f6386d033b0a1f01f6a32b4db14558ccc4abe57&
     count=20&
     douban_udid=c3a8887c60f551117c1859548c56ea60f35b6295&
     q=%E4%BB%8A%E5%A4%A9&
     start=0&
     udid=2f6386d033b0a1f01f6a32b4db14558ccc4abe57&
     version=2
     */
    NSString *str = @"http://api.douban.com/v2/movie/search?";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"alt"] = @"json";
    dict[@"apikey"] = @"0df993c66c0c636e29ecbb5344252a4a";
    dict[@"app_name"] = @"doubanmovie";
    dict[@"client"] = @"e%3AiPhone8%2C2%7Cy%3AiPhone%20OS_9.0.2%7Cs%3Amobile%7Cf%3Adoubanmovie_2%7Cv%3A3.6.7%7Cm%3A%E8%B1%86%E7%93%A3%E7%94%B5%E5%BD%B1%7Cudid%3A2f6386d033b0a1f01f6a32b4db14558ccc4abe57";
    dict[@"douban_udid"] = @"c3a8887c60f551117c1859548c56ea60f35b6295";
    dict[@"udid"] = @"2f6386d033b0a1f01f6a32b4db14558ccc4abe57";
    dict[@"version"] = @"2";
    dict[@"count"] = @"20";
    dict[@"start"] = @(self.start);
    dict[@"q"]= [q stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //加入旋转提示
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.color = PKQLoveColor;
    [activity startAnimating];
    [self.view addSubview:activity];
    [activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.searchTableView);
    }];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:str parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        PKQSearchMovieModel *searchMovie = [PKQSearchMovieModel objectWithKeyValues:responseObject];
        self.start +=20;
        [self.searchArray addObjectsFromArray: searchMovie.subjects];
        [self.searchTableView reloadData];
        self.total = searchMovie.total;
        [activity stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络错误,请稍候在试。" toView:self.view];
    }];
    
    
}


-(void)getMovieDetailWithID:(NSString*)dbID{
    
    NSString *str = [NSString stringWithFormat:@"http://api.douban.com/v2/movie/subject/%@",dbID];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"alt"] = @"json";
    dict[@"apikey"] = @"0df993c66c0c636e29ecbb5344252a4a";
    dict[@"app_name"] = @"doubanmovie";
    dict[@"city"] = @"北京";
    dict[@"client"] = @"e%3AiPhone8%2C2%7Cy%3AiPhone%20OS_9.0.2%7Cs%3Amobile%7Cf%3Adoubanmovie_2%7Cv%3A3.6.7%7Cm%3A%E8%B1%86%E7%93%A3%E7%94%B5%E5%BD%B1%7Cudid%3A2f6386d033b0a1f01f6a32b4db14558ccc4abe57";
    dict[@"douban_udid"] = @"c3a8887c60f551117c1859548c56ea60f35b6295";
    dict[@"udid"] = @"2f6386d033b0a1f01f6a32b4db14558ccc4abe57";
    dict[@"version"] = @"2";
    
    
    PKQScrollViewController *scrollVC = [[PKQScrollViewController alloc]initWithControllers];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:str parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.movie = [PKQMoviesModel objectWithKeyValues:responseObject];
        self.movie.dbId = dbID;
        scrollVC.movie = self.movie;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD showError:@"网络有问题，请稍后再试" toView:self.view];
    }];
    
    [self presentViewController:scrollVC animated:YES completion:nil];
    
}







@end
