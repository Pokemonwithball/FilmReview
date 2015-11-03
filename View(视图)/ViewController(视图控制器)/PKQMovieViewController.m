//
//  PKQMovieViewController.m
//  FilmReview
//
//  Created by tarena on 15/10/19.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "PKQMovieViewController.h"
#import "PKQScrollView.h"
#import "PKQReleaseViewController.h"
#import "UIView+AutoLayout.h"
#import "Masonry.h"
#import "PKQTool.h"
@interface PKQMovieViewController ()<UITableViewDelegate,UITableViewDataSource>
/*滚动视图的内容数组*/
@property (strong,nonatomic) NSArray* scrollArray;
//上映电影
@property (weak,nonatomic) PKQReleaseViewController *releaseMovie;

@end

@implementation PKQMovieViewController
-(PKQReleaseViewController *)releaseMovie{
    if (!_releaseMovie) {
        PKQReleaseViewController *rele = [[PKQReleaseViewController alloc]init];
        self.releaseMovie = rele;
        [self.view addSubview:self.releaseMovie.view];
        [self.releaseMovie.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(149);
            make.left.equalTo(self.view).with.offset(0);
            make.bottom.equalTo(self.view).with.offset(0);
            make.right.equalTo(self.view).with.offset(0);
        }];
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


-(void)viewDidLoad{
    [super viewDidLoad];
    
    //当前屏幕的宽度,设置滚动条
    CGFloat scrollW = [UIScreen mainScreen].bounds.size.width;
    CGFloat scrollH = 85;
    self.scrollArray = @[@"pkq1",@"pkq2",@"pkq3"];
    PKQScrollView *scrollView = [[PKQScrollView alloc]initWithFrame:CGRectMake(0, 64, scrollW, scrollH)];
    scrollView.scrollArray = self.scrollArray;
    //创建个view占有那个区域，不然的滚动条会不正常
    UIView *view = [[UIView alloc]init];
    view.frame  =CGRectMake(0, 64, scrollW, scrollH);
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [self.view addSubview:scrollView];
    
    
    //设置导航栏上面的城市选择
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"城市" style:UIBarButtonItemStyleDone target:self action:@selector(changCiry:)];
    
    UITableView *table = [[UITableView alloc]init];
    table.frame = CGRectMake(0,0, 75, 300);
    table.backgroundColor = [UIColor whiteColor];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    self.releaseMovie.array = self.scrollArray;
   
}



#pragma mark-tableView的代理
-(void)changCiry:(UIBarButtonItem*)item{
 
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    cell.textLabel.text = @"1";
    
    return cell;
}








@end
