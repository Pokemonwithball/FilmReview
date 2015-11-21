//
//  PKQBuyMovieTicketViewController.m
//  FilmReview
//
//  Created by tarena on 15/11/14.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQBuyMovieTicketViewController.h"
#import "PKQCinemaMovieModel.h"
#import "PKQCinemaTickerCell.h"
#import "PKQCinemaDetailViewController.h"


@interface PKQBuyMovieTicketViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) NSArray* dateArray;
@property (strong,nonatomic) NSArray* allTicketArray;
@end

@implementation PKQBuyMovieTicketViewController

-(NSArray *)allTicketArray{
    if (!_allTicketArray) {
        _allTicketArray = [NSArray new];
    }
    return _allTicketArray;
}

-(NSArray *)dateArray{
    if (!_dateArray) {
        _dateArray = [NSArray new];
    }
    return _dateArray;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // cell的大小
        CGFloat inset = 10.0;
        layout.itemSize = CGSizeMake((kWindowW-4*inset)/3, 70);
        layout.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset);
        layout.headerReferenceSize = CGSizeMake(0, inset*3);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        //表的内边距
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0,54, 0);
        
        //注册
        [_collectionView registerNib:[UINib nibWithNibName:@"PKQCinemaTickerCell" bundle:nil] forCellWithReuseIdentifier:@"pkq"];
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(cinemaDeail) image:@"icon_category_99" highImage:@"icon_category_highlighted_99"];
    
//    self.title = self.cinemaName;
    
    // Do any additional setup after loading the view.
//    //http://api.douban.com/v2/movie/cinema/117135/schedule?
//    alt=json&
//    apikey=0df993c66c0c636e29ecbb5344252a4a&
//    app_name=doubanmovie&
//    client=e%3AiPhone8%2C2%7Cy%3AiPhone%20OS_9.0.2%7Cs%3Amobile%7Cf%3Adoubanmovie_2%7Cv%3A3.6.7%7Cm%3A%E8%B1%86%E7%93%A3%E7%94%B5%E5%BD%B1%7Cudid%3A2f6386d033b0a1f01f6a32b4db14558ccc4abe57&
//    douban_udid=c3a8887c60f551117c1859548c56ea60f35b6295&
//    sid=26269510&
//    udid=2f6386d033b0a1f01f6a32b4db14558ccc4abe57&
//    version=2
    //发送网络请求
    NSString *path = [NSString stringWithFormat:@"http://api.douban.com/v2/movie/cinema/%@/schedule",self.cinemaID];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[@"alt"] = @"json";
    dict[@"apikey"]=@"0b2bdeda43b5688921839c8ecb20399b";
    dict[@"client"]=@"s%3Amobile%7Cy%3AAndroid+5.0.2%7Co%3A506306.6%7Cf%3A71%7Cv%3A2.7.5%7Cm%3A360_Market%7Cd%3A352443060767031%7Ce%3AHTC+htc_mectl%7Css%3A1080x1776";
    dict[@"app_name"]= @"doubanmovie";
    dict[@"udid"]=@"2f6386d033b0a1f01f6a32b4db14558ccc4abe57";
    dict[@"douban_udid"]=@"c3a8887c60f551117c1859548c56ea60f35b6295";
    dict[@"version"]=@"2";
    dict[@"sid"]=self.movieID;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:path parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        PKQCinemaMovieModel *model = [PKQCinemaMovieModel objectWithKeyValues:responseObject];
        [self getAllMovieTicket:model];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
    }];
    
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(0);
    }];
    
}
//电影院详情
-(void)cinemaDeail{
    PKQCinemaDetailViewController *vc = [[PKQCinemaDetailViewController alloc]initWithNibName:@"PKQCinemaDetailViewController" bundle:nil];
    //设置标题
   vc.str = self.cinemaName;
    
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
    NSString *path = [NSString stringWithFormat:@"http://api.douban.com/v2/movie/cinema/%@",self.cinemaID];
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
        PKQCinemaDetailModel *model = [PKQCinemaDetailModel objectWithKeyValues:responseObject];
        vc.model = model;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络加载出差。" toView:self.view];
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}




//获得全部的电影票信息
-(void)getAllMovieTicket:(PKQCinemaMovieModel*)model{
    self.allTicketArray = model.entries;
    //全部的上映日子
    NSMutableArray *dateArr = [NSMutableArray new];
    for (int i=0; i<model.entries.count; i++) {
        PKQCinemaMovieEntriesModel *entries = self.allTicketArray[i];
        [dateArr addObject:entries.date];
    }
    //获取唯一对象
    self.dateArray = [self arrayWithMemberIsOnly:dateArr];
    
    
}
/*移除数组中相同的元素*/
-(NSArray *)arrayWithMemberIsOnly:(NSArray *)array{
    NSMutableArray *categoryArray =[NSMutableArray new];
    for (unsigned i = 0; i < [array count]; i++) {
        @autoreleasepool {
            if ([categoryArray containsObject:[array objectAtIndex:i]]==NO) {
                [categoryArray addObject:[array objectAtIndex:i]];
            }
        }
    }
    return categoryArray;
}




-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PKQCinemaTickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pkq" forIndexPath:indexPath];
    
    
    return cell;
}











@end
