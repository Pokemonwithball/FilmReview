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
@interface PKQScrollViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>
@property (strong,nonatomic)UIActivityIndicatorView* activity;
@property (strong,nonatomic)UIButton *backButton;
@end

@implementation PKQScrollViewController
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
        make.top.mas_equalTo(64);
        make.bottom.mas_equalTo(-44);
        make.left.right.mas_equalTo(0);
    }];
    [self.pageVC setViewControllers:@[self.controllers.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    if (self.navigationController == nil) {
        [self.backButton setTitle:movie.title forState:UIControlStateNormal];
        
    }else{
        //设置左边返回按钮的文字
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:movie.title style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        self.navigationItem.leftBarButtonItem = item;
    }
    
    
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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
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
        NSString *str = @"返回";
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




@end
