//
//  PKQReleaseViewController.m
//  FilmReview
//
//  Created by tarena on 15/10/19.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "PKQReleaseViewController.h"
#import "PKQMovieViewCell.h"
#import "PKQScrollView.h"
#import "Masonry.h"
#import "PKQConst.h"
#import "AFNetworking.h"
#import "PKQReleas.h"
#import "MJExtension.h"
#import "PKQUpMovieModel.h"
#import "MBProgressHUD+MJ.h"
#import "FBShimmeringView.h"        //漂亮的闪光效果
#import "FBShimmeringLayer.h"    //漂亮的闪光效果

@interface PKQReleaseViewController ()<UICollectionViewDelegateFlowLayout>

/*即将上映的电影*/
@property (strong,nonatomic) NSArray* upComingArray;
/*上映旋转控件*/
@property (strong,nonatomic)UIActivityIndicatorView *activity;
/*即将旋转控件*/
@property (strong,nonatomic)UIActivityIndicatorView *upActivity;
//即将上映的按钮
@property (strong,nonatomic)UIButton* upComeingBtn;

@property (strong,nonatomic)UIWebView* webView;

@property (strong,nonatomic)FBShimmeringView *shiView;

@end

@implementation PKQReleaseViewController

static NSString * const reuseIdentifier = @"PKQ";
static NSString * const Identifierhead = @"pkq";


-(UIWebView *)webView{
    if (!_webView) {
        _webView = [UIWebView new];
        NSURL *url=[NSURL URLWithString:@"http://www.douban.com/doubanapp/misc/movie_app_index?doubanapp_version="];
        NSURLRequest *request =[NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
        
        _webView.scrollView.userInteractionEnabled = NO;
    }
    return _webView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.shiView.shimmering = YES;
}


-(void)setArray:(NSArray *)array{
    _array = array;
    [self.activity stopAnimating];
    self.upComingArray = nil;
    self.upComeingBtn.selected = NO;
    if (self.upComeingBtn.selected) {
        self.upComeingBtn.userInteractionEnabled = NO;
    }else{
        self.upComeingBtn.userInteractionEnabled = YES;
    }
    [self.collectionView reloadData];
    
}
-(NSArray *)upComingArray{
    if (!_upComingArray) {
        _upComingArray = [NSArray new];
    }
    return _upComingArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self webView];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    self.collectionView.alwaysBounceVertical = YES;
    
    
    self.collectionView.bounces = NO;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"PKQMovieViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Identifierhead"];
     [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"123"];
    
    //设置每个item之间的距离
    [self viewWillTransitionToSize:self.view.frame.size withTransitionCoordinator:nil];
    
    //加入旋转提示
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.color = PKQLoveColor;
    self.activity = activity;
    [activity startAnimating];
    [self.view addSubview:activity];
    [activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.collectionView);
    }];
    
}
//布局
-(instancetype)init{
    //流水式布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // cell的大小
    layout.itemSize = CGSizeMake(90, 175);
    self = [super initWithCollectionViewLayout:layout];
    return self;
}

//当屏幕旋转尺寸改变的时候调用
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionViewLayout;
    int cols = 3;
    CGFloat inset = (size.width - cols*layout.itemSize.width)/(cols+1);
    //设置外边距
    layout.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset);
    //设置每一行的边距
    layout.minimumLineSpacing = inset;
}


#pragma mark <UICollectionViewDataSource>

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (!self.array) {
        [self.activity startAnimating];
    }else{
        [self.activity stopAnimating];
    }
    if (section == 0) {
        return self.array.count;
    }else{
        return self.upComingArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        PKQMovieViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        PKQReleas *releas = self.array[indexPath.row];
        cell.movie = releas;
        return cell;
    }else{
         PKQMovieViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        PKQUpMovieEntriesModel *entrie = self.upComingArray[indexPath.row];
        cell.upMovie = entrie;
        return cell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
//配置尾部视图
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (self.array && !self.isFood) {
        return section == 0 ? CGSizeMake(0, 50) :CGSizeMake(0, 300);
    }else{
        return CGSizeZero;
    }
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 ) {
        UICollectionReusableView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"123" forIndexPath:indexPath];
        FBShimmeringView *view = [FBShimmeringView new];
        self.shiView = view;
        [footView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
        }];
        if (self.upComeingBtn.selected == NO) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn addTarget:self action:@selector(getUpcoming:) forControlEvents:UIControlEventTouchUpInside];
            btn.backgroundColor = PKQLoveColor;
            [btn setTintColor:PKQColor(183, 190, 199)];
            [btn setTitle:@"即将上映的电影" forState:UIControlStateNormal];
            view.contentView = btn;
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(footView);
                make.left.mas_equalTo(10);
                make.right.mas_equalTo(-10);
                make.height.mas_equalTo(30);
            }];
            self.upComeingBtn = btn;
        }
        UIActivityIndicatorView *activity  = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [view addSubview:activity];
        [activity mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(footView);
            make.right.mas_equalTo(-18);
        }];
        activity.color = [UIColor whiteColor];
        self.upActivity = activity;
        view.shimmering = YES;
        return footView;
    }else{
        UICollectionReusableView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Identifierhead" forIndexPath:indexPath];
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor blueColor];
        [footView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
             make.edges.mas_equalTo(0);
        }];
        
        [view addSubview:self.webView];
        view.clipsToBounds = YES;
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        return footView;
    }
}
/*按钮的点击事件*/
-(void)getUpcoming:(UIButton*)btn{
    //发送请求
    //http://api.douban.com/v2/movie/coming?
//    alt=json&
//    apikey=0df993c66c0c636e29ecbb5344252a4a&
//    app_name=doubanmovie&client=e%3AiPhone8%2C2%7Cy%3AiPhone%20OS_9.0.2%7Cs%3Amobile%7Cf%3Adoubanmovie_2%7Cv%3A3.6.7%7Cm%3A%E8%B1%86%E7%93%A3%E7%94%B5%E5%BD%B1%7Cudid%3A2f6386d033b0a1f01f6a32b4db14558ccc4abe57&
//    douban_udid=c3a8887c60f551117c1859548c56ea60f35b6295&
//    start=0&
//    udid=2f6386d033b0a1f01f6a32b4db14558ccc4abe57&
//    version=2
    [self.upActivity startAnimating];
    btn.selected = YES;
    NSString *str = @"http://api.douban.com/v2/movie/coming";
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"alt"] = @"json";
    dict[@"apikey"] = @"0df993c66c0c636e29ecbb5344252a4a";
    dict[@"app_name"] = @"doubanmovie";
    dict[@"client"] = @"e%3AiPhone8%2C2%7Cy%3AiPhone%20OS_9.0.2%7Cs%3Amobile%7Cf%3Adoubanmovie_2%7Cv%3A3.6.7%7Cm%3A%E8%B1%86%E7%93%A3%E7%94%B5%E5%BD%B1%7Cudid%3A2f6386d033b0a1f01f6a32b4db14558ccc4abe57";
    dict[@"douban_udid"] = @"c3a8887c60f551117c1859548c56ea60f35b6295";
    dict[@"udid"] = @"2f6386d033b0a1f01f6a32b4db14558ccc4abe57";
    dict[@"version"] = @"2";
    [[AFHTTPRequestOperationManager manager] GET:str parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        PKQUpMovieModel *upMovie = [PKQUpMovieModel objectWithKeyValues:responseObject];
        self.upComingArray = upMovie.entries;
        [self.collectionView reloadData];
        [self.upActivity stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //错误信息
        NSLog(@"error %@",error);
        [MBProgressHUD showError:@"网络有问题，请稍后再试" toView:self.view];
    }];

}




@end
