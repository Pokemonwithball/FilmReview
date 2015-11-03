//
//  PKQCommentCell.m
//  FilmReview
//
//  Created by tarena on 15/10/27.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQCommentCell.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+MJ.h"
@interface PKQCommentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *ionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *commentIcon;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (assign,nonatomic) NSInteger count;

@end

@implementation PKQCommentCell

-(void)setCount:(NSInteger)count{
    _count = count;
    self.commentLabel.text = [NSString stringWithFormat:@"%ld",count];
}

-(void)setComment:(PKQMoviesPopular_commentsModel *)comment{
    _comment = comment;
    [self.ionView sd_setImageWithURL:[NSURL URLWithString:comment.author.avatar] placeholderImage:[UIImage imageNamed:@"noImage"]];
    self.titleLabel.text = comment.author.name;
    NSInteger rating = [comment.rating[@"value"]integerValue];
    
    self.commentIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"appraisal%ld",rating*2]];
    self.count = [comment.useful_count integerValue];
    
    self.contentLabel.text = comment.content;
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
//投票
- (IBAction)setGood:(UIButton *)sender {
    if (sender.selected == NO) {
        [MBProgressHUD showSuccess:@"投票成功" ];
        sender.selected =YES;
        self.count +=1;
        NSLog(@"发出投票通知");
    }else{
        [MBProgressHUD showError:@"已经投过票了!"];
    }
}

@end
