//
//  PKQViewEvaluationableViewController.m
//  FilmReview
//
//  Created by tarena on 15/10/23.
//  Copyright © 2015年 tarena. All rights reserved.
//http://api.douban.com/v2/movie/subject/1866473/comments
//?alt=json&
//apikey=0df993c66c0c636e29ecbb5344252a4a&
//app_name=doubanmovie&
//client=e%3AiPhone8%2C2%7Cy%3AiPhone%20OS_9.0.2%7Cs%3Amobile%7Cf%3Adoubanmovie_2%7Cv%3A3.6.7%7Cm%3A%E8%B1%86%E7%93%A3%E7%94%B5%E5%BD%B1%7Cudid%3A2f6386d033b0a1f01f6a32b4db14558ccc4abe57&
//count=100&
//douban_udid=c3a8887c60f551117c1859548c56ea60f35b6295&
//start=0&
//udid=2f6386d033b0a1f01f6a32b4db14558ccc4abe57&
//version=2


#import "PKQViewEvaluationableViewController.h"
#import "PKQMoviesModel.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "PKQCommentCell.h"
#import "PKQConst.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
#import "Masonry.h"
@interface PKQViewEvaluationableViewController ()
@property (assign,nonatomic) NSInteger count;
@property (assign,nonatomic) NSInteger start;
@property (strong,nonatomic) NSMutableArray *commentArray;
@end

@implementation PKQViewEvaluationableViewController

-(NSMutableArray *)commentArray{
    if (!_commentArray) {
        _commentArray = [NSMutableArray new];
    }
    return _commentArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PKQCommentCell" bundle:nil] forCellReuseIdentifier:@"pkq"];
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMore)];
     self.count = 20;
    [self refresh];
   
}
/*刷新*/
-(void)refresh{
    
    self.start = 0;
    NSString *path = [NSString stringWithFormat:@"http://api.douban.com/v2/movie/subject/%@/comments",self.dbId];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"alt"] = @"json";
    dict[@"apikey"] = @"0df993c66c0c636e29ecbb5344252a4a";
    dict[@"app_name"] = @"doubanmovie";
    dict[@"client"] = @"e%3AiPhone8%2C2%7Cy%3AiPhone%20OS_9.0.2%7Cs%3Amobile%7Cf%3Adoubanmovie_2%7Cv%3A3.6.7%7Cm%3A%E8%B1%86%E7%93%A3%E7%94%B5%E5%BD%B1%7Cudid%3A2f6386d033b0a1f01f6a32b4db14558ccc4abe57";
    dict[@"douban_udid"] = @"c3a8887c60f551117c1859548c56ea60f35b6295";
    dict[@"udid"] = @"2f6386d033b0a1f01f6a32b4db14558ccc4abe57";
    dict[@"version"] = @"2";
    dict[@"start"] = @(self.start);
    dict[@"count"] = @(self.count);
    
//    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    activity.color = PKQLoveColor;
//    [activity startAnimating];
//    [self.view addSubview:activity];
//    [activity mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(self.view);
//    }];
    [[AFHTTPRequestOperationManager manager] GET:path parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        PKQMoviesCommentsModel *comments = [PKQMoviesCommentsModel objectWithKeyValues:responseObject];
        if (self.start == 0) {
            [self.commentArray removeAllObjects];
        }
        [self.commentArray addObjectsFromArray:comments.comments];
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
//        [activity stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络有问题，请稍后再试" toView:self.view];
    }];
}
-(void)getMore{
    self.start = self.start+self.count;
    NSString *path = [NSString stringWithFormat:@"http://api.douban.com/v2/movie/subject/%@/comments",self.dbId];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"alt"] = @"json";
    dict[@"apikey"] = @"0df993c66c0c636e29ecbb5344252a4a";
    dict[@"app_name"] = @"doubanmovie";
    dict[@"client"] = @"e%3AiPhone8%2C2%7Cy%3AiPhone%20OS_9.0.2%7Cs%3Amobile%7Cf%3Adoubanmovie_2%7Cv%3A3.6.7%7Cm%3A%E8%B1%86%E7%93%A3%E7%94%B5%E5%BD%B1%7Cudid%3A2f6386d033b0a1f01f6a32b4db14558ccc4abe57";
    dict[@"douban_udid"] = @"c3a8887c60f551117c1859548c56ea60f35b6295";
    dict[@"udid"] = @"2f6386d033b0a1f01f6a32b4db14558ccc4abe57";
    dict[@"version"] = @"2";
    dict[@"start"] = @(self.start);
    dict[@"count"] = @(self.count);
    
    [[AFHTTPRequestOperationManager manager] GET:path parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        PKQMoviesCommentsModel *comments = [PKQMoviesCommentsModel objectWithKeyValues:responseObject];
        if (self.start == 0) {
            [self.commentArray removeAllObjects];
        }
        [self.commentArray addObjectsFromArray:comments.comments];
        [self.tableView.footer endRefreshing];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络有问题，请稍后再试" toView:self.view];
    }];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PKQCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pkq" forIndexPath:indexPath];
    cell.comment = self.commentArray[indexPath.row];
    
    return cell;
}

kRemoveCellSeparator
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PKQMoviesPopular_commentsModel *comments = self.commentArray[indexPath.row];
    NSString *str = comments.content;
    //根据 字符串的内容来获取高度
    NSDictionary *strAttrbutes = @{
                                   NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGRect newFrame = [str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:strAttrbutes context:nil];
    return newFrame.size.height+85;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
