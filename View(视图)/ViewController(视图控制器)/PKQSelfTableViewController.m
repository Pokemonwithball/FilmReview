//
//  PKQSelfTableViewController.m
//  FilmReview
//
//  Created by tarena on 15/10/19.
//  Copyright (c) 2015年 tarena. All rights reserved.
//19 GET http://api.douban.com/v2/movie/top250?alt=json&apikey=0df993c66c0c636e29ecbb5344252a4a&app_name=doubanmovie&client=e%3AiPhone8%2C2%7Cy%3AiPhone%20OS_9.0.2%7Cs%3Amobile%7Cf%3Adoubanmovie_2%7Cv%3A3.6.7%7Cm%3A%E8%B1%86%E7%93%A3%E7%94%B5%E5%BD%B1%7Cudid%3A2f6386d033b0a1f01f6a32b4db14558ccc4abe57&count=10&douban_udid=c3a8887c60f551117c1859548c56ea60f35b6295&random=1&start=0&udid=2f6386d033b0a1f01f6a32b4db14558ccc4abe57&version=2

#import "PKQSelfTableViewController.h"
#import "PKQConst.h"
#import "Masonry.h"
@interface PKQSelfTableViewController ()

@end

@implementation PKQSelfTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView* meView = [[UIView alloc]init];
    meView.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,80);
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noImage"]];
    [meView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
    }];
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = @"皮卡丘";
    nameLabel.font = [UIFont systemFontOfSize:18];
    [meView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(imageView.mas_right).mas_equalTo(10);
    }];
    
    self.tableView.tableHeaderView = meView;
    self.tableView.tableFooterView = [UIView new];
    
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"我看";
        self.tabBarItem.image=[UIImage imageNamed:@"tabbar_item_more"];
        //self.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbar_selected_back"];
        //self.tabBarController.tabBar.selectionIndicatorImage = ~~~
        
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 4;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pkq"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pkq"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"我的电影票";
            break;
        case 1:
            cell.textLabel.text = @"我的";
            break;
        case 2:
            cell.textLabel.text = @"优惠券";
            break;
        case 3:
            cell.textLabel.text = @"我的电影";
            break;
        case 4:
            cell.textLabel.text = @"猜你喜欢";
            break;
        case 5:
            cell.textLabel.text = @"豆瓣电影Top249";
            //http://api.douban.com/v2/movie/top250?alt=json&apikey=0df993c66c0c636e29ecbb5344252a4a&app_name=doubanmovie&client=e%3AiPhone8%2C2%7Cy%3AiPhone%20OS_9.0.2%7Cs%3Amobile%7Cf%3Adoubanmovie_2%7Cv%3A3.6.7%7Cm%3A%E8%B1%86%E7%93%A3%E7%94%B5%E5%BD%B1%7Cudid%3A2f6386d033b0a1f01f6a32b4db14558ccc4abe57&count=10&douban_udid=c3a8887c60f551117c1859548c56ea60f35b6295&random=1&start=0&udid=2f6386d033b0a1f01f6a32b4db14558ccc4abe57&version=2
            break;
        case 6:
            cell.textLabel.text = @"账号设置";
            break;
        case 7:
            cell.textLabel.text = @"应用推荐";
            break;
        default:
            break;
    }
    
    return cell;
}
kRemoveCellSeparator
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
           
            break;
        case 4:
           
            break;
        case 5:
            
            //http://api.douban.com/v2/movie/top250?alt=json&apikey=0df993c66c0c636e29ecbb5344252a4a&app_name=doubanmovie&client=e%3AiPhone8%2C2%7Cy%3AiPhone%20OS_9.0.2%7Cs%3Amobile%7Cf%3Adoubanmovie_2%7Cv%3A3.6.7%7Cm%3A%E8%B1%86%E7%93%A3%E7%94%B5%E5%BD%B1%7Cudid%3A2f6386d033b0a1f01f6a32b4db14558ccc4abe57&count=10&douban_udid=c3a8887c60f551117c1859548c56ea60f35b6295&random=1&start=0&udid=2f6386d033b0a1f01f6a32b4db14558ccc4abe57&version=2
            break;
        case 6:
            
            break;
        case 7:
            
            break;
        default:
            break;
    }
}





@end
