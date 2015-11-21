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
#import "SDImageCache.h"
#import "SMFactory.h"
#import "PKQDLuViewController.h"
#import "PKQDluDetailViewController.h"
#import "UMSocial.h"
#import "PKQMySelfModel.h"

@interface PKQSelfTableViewController ()
@property (strong,nonatomic)UIView *headView;
@property (strong,nonatomic)PKQMySelfModel *mySelf;
@property (strong,nonatomic)UILabel* nameLabel;
@property (strong,nonatomic)UIImageView *headImageView;
@end

@implementation PKQSelfTableViewController
-(UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [UIImageView new];
        _headImageView.layer.cornerRadius = 40;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.borderWidth = 2;
        _headImageView.layer.borderColor = PKQLoveColor.CGColor;
        if (self.mySelf.myImage == nil) {
            self.headImageView.image = [UIImage imageNamed:@"noImage"];
        }else{
            self.headImageView.image = [UIImage imageWithData:self.mySelf.myImage];
        }
//        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.mySelf.myImage] placeholderImage:[UIImage imageNamed:@"noImage"]];
    }
    return _headImageView;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        self.nameLabel.font = [UIFont systemFontOfSize:16];
        self.nameLabel.textColor = PKQLoveColor;
    }
    return _nameLabel;
}

-(PKQMySelfModel *)mySelf{
    if (!_mySelf) {
        _mySelf = [PKQTool defaultSelf];
    }
    return _mySelf;
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    //先获取数据库中登录的对象
    self.mySelf = [PKQSqlit getLogIn];
    
    
    
   
   
    //判断是否成功登录
    if (self.mySelf.logeIn) {
        self.nameLabel.text = self.mySelf.myName;
//        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.mySelf.myImage] placeholderImage:[UIImage imageNamed:@"noImage"]];
        if (self.mySelf.myImage == nil) {
            self.headImageView.image = [UIImage imageNamed:@"noImage"];
        }else{
            self.headImageView.image = [UIImage imageWithData:self.mySelf.myImage];
            NSURL *url = [NSURL URLWithString:[[NSString alloc]initWithData:self.mySelf.myImage encoding:NSUTF8StringEncoding]];
            [self.headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"noImage"]];
        }
    }else{
        self.nameLabel.text = @"登录/注册";
        self.headImageView.image = [UIImage imageNamed:@"noImage"];
    }
    

    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView* meView = [[UIView alloc]init];
    self.headView = meView;
    meView.backgroundColor = PKQColor(239, 239, 244);
    meView.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,120);
   
    
    
    
    [meView addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
    }];

    
    
   
    [meView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.headImageView.mas_bottom).mas_equalTo(10);
    }];

    
    
    
    UIButton *dluBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dluBtn.tag = 300;
    [dluBtn addTarget:self action:@selector(dlu) forControlEvents:UIControlEventTouchUpInside];
    dluBtn.backgroundColor= [UIColor clearColor];
    [meView addSubview:dluBtn];
    [dluBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    

    
    self.tableView.tableHeaderView = meView;
    self.tableView.tableFooterView = [UIView new];
    
}
//登录界面
-(void)dlu{
    //开始没有登录
    if (self.mySelf.logeIn) {
        PKQDluDetailViewController *vc = [[PKQDluDetailViewController alloc]initWithNibName:@"PKQDluDetailViewController" bundle:nil];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
    PKQDLuViewController *vc = [[PKQDLuViewController alloc]initWithNibName:@"PKQDLuViewController" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
    }
}



-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"我的";
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
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"pkq"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 0) {
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
            default:
                break;
        }
    }
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"兔子猜你会喜欢";
                break;
            case 1:
                cell.textLabel.text = @"豆瓣电影Top249";
                //http://api.douban.com/v2/movie/top250?alt=json&apikey=0df993c66c0c636e29ecbb5344252a4a&app_name=doubanmovie&client=e%3AiPhone8%2C2%7Cy%3AiPhone%20OS_9.0.2%7Cs%3Amobile%7Cf%3Adoubanmovie_2%7Cv%3A3.6.7%7Cm%3A%E8%B1%86%E7%93%A3%E7%94%B5%E5%BD%B1%7Cudid%3A2f6386d033b0a1f01f6a32b4db14558ccc4abe57&count=10&douban_udid=c3a8887c60f551117c1859548c56ea60f35b6295&random=1&start=0&udid=2f6386d033b0a1f01f6a32b4db14558ccc4abe57&version=2
                break;
            case 2:
                cell.textLabel.text = @"账号设置";
                break;
            default:
                break;
        }
    }
    if (indexPath.section == 2) {
        cell.textLabel.text = @"清理缓存";
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *num = [NSString stringWithFormat:@"%.3f",[self folderSizeAtPath:cachPath]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@M",[SMFactory removeUnusedZero:num]];

    }
    

    
    return cell;
}
kRemoveCellSeparator
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
               
                break;
            case 1:
                
                break;
            case 2:
               
                break;
            case 3:
               
                break;
            default:
                break;
        }
    }
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                
                break;
            case 1:
               
                break;
            case 2:{
                PKQDluDetailViewController *vc = [[PKQDluDetailViewController alloc]initWithNibName:@"PKQDluDetailViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    }
    if (indexPath.section == 2) {
        [self deleteSomeThing];
    }
}

//清除缓存
- (void)deleteSomeThing{
    NSString *title = NSLocalizedString(@"清理缓存", nil);
    NSString *message = NSLocalizedString(@"清理缓存会导致数据的丢失,确认清理？", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"返回", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"确定", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        return ;
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //清除cache下的文件
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
            for (NSString *p in files) {
                NSError *error;
                NSString *path = [cachPath stringByAppendingPathComponent:p];
                if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                    [[NSFileManager defaultManager]removeItemAtPath:path error:&error];
                }
            }
        });
        [MBProgressHUD showSuccess:@"清理成功"];
        [self.tableView reloadData];
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}




//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}


@end
