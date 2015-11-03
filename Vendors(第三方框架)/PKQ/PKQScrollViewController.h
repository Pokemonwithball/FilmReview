//
//  PKQScrollViewController.h
//  FilmReview
//
//  Created by tarena on 15/10/23.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKQIntroductionViewController.h"
#import "PKQImageCollectionViewController.h"
#import "PKQViewEvaluationableViewController.h"
#import "PKQMoreEvaluationTableViewController.h"
#import "PKQMoviesModel.h"

@interface PKQScrollViewController : UIViewController

@property(nonatomic,strong) NSArray *controllers;
@property (strong,nonatomic) UIPageViewController *pageVC;
@property (strong,nonatomic) PKQMoviesModel* movie;
/*介绍控制器*/
@property (strong,nonatomic) PKQIntroductionViewController *idnVC;
/*图片控制器*/
@property (strong,nonatomic) PKQImageCollectionViewController *imgVC;
/*评价控制器*/
@property (strong,nonatomic) PKQViewEvaluationableViewController *elnVC;
/*影评控制器*/
@property (strong,nonatomic) PKQMoreEvaluationTableViewController *moreVC;

//传入视图控制器
- (instancetype)initWithControllers;
@end
