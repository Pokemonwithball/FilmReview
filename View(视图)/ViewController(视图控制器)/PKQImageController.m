//
//  PKQImageController.m
//  FilmReview
//
//  Created by tarena on 15/10/27.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQImageController.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

@interface PKQImageController ()

@end

@implementation PKQImageController

-(void)setImage:(NSString *)image{
    _image = image;
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [UIImageView new];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.image]];
    CGFloat imageH = [UIScreen mainScreen].bounds.size.width*2/3;
    CGFloat imageW = [UIScreen mainScreen].bounds.size.width;
    imageView.frame = CGRectMake(0,([UIScreen mainScreen].bounds.size.height-imageH)/2, imageW, imageH);
    [self.view addSubview:imageView];
}
-(void)setItem:(NSInteger)item{
    _item = item;
    self.title = [NSString stringWithFormat:@"%ld of %ld",self.item+1,self.allItem];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}



@end
