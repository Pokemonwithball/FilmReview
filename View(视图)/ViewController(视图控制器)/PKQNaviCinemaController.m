//
//  PKQNaviCinemaController.m
//  FilmReview
//
//  Created by tarena on 15/11/12.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQNaviCinemaController.h"
#import "PKQCity.h"
#import "PKQNaviCinemaModel.h"
#import "PKQCinemaDetailViewController.h"

@interface PKQNaviCinemaController ()<UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource>
//设置默认城市
@property (strong,nonatomic)NSString *defaultCity;

@property (strong,nonatomic)UIView *allView;
@property (strong,nonatomic)UIPickerView* pickerView;
@property (strong,nonatomic)NSArray *allAreaName;
@property (strong,nonatomic)NSArray *allCityName;
//当前选择的城市
@property (strong,nonatomic)NSString* cityName;
@property (strong,nonatomic)UITableView* tableView;
//遮盖层
@property (strong,nonatomic)UIView *coverView;
//显示当前区域电影院的信息
@property (strong,nonatomic)NSArray *districtCinemaArray;
//该城市全部的电影院信息
@property (strong,nonatomic)NSArray* allCinemaArray;
//各分区的名字
@property (strong,nonatomic)NSArray* allDistrictArray;


@end

@implementation PKQNaviCinemaController




-(NSArray *)districtCinemaArray{
    if (!_districtCinemaArray) {
        _districtCinemaArray = [NSArray new];
    }
    return _districtCinemaArray;
}


-(NSArray *)allDistrictArray{
    if (!_allDistrictArray) {
        _allDistrictArray = [NSArray new];
    }
    return _allDistrictArray;
}

-(NSArray *)allCinemaArray{
    if (!_allCinemaArray) {
        _allCinemaArray = [NSArray new];
    }
    return _allCinemaArray;
}


-(NSString *)defaultCity{
    if (!_defaultCity) {
        _defaultCity = @"北京";
    }
    return _defaultCity;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nothing"]];
        
    }
    return _tableView;
}


-(NSArray *)allAreaName{
    if (!_allAreaName) {
        _allAreaName = [PKQTool province];
    }
    return _allAreaName;
}
-(NSArray *)allCityName{
    if (!_allCityName) {
        _allCityName = [PKQTool cityWith:_allAreaName[0]];
    }
    return _allCityName;
}



-(UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]init];
        _pickerView.delegate = self;
    }
    return _pickerView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.name;
        
    [self setRightNaviItemsWith:@"城市"];
    
    //主要的tableView
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(0);
        make.top.mas_equalTo(20);
        make.bottom.mas_equalTo(-44);
    }];
    //注册
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"pkq"];
    
    //遮盖层
    UIView *coverView = [UIView new];
    coverView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showCoverView)];
    [coverView addGestureRecognizer:tapGR];
    [self.view addSubview:coverView];
    [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    //一开始是隐藏的
    coverView.hidden = YES;
    self.coverView = coverView;
    
    //pickerView和确定按钮
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view];
    CGFloat viewH = kWindowH/2;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWindowW);
        make.height.mas_equalTo(viewH);
        make.bottom.mas_equalTo(-44);
    }];
    self.allView = view;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(getCinemaArea) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = PKQLoveColor;
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(5);
        make.size.mas_equalTo(CGSizeMake(50, 25));
    }];
    
    [view addSubview:self.pickerView];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(30);
    }];
    
    //设置什么都没有动的时候的城市名是北京
    self.cityName = self.defaultCity;
    //一开始picker是隐藏的
    self.allView.hidden = YES;
}
//设置导航栏右边的按钮
-(void)setRightNaviItemsWith:(NSString*)cityName{

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:cityName style:UIBarButtonItemStyleDone target:self action:@selector(showArea)];
}

#pragma mark ---- 按钮的点击事件
//遮盖的点击事件 显示和隐藏
-(void)showCoverView{
    self.allView.hidden = YES;
    self.coverView.hidden = YES;
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
     _allCityName = [PKQTool cityWith:_allAreaName[0]];
    [self.pickerView selectRow:0 inComponent:1 animated:NO];
    [self.pickerView reloadComponent:1];
     self.cityName = self.defaultCity;
}
//显示下面选择城市的界面
-(void)showArea{
    self.allView.hidden = NO;
    self.coverView.hidden = NO;
}
//点击确定按钮
-(void)getCinemaArea{
    //每次如果城市没有信息进来就赋值成北京。
    if (self.cityName == nil) {
        self.cityName = self.defaultCity;
    }
    self.allView.hidden = YES;
    self.coverView.hidden = YES;
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
     _allCityName = [PKQTool cityWith:_allAreaName[0]];
    [self.pickerView selectRow:0 inComponent:1 animated:NO];
    [self.pickerView reloadComponent:1];
    //这里发送网络请求
    [self getNaviCinemaWithCity:self.cityName];
    [self setRightNaviItemsWith:self.cityName];
    
    self.cityName = nil;
}

#pragma mark ----- pickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.allAreaName.count;
    }else{
        return self.allCityName.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        PKQProvince *province = self.allAreaName[row];
        return province.state;
//        self.allCityName = [PKQTool cityWith:self.allAreaName[row]];
    }else{
        PKQCity *city = self.allCityName[row];
        return city.city;
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //判断是不是隐藏了
    if (pickerView.hidden ) {
        [pickerView selectRow:0 inComponent:0 animated:NO];
    }
    // 判断是否选择的是第一列
    if (component == 0) {
        //1.获取第一列中选中的值
        PKQProvince *province = self.allAreaName[row];
        //2.根据第一列选中的值做key，找到对应的子地区
        self.allCityName = [PKQTool cityWith:province];
        //把第一个城市的名字赋值给现在的城市名
        PKQCity *city = self.allCityName[0];
        self.cityName = city.city;
                //3.刷新界面
        [pickerView reloadComponent:1];
        
        //修改第二列第一行处于被选中
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }else{
        PKQCity *city = self.allCityName[row];
        self.cityName = city.city;
    }
    
}

//发送获取附近电影院的网络请求
-(void)getNaviCinemaWithCity:(NSString*)city{
    //http://api.douban.com/v2/movie//cinemas/nearby?
   // alt=json&
//    apikey=0df993c66c0c636e29ecbb5344252a4a&
//    app_name=doubanmovie&
//    city=%E5%8C%97%E4%BA%AC&
    //client=e%3AiPhone8%2C2%7Cy%3AiPhone%20OS_9.0.2%7Cs%3Amobile%7Cf%3Adoubanmovie_2%7Cv%3A3.6.7%7Cm%3A%E8%B1%86%E7%93%A3%E7%94%B5%E5%BD%B1%7Cudid%3A2f6386d033b0a1f01f6a32b4db14558ccc4abe57&
//    count=32767&
//    douban_udid=c3a8887c60f551117c1859548c56ea60f35b6295&
//    start=1&
//    udid=2f6386d033b0a1f01f6a32b4db14558ccc4abe57&
//    version=2
    NSString *path = [NSString stringWithFormat:@"http://api.douban.com/v2/movie//cinemas/nearby"];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[@"alt"]=@"json";
    dict[@"apikey"]=@"0df993c66c0c636e29ecbb5344252a4a";
    dict[@"app_name"]=@"doubanmovie";
    dict[@"client"]=@"e%3AiPhone8%2C2%7Cy%3AiPhone%20OS_9.0.2%7Cs%3Amobile%7Cf%3Adoubanmovie_2%7Cv%3A3.6.7%7Cm%3A%E8%B1%86%E7%93%A3%E7%94%B5%E5%BD%B1%7Cudid%3A2f6386d033b0a1f01f6a32b4db14558ccc4abe57";
    dict[@"douban_udid"]=@"c3a8887c60f551117c1859548c56ea60f35b6295";
    dict[@"udid"]=@"2f6386d033b0a1f01f6a32b4db14558ccc4abe57";
    dict[@"version"]=@(2);
    dict[@"start"]=@(1);
    dict[@"count"]=@(32767);
    dict[@"city"]=city;
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.color = PKQLoveColor;
    [activity startAnimating];
    [self.view addSubview:activity];
    [activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:path parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        PKQNaviCinemaModel *model = [PKQNaviCinemaModel objectWithKeyValues:responseObject];
        
        //获取该城市的全部的电影院信息
        [activity stopAnimating];
        [self setCityAllCinemaWithModel:model];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络加载出错。" toView:self.view];
    }];
    
}
//获取全部的地区名
-(void)setCityAllCinemaWithModel:(PKQNaviCinemaModel*)model{
    NSArray *array = model.entries;
    NSMutableArray *mutableArr = [NSMutableArray new];
    for (int i=0; i<array.count; i++) {
        PKQNaviCinemaEntriesModel *model = array[i];
        PKQSimpleCinemaModel *simple = [PKQSimpleCinemaModel new];
        simple.name = model.title;
        simple.ID = model.ID;
        simple.district = model.location.district;
        [mutableArr addObject:simple];
    }
    self.allCinemaArray = [mutableArr copy];
    NSMutableArray *districtArray = [NSMutableArray new];
    for (int i=0; i<self.allCinemaArray.count; i++) {
        PKQSimpleCinemaModel *model = self.allCinemaArray[i];
        NSString *district = model.district;
        [districtArray addObject:district];
    }
    districtArray = [[self arrayWithMemberIsOnly:districtArray] copy];
    self.allDistrictArray = districtArray;
    if (districtArray.count <1) {
        self.tableView.backgroundView.hidden = NO;
    }else{
        self.tableView.backgroundView.hidden = YES;
    }
    [self.tableView reloadData];
}


/*移除数组中相同的元素*/
-(NSArray *)arrayWithMemberIsOnly:(NSArray *)array{
    NSMutableArray *categoryArray =[NSMutableArray new];
    for (unsigned i = 0; i < [array count]; i++) {
        @autoreleasepool {
            if ([categoryArray containsObject:[array objectAtIndex:i]]==NO) {
                [categoryArray addObject:[array objectAtIndex:i]];
            }
        }
    }
    return categoryArray;
}



#pragma mark --- uitabelViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.allDistrictArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self setDistrictCinemaArrayWith:section].count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pkq" forIndexPath:indexPath];
    PKQSimpleCinemaModel *model = [self setDistrictCinemaArrayWith:indexPath.section][indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}

kRemoveCellSeparator
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    PKQSimpleCinemaModel *model = [self setDistrictCinemaArrayWith:indexPath.section][indexPath.row];
    
    
    //点击发出请求推出一个界面
    PKQCinemaDetailViewController *vc = [[PKQCinemaDetailViewController alloc]initWithNibName:@"PKQCinemaDetailViewController" bundle:nil];
    //设置标题
    vc.str = model.name;
    
    //    http://api.douban.com/v2/movie/cinema/
    //    118517?
    //    alt=json&
    //    apikey=0df993c66c0c636e29ecbb5344252a4a&
    //    app_name=doubanmovie&
    //    client=e%3AiPhone8%2C2%7Cy%3AiPhone%20OS_9.0.2%7Cs%3Amobile%7Cf%3Adoubanmovie_2%7Cv%3A3.6.7%7Cm%3A%E8%B1%86%E7%93%A3%E7%94%B5%E5%BD%B1%7Cudid%3A2f6386d033b0a1f01f6a32b4db14558ccc4abe57&
    //    douban_udid=c3a8887c60f551117c1859548c56ea60f35b6295&
    //    udid=2f6386d033b0a1f01f6a32b4db14558ccc4abe57&
    //    version=2
    //发送电影详情的请求
    NSString *path = [NSString stringWithFormat:@"http://api.douban.com/v2/movie/cinema/%@",model.ID];
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
        PKQCinemaDetailModel *model = [PKQCinemaDetailModel objectWithKeyValues:responseObject];
        vc.model = model;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络加载出差。" toView:self.view];
    }];
    
    [self.navigationController pushViewController:vc animated:YES];

}

//设置分区的名字
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [UILabel new];
    label.text = self.allDistrictArray[section];
    label.textColor = PKQLoveColor;
    label.font = [UIFont systemFontOfSize:17];
    return label;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}



//根据地区返回该地区的全部电影院
-(NSArray*)setDistrictCinemaArrayWith:(NSInteger)row{
    //获取一个数组来保存 这个简单的来说就是一个过滤器/谓词
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"district == %@",self.allDistrictArray[row]];
    NSArray *array =[self.allCinemaArray filteredArrayUsingPredicate:predicate];
    return array;
}



@end
