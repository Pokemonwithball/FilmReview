//
//  PKQCinemaDetailViewController.m
//  FilmReview
//
//  Created by tarena on 15/11/4.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQCinemaDetailViewController.h"
#import "PKQMapViewController.h"
#import "KGModal.h"
#import "PKQCinemaMovieModel.h"
#import "iCarousel.h"
#import "PKQCinemaTickerCell.h"
#import "PKQCinemaReusableView.h"
#import "PKQScrollViewController.h"
#import "PKQCinemaViewController.h"
#import "PKQSeatViewController.h"
@interface PKQCinemaDetailViewController ()<iCarouselDelegate,iCarouselDataSource,UICollectionViewDelegate,UICollectionViewDataSource,PKQCinemaReusableViewDelegate,UINavigationControllerDelegate,PKQCinemaTickerCellDelegate>
@property (weak, nonatomic) IBOutlet UIButton *mapBtn;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *huiBtn;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
//电影图片的视图
@property (weak, nonatomic) IBOutlet UIView *movieIcnView;
//没有上映的电影信息
@property (weak, nonatomic) IBOutlet UILabel *movieNoIcnLabel;
//没有这部电影的电影票
@property (weak, nonatomic) IBOutlet UILabel *movieNODeayilLabel;


@property (strong,nonatomic) UICollectionView *collectionView;
@property (assign,nonatomic) BOOL barCollect;
@property (strong,nonatomic) NSArray *allMovies;

@property (strong,nonatomic) NSArray *allMoviesIcon;

@property (strong,nonatomic) iCarousel* ic;
@property (strong,nonatomic) UIActivityIndicatorView *activity;
//当前选择的电影的全部电影票
@property (strong,nonatomic)NSArray *movieTicket;
//全部上映时间的数组
@property (strong,nonatomic)NSArray* dateArray;
//选择的天的电影票信息
@property (strong,nonatomic)NSArray* selectMovieTicket;

@property (strong,nonatomic)PKQCinemaReusableView *reusableView;

@property (assign,nonatomic)NSInteger selectSeveral;

@end

@implementation PKQCinemaDetailViewController

//-(PKQCinemaReusableView *)reusableView{
//    if (!_reusableView) {
//        _reusableView = [PKQCinemaReusableView new];
//    }
//    return _reusableView;
//}


-(NSArray *)selectMovieTicket{
    if (!_selectMovieTicket) {
        _selectMovieTicket = [NSArray new];
    }
    return _selectMovieTicket;
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
        layout.headerReferenceSize = CGSizeMake(0, inset*11);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        //表的内边距
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0,54, 0);
        
        //注册
        [_collectionView registerNib:[UINib nibWithNibName:@"PKQCinemaTickerCell" bundle:nil] forCellWithReuseIdentifier:@"pkq"];
        [_collectionView registerNib:[UINib nibWithNibName:@"PKQCinemaReusableView" bundle:nil]   forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Identifierhead"];
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}

-(iCarousel *)ic{
    if (!_ic) {
        _ic = [iCarousel new];
        _ic.delegate = self;
        _ic.dataSource = self;
        //模式
        _ic.type = 3;
        //翻页模式
        _ic.pagingEnabled = NO;
        //滚动速度
        _ic.scrollSpeed = 0.5;
    }
    return _ic;
}

//获取全部的电影信息 然后取得其中的电影
-(void)setAllMovies:(NSArray *)allMovies{
    
    _allMovies = allMovies;
    if (allMovies.count == 0) {
        return;
    }
    
    self.allMoviesIcon = [NSArray new];
    for (PKQCinemaMovieEntriesModel* pkq in allMovies) {
        [PKQSqlit addmovieTicketDeals:pkq];
    }
    
    
    NSMutableArray *nameArray = [NSMutableArray new];
    PKQCinemaMovieEntriesModel *firstmovie = allMovies[0];
    [nameArray addObject:firstmovie.subject.images.medium];
    
    NSString *str = nameArray.lastObject;
    if (allMovies.count ==1) {
        PKQCinemaMovieEntriesModel *movie = allMovies[0];
        [nameArray addObject:movie.subject.images.medium];
    }else{
        for (int i=0; i<allMovies.count; i++) {
            
            if (i == allMovies.count-1) {
                //                PKQCinemaMovieEntriesModel *movieB = allMovies[i-1];
                PKQCinemaMovieEntriesModel *movieN = allMovies[i];
                //                if ([movieB.subject.images.medium isEqualToString:movieN.subject.images.medium]) {
                //                    [nameArray addObject:movieN.subject.images.medium];
                //                }
                if ([movieN.subject.images.medium isEqualToString:str]) {
                    
                }else{
                    [nameArray addObject:movieN.subject.images.medium];
                }
            }else{
                
                PKQCinemaMovieEntriesModel *movieB = allMovies[i];
                PKQCinemaMovieEntriesModel *movieN = allMovies[i+1];
                if (![movieB.subject.images.medium isEqualToString:movieN.subject.images.medium]) {
                    if ([movieN.subject.images.medium isEqualToString:str]) {
                        
                    }else{
                        [nameArray addObject:movieN.subject.images.medium];
                    }
                    str = nameArray.lastObject;
                }
            }
        }
        
    }
    
    self.allMoviesIcon = [self arrayWithMemberIsOnly:nameArray];
    
    
    
    //刷新滚动条的数据
    [self.ic reloadData];
    [self.activity stopAnimating];
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

//当程序这个界面退出的时候释放
- (void)didEnterBackground:(NSNotification *)notification
{
    self.allMovies= nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];
}
//传入电影院信息
-(void)setModel:(PKQCinemaDetailModel *)model{
    _model = model;
    self.addressLabel.text = self.model.location.address;
    //判断这几个按钮是否可以按
    if (self.model.location.coordinate.latitude == 0 && self.model.location.coordinate.longitude == 0) {
        [self.mapBtn setImage:[UIImage imageNamed:@"tabbar_item_store"] forState:UIControlStateNormal];
        self.mapBtn.userInteractionEnabled = NO;
    }
    if (self.model.phone == nil) {
        [self.phoneBtn setImage:[UIImage imageNamed:@"tabbar_item_store"] forState:UIControlStateNormal];
        self.phoneBtn.userInteractionEnabled = NO;
    }
    
    if ([PKQSqlit isCinemaDealsWithID:self.model.ID]) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(collection:) image:@"smallcollecthi" highImage:@"smallcollecthi"];
        self.barCollect = YES;
    }else{
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(collection:) image:@"smallcollect" highImage:@"smallcollect"];
        self.barCollect = NO;
    }
    
    
    //设置3个按钮的形状
    self.mapBtn.layer.cornerRadius = 17.5;
    self.mapBtn.layer.masksToBounds = YES;
    self.phoneBtn.layer.cornerRadius = 17.5;
    self.phoneBtn.layer.masksToBounds = YES;
    self.huiBtn.layer.cornerRadius = 17.5;
    self.huiBtn.layer.masksToBounds = YES;
    //有没有优惠
    if (self.model.discount_policy.length <=2) {
        [self.huiBtn setImage:[UIImage imageNamed:@"tabbar_item_store"] forState:UIControlStateNormal];
        self.huiBtn.userInteractionEnabled = NO;
    }
    self.mapBtn.hidden = NO;
    self.phoneBtn.hidden = NO;
    self.huiBtn.hidden = NO;
    self.addressLabel.hidden = NO;
    //发送网络请求 获取该电影院正在上映的电影
    [self getCinemaAllMovies];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //进入这个界面的时候也清空数据库
    [PKQSqlit removeAllMoviesTicketDeals];
    //设置一开始的选择第几个
    self.selectSeveral = 0;
    self.title = self.str;
    
    //一开始全部隐藏然后数据获取到的时候展示
    self.mapBtn.hidden = YES;
    self.phoneBtn.hidden = YES;
    self.huiBtn.hidden = YES;
    self.addressLabel.hidden = YES;
    //一开始collview不能动
    self.collectionView.userInteractionEnabled = NO;
    
    //设置返回按钮
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"影院" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = item;
    
    //一开始2个显示没有信息的Label都隐藏起来
    self.movieNoIcnLabel.hidden = YES;
    self.movieNODeayilLabel.hidden = YES;
    
    
    //滚动视图的添加
    [self.movieIcnView addSubview:self.ic];
    //设置视图是最底层
    [self.movieIcnView sendSubviewToBack:self.ic];
    
    [self.ic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(5, 0, 5, 0));
    }];
    
    
    
    //下面显示票的collection
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.movieIcnView.mas_bottom).mas_equalTo(0);
        make.right.left.bottom.mas_equalTo(0);
    }];
    
    
}
//导航栏上的返回按钮
-(void)back{
    
    [self.ic mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(5, 1000, 5, 0));
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [PKQSqlit removeAllMoviesTicketDeals];
}



-(void)getCinemaAllMovies{
    //    http://api.douban.com/v2/movie/cinema/143039/schedule?
    //    alt=json&
    //    apikey=0df993c66c0c636e29ecbb5344252a4a&
    //    app_name=doubanmovie&
    //    client=e%3AiPhone8%2C2%7Cy%3AiPhone%20OS_9.0.2%7Cs%3Amobile%7Cf%3Adoubanmovie_2%7Cv%3A3.6.7%7Cm%3A%E8%B1%86%E7%93%A3%E7%94%B5%E5%BD%B1%7Cudid%3A2f6386d033b0a1f01f6a32b4db14558ccc4abe57&
    //    douban_udid=c3a8887c60f551117c1859548c56ea60f35b6295&
    //    udid=2f6386d033b0a1f01f6a32b4db14558ccc4abe57&
    //    version=2
    NSString *path = [NSString stringWithFormat:@"http://api.douban.com/v2/movie/cinema/%@/schedule",self.model.ID];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[@"alt"]=@"json";
    dict[@"apikey"]=@"0df993c66c0c636e29ecbb5344252a4a";
    dict[@"app_name"]=@"doubanmovie";
    dict[@"client"]=@"e%3AiPhone8%2C2%7Cy%3AiPhone%20OS_9.0.2%7Cs%3Amobile%7Cf%3Adoubanmovie_2%7Cv%3A3.6.7%7Cm%3A%E8%B1%86%E7%93%A3%E7%94%B5%E5%BD%B1%7Cudid%3A2f6386d033b0a1f01f6a32b4db14558ccc4abe57";
    dict[@"douban_udid"]=@"c3a8887c60f551117c1859548c56ea60f35b6295";
    dict[@"udid"]=@"2f6386d033b0a1f01f6a32b4db14558ccc4abe57";
    dict[@"version"]=@(2);
    
    //增加一朵菊花
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.color = PKQLoveColor;
    self.activity = activity;
    [activity startAnimating];
    [self.view addSubview:activity];
    [activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:path parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        PKQCinemaMovieModel *model = [PKQCinemaMovieModel objectWithKeyValues:responseObject];
        //让collView可以动
        self.collectionView.userInteractionEnabled = YES;
        
        //创建一个数组 然后把全部的电影信息放进去
        self.allMovies = [NSArray new];
        self.allMovies = model.entries;
        if (self.allMoviesIcon == nil) {
            [activity stopAnimating];
            
            self.movieNoIcnLabel.hidden = NO;
            
        }else{
            self.movieNoIcnLabel.hidden = YES;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"-------%@",error);
        [MBProgressHUD showError:@"网络有问题，请稍后再试" toView:self.view];
    }];
    
}



//收藏
-(void)collection:(UIBarButtonItem*)bar{
    if (self.barCollect) {
        //增加个警告框
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"你确定要从常去影院中删除？" message:@"皮卡丘" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertC animated:YES completion:nil];
        UIAlertAction *sureAction=[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [MBProgressHUD showSuccess:@"取消收藏成功" toView:self.view];
            //从数据库中删除这条数据
            [PKQSqlit removeCinemaDealsWithID:self.model.ID];
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(collection:) image:@"smallcollect" highImage:@"smallcollect"];
            self.barCollect = NO;
        }];
        UIAlertAction *falseAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
        }];
        //添加确认按钮到弹出框上
        [alertC addAction:sureAction];
        [alertC addAction:falseAction];
        
        
    }else{
        [MBProgressHUD showSuccess:@"收藏成功" toView:self.view];
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(collection:) image:@"smallcollecthi" highImage:@"smallcollecthi"];
        self.barCollect = YES;
        //数据库增加一条数据
        [PKQSqlit addCinemaDealsWith:self.model];
    }
}

#pragma  mark ----3个按钮的点击事件

//跳到地图界面
- (IBAction)goToMap:(id)sender {
    PKQMapViewController *map = [[PKQMapViewController alloc]init];
    map.mapStr = self.model.location.map_url;
    [self.navigationController pushViewController:map animated:YES];
}
//跳出电话号码
- (IBAction)tellPhone:(UIButton*)sender {
    //model.phone[0];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"联系电话" message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *cellAction = [UIAlertAction actionWithTitle:self.model.phone[0] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打电话
        NSString *allString = [NSString stringWithFormat:@"tel:%@",self.model.phone[0]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
    }];
    //UIAlertActionStyleCancel 如果是这个的话就一定在下面 然后点击屏幕的其他地方也是点击这个按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:cellAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    UIPopoverPresentationController *popover = alertController.popoverPresentationController;
    if (popover){
        popover.sourceView = sender;
        popover.sourceRect = sender.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
}

//显示优惠信息
- (IBAction)showHui:(id)sender {
    //弹出的内容
    UITextView *view = [UITextView new];
    view.backgroundColor = [UIColor clearColor];
    view.textColor = [UIColor whiteColor];
    //    view.userInteractionEnabled = NO;
    view.selectable = NO;
    view.font = [UIFont systemFontOfSize:18];
    view.text = self.model.discount_policy;
    view.frame = CGRectMake(0, 0, kWindowH*0.4, kWindowH*0.4);
    
    [[KGModal sharedInstance] showWithContentView:view andAnimated:YES];
}

#pragma mark - iCarousel
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    NSLog(@"%ld",self.allMoviesIcon.count);
    return self.allMoviesIcon.count;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view{
    if (!view) {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 142)];
        UIImageView *imageView = [UIImageView new];
        imageView.tag = 100;
        [view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    UIImageView *imageView = (UIImageView*)[view viewWithTag:100];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.allMoviesIcon[index]] placeholderImage:[UIImage imageNamed:@"noImage"]];
    return view;
}
//修改缝隙
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    //    if (option == iCarouselOptionWrap) {
    //        return YES; //type0的默认循环滚动模式是否
    //    }
    // 修改缝隙
    if (option == iCarouselOptionSpacing) {
        return value * 1.8;
    }
    //    // 取消后背的显示
    //    if (option == iCarouselOptionShowBackfaces) {
    //        return NO;
    //    }
    
    return value;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"选择了第%ld张", index);
}
/**
 *当前滚动到第几个
 *
 */
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
    NSLog(@"%ld",carousel.currentItemIndex);
    if (self.allMoviesIcon == nil) {
        
    }else{
        [self getMovieTicketWithIndex:carousel.currentItemIndex];
    }
    //每次滚动都是选择第0个
    self.selectSeveral = 0;
}
/*获取当前选择的电影的电影票信息*/
-(void)getMovieTicketWithIndex:(NSInteger)index{
    NSArray* movieTicket = [[PKQSqlit movieTicketDealsWith:self.allMoviesIcon[index]] copy];
    
    NSMutableArray *nameArray = [NSMutableArray new];
    if (movieTicket.count <1) {
        return;
    }
    PKQCinemaMovieEntriesModel *firstmovie = movieTicket[0];
    [nameArray addObject:firstmovie.date];
    
    NSString *str = nameArray.lastObject;
    if (movieTicket.count ==1) {
        PKQCinemaMovieEntriesModel *movie = movieTicket[0];
        [nameArray addObject:movie.date];
    }else{
        for (int i=0; i<movieTicket.count; i++) {
            
            if (i == movieTicket.count-1) {
                
                PKQCinemaMovieEntriesModel *movieN = movieTicket[i];
                if ([movieN.date isEqualToString:str]) {
                    
                }else{
                    [nameArray addObject:movieN.date];
                }
                
            }else{
                
                PKQCinemaMovieEntriesModel *movieB = movieTicket[i];
                PKQCinemaMovieEntriesModel *movieN = movieTicket[i+1];
                if (![movieB.date isEqualToString:movieN.date]) {
                    if ([movieN.date isEqualToString:str]) {
                        
                    }else{
                        [nameArray addObject:movieN.date];
                    }
                    str = nameArray.lastObject;
                }
            }
        }
        
    }
    //把最近的那一天拿出来，然后展示了那一天那个电影的电影票信息。
    self.dateArray = [self arrayWithMemberIsOnly:nameArray];
    self.movieTicket = movieTicket;
    
    NSArray *array2 = [self.dateArray sortedArrayUsingSelector:@selector(compare:)];
    self.dateArray = array2;
    
    NSMutableArray *muArray = [NSMutableArray new];
    for (PKQCinemaMovieEntriesModel* model in movieTicket) {
        if ([model.date isEqualToString:array2.firstObject]) {
            [muArray addObject:model];
        }
    }
    
    self.selectMovieTicket = muArray;
    
    [self.collectionView reloadData];
    //    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}



#pragma mark -- UICollectionDegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.selectMovieTicket.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PKQCinemaTickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pkq" forIndexPath:indexPath];
    cell.model = self.selectMovieTicket[indexPath.item];
    cell.delegate = self;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    PKQCinemaReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Identifierhead" forIndexPath:indexPath];
    //传入数据
    headView.select = self.selectSeveral;
    
    headView.model = self.movieTicket.firstObject;
    headView.dateArray = self.dateArray;
    headView.delegate = self;
    //按钮点击了哪一个
    
    
    self.reusableView = headView;
    
    
    
    headView.backgroundColor = [UIColor whiteColor];
    return headView;
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark --PKQCinemaReusableViewDelegate
/*发送网络请求和跳转界面*/
-(void)view:(PKQCinemaReusableView *)view goToMovieDetailWithMovieID:(NSString *)dbId withName:(NSString *)name{
    NSString *str = [NSString stringWithFormat:@"http://api.douban.com/v2/movie/subject/%@",dbId];
    
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
        PKQMoviesModel *movie = [PKQMoviesModel objectWithKeyValues:responseObject];
        movie.dbId = dbId;
        scrollVC.movie = movie;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD showError:@"网络有问题，请稍后再试" toView:self.view];
    }];
    scrollVC.movieName = name;
    [self.navigationController pushViewController:scrollVC animated:YES];
    
}
//选择了第几天
-(void)view:(PKQCinemaReusableView *)view selectDate:(NSInteger)indexPath{
    
    self.selectSeveral = indexPath;
    
    NSMutableArray *muArray = [NSMutableArray new];
    for (PKQCinemaMovieEntriesModel* model in self.movieTicket) {
        if ([model.date isEqualToString:self.dateArray[indexPath]]) {
            [muArray addObject:model];
        }
    }
    
    self.selectMovieTicket = muArray;
    [self.collectionView reloadData];
    
}

#pragma mark -----PKQCinemaTickerCellDelegate
-(void)cell:(PKQCinemaTickerCell *)cell buyTicketWithModel:(PKQCinemaMovieEntriesModel *)model{
    PKQSeatViewController *vc = [[PKQSeatViewController alloc]init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}



@end
