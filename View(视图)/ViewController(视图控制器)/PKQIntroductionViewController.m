//
//  PKQIntroductionViewController.m
//  FilmReview
//
//  Created by tarena on 15/10/23.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQIntroductionViewController.h"
#import "PKQHeadViewController.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "PKQStartTableViewCell.h"
#import "PKQPopular_commentsTableViewCell.h"
#import "PKQDirectorViewController.h"
#import "PKQCinemaViewController.h"
#import "PKQBuyMovieViewController.h"

@interface PKQIntroductionViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic)PKQHeadViewController* headView;
@property (assign,nonatomic)NSInteger directorNum;
@property (assign,nonatomic)NSInteger castNum;
@property (assign,nonatomic)NSInteger popularNum;
@property (assign,nonatomic)NSInteger number;
@end

@implementation PKQIntroductionViewController

-(PKQHeadViewController *)headView{
    if (!_headView) {
        _headView = [[PKQHeadViewController alloc]initWithNibName:@"PKQHeadViewController" bundle:nil];
        _headView.view.autoresizingMask = UIViewAutoresizingNone;
        //设置里面button的方法
        [_headView.wantSeeBtn addTarget:self action:@selector(wentSee:) forControlEvents:UIControlEventTouchUpInside];
        
        [_headView.didSeeBtn addTarget:self action:@selector(didSee:) forControlEvents:UIControlEventTouchUpInside];
        
        [_headView.buyMovie addTarget:self action:@selector(buyMovie:) forControlEvents:UIControlEventTouchUpInside];
        
        [_headView.ImageBtn addTarget:self action:@selector(seeMovie:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    [self addChildViewController:_headView];
    return _headView;
}
-(void)setMovie:(PKQMoviesModel *)movie{
    _movie = movie;
    self.headView.movie = movie;
    //尾部视图
    UIWebView *webView = [[UIWebView alloc]init];
    NSString *str = [NSString stringWithFormat:@"http://www.douban.com/doubanapp/misc/movie_app_subject?doubanapp_version=&subject_id=%@",self.movie.dbId];
    NSURL *url=[NSURL URLWithString:str];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    webView.frame = CGRectMake(10, 0,[UIScreen mainScreen].bounds.size.width-20, 400);
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 400);
    [view addSubview:webView];
    
    self.tableView.tableFooterView = view;
    //    self.tableView.tableFooterView = webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headView.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300);
    
    UIButton *titleBtn = [[UIButton alloc]init];
    titleBtn.backgroundColor = [UIColor clearColor];
    [self.headView.view addSubview:titleBtn];
    [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(95);
    }];
    [titleBtn addTarget:self action:@selector(titleMore:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableHeaderView = self.headView.view;
    //把线去掉
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:@"PKQStartTableViewCell" bundle:nil] forCellReuseIdentifier:@"pkq"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PKQPopular_commentsTableViewCell" bundle:nil] forCellReuseIdentifier:@"pkq2"];
}

#pragma mark - tableViewHead

-(void)wentSee:(UIButton*)btn{
    NSLog(@"我想看");
}
-(void)didSee:(UIButton*)btn{
    NSLog(@"看过了");
}
//买电影票
-(void)buyMovie:(UIButton*)btn{
    
    PKQBuyMovieViewController *vc = [[PKQBuyMovieViewController alloc]init];
    vc.dbID = self.movie.dbId;
    vc.movicName = self.movie.title;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)seeMovie:(UIButton*)btn{
    NSLog(@"播放预告片");
}
-(void)titleMore:(UIButton*)btn{
    CGFloat more = self.headView.titleH -100 ;
    if (btn.selected == NO) {
        if (more>0) {
            self.headView.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-40, 300+more+10);
            self.tableView.tableHeaderView = self.headView.view;
            
            [UIView animateWithDuration:1.0 animations:^{
                [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(5);
                    make.right.mas_equalTo(-10);
                    make.bottom.mas_equalTo(-10);
                    make.height.mas_equalTo(115+more);
                }];
                
                [self.headView.dealLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(5);
                    make.left.mas_equalTo(10);
                    make.right.mas_equalTo(-10);
                }];
                btn.selected = YES;
                
            }];
            
            
        }else{
            
        }
    }else{
        if (more>0) {
            self.headView.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-40, 300);
            self.tableView.tableHeaderView = self.headView.view;
            
            [UIView animateWithDuration:1.0 animations:^{
                [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(10);
                    make.right.mas_equalTo(-10);
                    make.bottom.mas_equalTo(-10);
                    make.height.mas_equalTo(95);
                }];
                
                [self.headView.dealLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(10);
                    make.right.mas_equalTo(-10);
                    make.bottom.mas_equalTo(-10);
                }];
                btn.selected = NO;
            }];
        }
        [self.tableView reloadData];
        }
}

#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //导演和演员的数量不固定,下面还有3个评论  所以设置的是固定的tableView
    self.directorNum = (self.movie.directors.count != 0) ? 1:0;
    self.castNum = (self.movie.casts.count <3) ? self.movie.casts.count  :3;
    self.popularNum = (self.movie.popular_comments.count <3) ? self.movie.popular_comments.count :3;
    self.number = self.directorNum + self.castNum;
    return self.directorNum + self.castNum + self.popularNum;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //无限多的判断。。。。改正
    if (indexPath.row<self.directorNum + self.castNum) {
        PKQStartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pkq"];
        if (self.directorNum == 0) {
            PKQMoviesCastsModel *cast = self.movie.casts[indexPath.row];
            cell.cast = cast;
            return cell;
        }else{
            if (indexPath.row == 0) {
                PKQMoviesDirectorsModel *director =self.movie.directors[0];
                cell.director = director;
            }else{
                PKQMoviesCastsModel *cast = self.movie.casts[indexPath.row-1];
                cell.cast = cast;
            }
            return cell;
        }
    }else{
        PKQPopular_commentsTableViewCell *pcell = [tableView dequeueReusableCellWithIdentifier:@"pkq2"];
        PKQMoviesPopular_commentsModel *p = self.movie.popular_comments[indexPath.row-self.directorNum-self.castNum];
        pcell.popular_comments = p;
        pcell.userInteractionEnabled = NO;
        return pcell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<4) {
        return 90;
    }else{
        PKQMoviesPopular_commentsModel *p = self.movie.popular_comments[indexPath.row-4];
        NSString *str = p.content;
        //根据 字符串的内容来获取高度
        NSDictionary *strAttrbutes = @{
                                       NSFontAttributeName:[UIFont systemFontOfSize:15]};
        CGRect newFrame = [str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-20, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:strAttrbutes context:nil];
        return newFrame.size.height+45;
    }
}
//点击事件推出
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.directorNum == 0) {
        if (indexPath.row<3) {
            PKQMoviesCastsModel *cast = self.movie.casts[indexPath.row];
            //推出演员界面
            PKQDirectorViewController *vc = [[PKQDirectorViewController alloc]init];
            vc.movieName = self.movie.title;
            vc.ID =cast.ID;
            [self presentViewController:vc animated:YES completion:nil];
        }else{
            
        }
    }else{
        if (indexPath.row == 0) {
            PKQMoviesDirectorsModel *director =self.movie.directors[0];
            //推出导演界面
            PKQDirectorViewController *vc = [[PKQDirectorViewController alloc]init];
            vc.movieName = self.movie.title;
            vc.ID =director.ID;
            [self presentViewController:vc animated:YES completion:nil];
            
        }else if (indexPath.row <4){
            PKQMoviesCastsModel *cast = self.movie.casts[indexPath.row-1];
            //推出演员界面
            PKQDirectorViewController *vc = [[PKQDirectorViewController alloc]init];
            vc.movieName = self.movie.title;
            vc.ID =cast.ID;
            [self presentViewController:vc animated:YES completion:nil];
        }else{
        }
    }
    
}


@end
