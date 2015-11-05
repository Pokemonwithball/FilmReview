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

@interface PKQCinemaDetailViewController ()
@property (weak, nonatomic) IBOutlet UIButton *mapBtn;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *huiBtn;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *movieIcnView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (assign,nonatomic) BOOL barCollect;
@property (strong,nonatomic) NSArray *allMovies;
@property (strong,nonatomic) NSArray *allMoviesIcon;
@end

@implementation PKQCinemaDetailViewController
-(void)setStr:(NSString *)str{
    _str = str;
    if (self.str.length <=2) {
        [self.huiBtn setImage:[UIImage imageNamed:@"tabbar_item_store"] forState:UIControlStateNormal];
        self.huiBtn.userInteractionEnabled = NO;
    }

}

-(void)setAllMovies:(NSArray *)allMovies{
    _allMovies = allMovies;
    self.allMoviesIcon = [NSArray new];
    for (PKQCinemaMovieEntriesSubjectModel* subject in allMovies) {
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.model.title;
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
    
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(collection:) image:@"smallcollect" highImage:@"smallcollect"];
    self.barCollect = NO;
    //设置3个按钮的形状
    self.mapBtn.layer.cornerRadius = 17.5;
    self.mapBtn.layer.masksToBounds = YES;
    self.phoneBtn.layer.cornerRadius = 17.5;
    self.phoneBtn.layer.masksToBounds = YES;
    self.huiBtn.layer.cornerRadius = 17.5;
    self.huiBtn.layer.masksToBounds = YES;
    
    //发送网络请求 获取该电影院正在上映的电影
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
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:path parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        PKQCinemaMovieModel *model = [PKQCinemaMovieModel objectWithKeyValues:responseObject];
        //超级一个数组 然后把全部的电影信息放进去
        self.allMovies = [NSArray new];
        self.allMovies = model.entries;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"-------%@",error);
        [MBProgressHUD showError:@"网络有问题，请稍后再试" toView:self.view];
    }];
    
}


//当程序这个界面退出的生活释放
- (void)didEnterBackground:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];
}




//收藏
-(void)collection:(UIBarButtonItem*)bar{
    if (self.barCollect) {
        //增加个警告框
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"你确定要从常去影院中删除？" message:@"皮卡丘" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertC animated:YES completion:nil];
        UIAlertAction *sureAction=[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [MBProgressHUD showSuccess:@"取消收藏成功" toView:self.view];
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
    view.text = self.str;
    view.frame = CGRectMake(0, 0, kWindowH*0.4, kWindowH*0.4);
    
    [[KGModal sharedInstance] showWithContentView:view andAnimated:YES];
}





@end
