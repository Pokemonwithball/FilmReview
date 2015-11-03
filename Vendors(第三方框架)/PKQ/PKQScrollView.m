//
//  PKQScrollView.m
//  PKQScrollView
//
//  Created by tarena on 15/10/19.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "PKQScrollView.h"
@interface PKQScrollView()<UIScrollViewDelegate>
//第几页
@property (assign,nonatomic) NSInteger scrollIndex;
@property (strong,nonatomic) UIScrollView *scrollView;

@end
@implementation PKQScrollView
//在设置数组的时候执行
-(void)setScrollArray:(NSArray *)scrollArray{
    _scrollArray = scrollArray;
    CGFloat scrollW = self.frame.size.width;
    CGFloat scrollH = self.frame.size.height;
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.frame = CGRectMake(0, 0, scrollW, scrollH);
    scrollView.contentSize = CGSizeMake(scrollW*self.scrollArray.count, scrollH);
    for (int i=0; i<self.scrollArray.count; i++) {
        UIButton *button = [[UIButton alloc]init];
        [button setBackgroundImage:[UIImage imageNamed:self.scrollArray[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(goWeb:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(scrollW*i, 0, scrollW, scrollH);
        button.tag = i;
        
        //设置滚动视图不可以弹跳
        scrollView.bounces=NO;
        scrollView.delegate = self;
        //设置滚动视图整页滚动
        scrollView.pagingEnabled=YES;
        //设置滚动视图的水平滚动提示不可见
        scrollView.showsHorizontalScrollIndicator=NO;
        //取消用户交互
        //        scrollView.userInteractionEnabled = NO;
        
        [scrollView addSubview:button];
    }
    self.scrollView = scrollView;
    [self addSubview:scrollView];
    
    self.backgroundColor = [UIColor redColor];
    //开启一个定时器
    [self startPlayingTimer];

}
//启动计时器,加入一个定时器来计算时间
- (void)startPlayingTimer
{
    [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
}
//计时器每秒调用的方法
- (void)updateTimer:(NSTimer *)timer
{
    CGFloat mainW = self.frame.size.width;
    self.scrollIndex++;
    CGFloat scrollNewW = self.scrollIndex*mainW;
    //把上面的scoller移动起来
    if (scrollNewW/mainW >= self.scrollArray.count) {
        scrollNewW = 0;
        self.scrollIndex = 0;
        [UIView animateWithDuration:1.0 animations:^{
            self.scrollView.contentOffset = CGPointMake(scrollNewW, 0);
        }];
    }else{
        [UIView animateWithDuration:1.0 animations:^{
            self.scrollView.contentOffset = CGPointMake(scrollNewW, 0);
        }];
    }
    
    
}
-(void)goWeb:(UIButton*)button{
    switch (button.tag) {
        case 0:
            NSLog(@"皮卡丘");
            break;
        case 1:
            NSLog(@"皮卡丘2");
            break;
        case 2:
            NSLog(@"皮卡丘3");
            break;
        default:
            break;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0){
    CGPoint point = scrollView.contentOffset;
    self.scrollIndex = point.x/self.frame.size.width;
}







@end
