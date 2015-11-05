





//
//  PKQImageCollectionViewController.m
//  FilmReview
//
//  Created by tarena on 15/10/23.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQImageCollectionViewController.h"
#import "AFNetworking.h"
#import "PKQStillsModel.h"
#import "MJExtension.h"
#import "PKQImageCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "PKQConst.h"
#import "MJRefresh.h"
#import "PKQImageController.h"
#import "MBProgressHUD+MJ.h"
@interface PKQImageCollectionViewController () 
@property (strong,nonatomic) NSArray *imageArr;
//当前显示的数量
@property (assign,nonatomic) NSInteger items;
@end

@implementation PKQImageCollectionViewController

static NSString * const reuseIdentifier = @"pkq";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    //发送网络信息
    //    http://api.douban.com/movie/subject/1866473/photos?
    //    alt=json&
    //    apikey=0df993c66c0c636e29ecbb5344252a4a&
    //    app_name=doubanmovie&
    //    client=e%3AiPhone8%2C2%7Cy%3AiPhone%20OS_9.0.2%7Cs%3Amobile%7Cf%3Adoubanmovie_2%7Cv%3A3.6.7%7Cm%3A%E8%B1%86%E7%93%A3%E7%94%B5%E5%BD%B1%7Cudid%3A2f6386d033b0a1f01f6a32b4db14558ccc4abe57&
    //    douban_udid=c3a8887c60f551117c1859548c56ea60f35b6295&
    //    udid=2f6386d033b0a1f01f6a32b4db14558ccc4abe57&
    //    version=2
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"PKQImageCollectionViewCell.h" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    NSString *str = [NSString stringWithFormat:@"http://api.douban.com/movie/subject/%@/photos",self.movie.dbId];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[@"alt"] = @"json";
    dict[@"apikey"] = @"0df993c66c0c636e29ecbb5344252a4a";
    dict[@"app_name"] = @"doubanmovie";
    dict[@"client"] = @"e%3AiPhone8%2C2%7Cy%3AiPhone%20OS_9.0.2%7Cs%3Amobile%7Cf%3Adoubanmovie_2%7Cv%3A3.6.7%7Cm%3A%E8%B1%86%E7%93%A3%E7%94%B5%E5%BD%B1%7Cudid%3A2f6386d033b0a1f01f6a32b4db14558ccc4abe57";
    dict[@"douban_udid"] = @"c3a8887c60f551117c1859548c56ea60f35b6295";
    dict[@"udid"] = @"2f6386d033b0a1f01f6a32b4db14558ccc4abe57";
    dict[@"version"] = @"2";
    
    // 上拉加载更多的
    self.items = 18;
    self.collectionView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.items +=9;
        if (self.items >self.imageArr.count) {
            self.items = self.imageArr.count;
            self.collectionView.footer = nil;
        }
        [self.collectionView.footer endRefreshing];
        [self.collectionView reloadData];
    }];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:str parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        PKQStillsModel *still = [PKQStillsModel objectWithKeyValues:responseObject];
        if (self.items >= still.entry.count) {
            self.items = still.entry.count;
        }
        NSMutableArray *array = [NSMutableArray new];
        for (PKQStillsEntryModel *entry in still.entry) {
            PKQStillsEntryLinkModel *link = entry.link[3];
            [array addObject:link.href];
        }
        self.imageArr =array;
        [self.collectionView reloadData];
        //600 345
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络有问题，请稍后再试" toView:self.view];
    }];
    
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PKQImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    // Do any additional setup after loading the view.
}
//http://img3.douban.com/view/photo/photo/public/p2252402754.jpg

-(instancetype)init{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat inset = 10;
    CGFloat item = 3 ;
    CGFloat width = ([UIScreen mainScreen].bounds.size.width-(item+1)*inset)/item;
    layout.itemSize = CGSizeMake(width, width+10);
    layout.minimumInteritemSpacing = inset;
    layout.minimumLineSpacing = inset;
    layout.sectionInset = UIEdgeInsetsMake(inset,inset,inset,inset);

    
    return [super initWithCollectionViewLayout:layout];
}


#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PKQImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:self.imageArr[indexPath.item]] placeholderImage:[UIImage imageNamed:@"noImage"]];
    // Configure the cell
    return cell;
}

#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PKQImageController *imageVC = [[PKQImageController alloc]init];
    imageVC.image = self.imageArr[indexPath.item];
    imageVC.allItem = self.items;
    imageVC.item = indexPath.item;
    [self.navigationController pushViewController:imageVC animated:YES];
}



@end
