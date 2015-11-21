//
//  PKQScrollViewController.m
//  FilmReview
//
//  Created by tarena on 15/10/23.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQScrollViewController.h"
#import "Masonry.h"
#import "PKQConst.h"
#import "UMSocial.h"
@interface PKQScrollViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>
@property (strong,nonatomic)UIActivityIndicatorView* activity;
@property (strong,nonatomic)UIButton *backButton;
@property (strong,nonatomic)UIView *headView;
@property (strong,nonatomic)UIButton *selectBtn;
//按钮下面的线
@property (strong,nonatomic)UIView *lineView;
//按钮数组
@property (strong,nonatomic)NSMutableArray* btns;

@end

@implementation PKQScrollViewController
-(NSArray *)btns{
    if (!_btns) {
        _btns = [NSMutableArray new];
    }
    return _btns;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = PKQLoveColor;
    }
    return _lineView;
}

-(UIView *)headView{
    if (!_headView) {
        _headView = [UIView new];
        _headView.backgroundColor = [UIColor whiteColor];
        NSArray *btnNames =@[@"详情",@"剧照",@"短评",@"长评"];
        for (int i=0; i<btnNames.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:btnNames[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [btn setTitleColor:PKQLoveColor forState:UIControlStateSelected];
            [_headView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(kBtnW,kBtnH));
                make.left.mas_equalTo(10+i*kBtnW);
                make.centerY.mas_equalTo(0);
            }];
            [btn addTarget:self action:@selector(headBtnUpInside:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                btn.selected = YES;
                self.selectBtn = btn;
            }
            [self.btns addObject:btn];
        }
        //增加了头部按钮下面的线
        [_headView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.selectBtn);
            make.width.mas_equalTo(kBtnW-30);
            make.height.mas_equalTo(2);
            make.top.mas_equalTo(self.selectBtn.mas_bottom).mas_equalTo(0);
        }];
        
        
    }
    return _headView;
}
//点击了头部视图的按钮
-(void)headBtnUpInside:(UIButton*)btn{
    self.selectBtn.selected = NO;
    btn.selected = YES;
    self.selectBtn = btn;
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.selectBtn);
        make.width.mas_equalTo(kBtnW-30);
        make.height.mas_equalTo(2);
        make.top.mas_equalTo(self.selectBtn.mas_bottom).mas_equalTo(0);
    }];
    //改变下面的滚动视图控制器
    NSUInteger select = [self.btns indexOfObject:btn];
    [self changeWithSelectBtn:select];
}
//根据按钮点击来改变展示页面
-(void)changeWithSelectBtn:(NSUInteger)select{
    //判断页面是在前还是在后
    NSInteger direction = 0;
   NSUInteger nowSelect = [self.controllers indexOfObject:self.pageVC.viewControllers.firstObject];
    direction =  (nowSelect > select ? 1:0);
    
    UIViewController *vc = self.controllers[select];
    
    //切换当前页面
    [self.pageVC setViewControllers:@[vc] direction:direction animated:YES completion:nil];
    
}



-(void)setMovie:(PKQMoviesModel *)movie{
    _movie = movie;
    self.pageVC = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    self.pageVC.dataSource = self;
    self.pageVC.delegate = self;
    [self addChildViewController:self.pageVC];
    [self.view addSubview:self.pageVC.view];
    [self.pageVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.edges.mas_equalTo(self.view);
        make.top.mas_equalTo(64+kBtnH+4);
        make.bottom.mas_equalTo(-44);
        make.left.right.mas_equalTo(0);
    }];
    [self.pageVC setViewControllers:@[self.controllers.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    
    
    [self.activity stopAnimating];
    
    self.idnVC.movie = movie;
    self.imgVC.movie = movie;
    self.elnVC.dbId = movie.dbId;
    self.moreVC.dbId = movie.dbId;
}

-(PKQIntroductionViewController *)idnVC{
    if (!_idnVC) {
        _idnVC = [[PKQIntroductionViewController alloc]initWithNibName:@"PKQIntroductionViewController" bundle:nil];
    }
    return _idnVC;
}
-(PKQImageCollectionViewController *)imgVC{
    if (!_imgVC) {
//        _imgVC = [[PKQImageCollectionViewController alloc]initWithNibName:@"PKQImageCollectionViewController" bundle:nil];
        _imgVC = [[PKQImageCollectionViewController alloc]init];
    }
    return _imgVC;
}
-(PKQViewEvaluationableViewController *)elnVC{
    if (!_elnVC) {
        _elnVC = [[PKQViewEvaluationableViewController alloc]initWithNibName:@"PKQViewEvaluationableViewController" bundle:nil];
    }
    return _elnVC;
}
-(PKQMoreEvaluationTableViewController *)moreVC{
    if (!_moreVC) {
        _moreVC = [[PKQMoreEvaluationTableViewController alloc]initWithNibName:@"PKQMoreEvaluationTableViewController" bundle:nil];
    }
    return _moreVC;
}

-(NSArray *)controllers{
    if (!_controllers) {
        _controllers = @[self.idnVC,self.imgVC,self.elnVC,self.moreVC];
    }
    return _controllers;

}

//传入视图控制器
- (instancetype)initWithControllers{
    if (self = [super init]) {
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    //加入头视图
    [self.view addSubview:self.headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kBtnH+4);
    }];
    
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:self.movieName style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    UIButton *fenxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fenxBtn setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    [fenxBtn setImage:[UIImage imageNamed:@"icon_share_highlighted"] forState:UIControlStateHighlighted];
    [fenxBtn addTarget:self action:@selector(fenx) forControlEvents:UIControlEventTouchUpInside];
    fenxBtn.frame = CGRectMake(0, 0, 60, 60);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:fenxBtn];
    
    //旋转提示
    self.activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activity.color = PKQLoveColor;
    [self.activity startAnimating];
    [self.view addSubview:self.activity];
    [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];
    
    
    //判断推出的的有没有导航栏控制器
    if (self.navigationController == nil) {
        UIView *view = [UIView new];
        view.backgroundColor = PKQColor(246, 246, 246);
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(63);
        }];
        UIView *linView = [UIView new];
        linView.backgroundColor = PKQColor(207, 207, 207);
        [self.view addSubview:linView];
        [linView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(63);
            make.right.left.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        UIButton *button = [UIButton buttonWithType:1];
        NSString *str = self.movieName;
        [button setTitle:str forState:UIControlStateNormal];
        [button addTarget:self action:@selector(presentBack) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.bottom.mas_equalTo(-5);
        }];
        self.backButton = button;
    }
    //判断有没有下面的bar
    if (self.tabBarController == nil) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blue"]];
        [self.view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.left.mas_equalTo(0);
            make.height.mas_equalTo(44);
        }];
    }
    
}
//分享按钮
-(void)fenx{
    NSString *str = [NSString stringWithFormat:@"兔子影评的电影详细http://movie.douban.com/subject/%@/?from=showing",self.movie.dbId];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"563b586767e58e04fa001fb5"
                                      shareText:str
                                     shareImage:[UIImage imageNamed:@"icon.png"]
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,UMShareToSina]
                                       delegate:nil];
}
//实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}



//搜索推出返回
-(void)presentBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//其他地方推出返回
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSInteger index = [self.controllers indexOfObject:viewController];
    if (index == 0) {
        return nil;
    }
    return self.controllers[index-1];
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSInteger index = [self.controllers indexOfObject:viewController];
    if (index == self.controllers.count-1) {
        return nil;
    }
    return self.controllers[index+1];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    if (completed) {
        //获取当前页面的索引值
        NSInteger select = [self.controllers indexOfObject:pageViewController.viewControllers.firstObject];
        self.selectBtn.selected = NO;
        self.selectBtn = self.btns[select];
        self.selectBtn.selected = YES;
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.selectBtn);
            make.width.mas_equalTo(kBtnW-30);
            make.height.mas_equalTo(2);
            make.top.mas_equalTo(self.selectBtn.mas_bottom).mas_equalTo(0);
        }];
    }
}


@end
