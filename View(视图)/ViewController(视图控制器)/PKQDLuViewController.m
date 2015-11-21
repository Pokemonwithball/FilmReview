//
//  PKQDLuViewController.m
//  FilmReview
//
//  Created by tarena on 15/11/17.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQDLuViewController.h"
#import "UMSocial.h"
#import <SMS_SDK/SMSSDK.h>
@interface PKQDLuViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (strong,nonatomic)NSString* myName;
@property (weak, nonatomic) IBOutlet UITextField *mimaNumber;
@property (weak, nonatomic) IBOutlet UIButton *getBtn;
//密码
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
//密码确认
@property (weak, nonatomic) IBOutlet UITextField *passwordagainTextField;
@property (strong,nonatomic) NSTimer *time;
@property (assign,nonatomic) NSInteger second;
@end

@implementation PKQDLuViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.second = 60;
    //申请授权
    [SMSSDK registerApp:@"c621d130d56a" withSecret:@"4a83f43d35cd2f86d872955e976e2c5a"];
}
//键盘退出事件
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//要退出的时候
-(void)viewDidAppear:(BOOL)animated{
    [self.time invalidate];
}

//发送短信验证
- (IBAction)getSmsCode:(UIButton*)sender {
    // zone  国家代码 86 代表中国
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneNumber.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (error) {
            NSLog(@"error %@",error);
        }else{
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeBtn:) userInfo:nil repeats:YES];
            self.time = timer;
            [sender setTintColor:[UIColor lightGrayColor]];
            [sender setTitle:@"(60)重新获取" forState:UIControlStateNormal];
            sender.userInteractionEnabled = NO;
        }
    }];
}
//改变按钮的文字
-(void)changeBtn:(NSTimer *)sender{
    self.second--;
    // NSLog(@"现在是多少秒%ld",self.second);
    if (self.second == 0) {
        [self.getBtn setTintColor:[UIColor blueColor]];
        
        [self.getBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.second = 60;
        self.getBtn.userInteractionEnabled = YES;
        [sender invalidate];
    }else{
        self.getBtn.titleLabel.text = [NSString stringWithFormat:@"(%ld)重新获取",self.second];
        [self.getBtn setTitle:[NSString stringWithFormat:@"(%ld)重新获取",self.second] forState:UIControlStateNormal];
    }
}

//判断注册是否成功
- (IBAction)validCode:(id)sender {
    [SMSSDK commitVerificationCode:self.mimaNumber.text phoneNumber:self.phoneNumber.text zone:@"86" result:^(NSError *error) {
        if (self.passwordagainTextField.text.length <1) {
            [MBProgressHUD showError:@"请输入密码" toView:self.view ];
            return ;
        }
        
//        if (error) {
//            [MBProgressHUD showError:@"验证码不正确" toView:self.view];
//        }else{
            NSLog(@"验证码正确");
            if (self.passwordTextField.text == self.passwordagainTextField.text) {
                PKQMySelfModel *model = [PKQTool defaultSelf];
                model.myName = self.phoneNumber.text;
                model.logeIn = YES;
                model.account = self.phoneNumber.text;
                model.password = self.passwordTextField.text;
                model.myImage = nil;
                //向数据库中加一个用户
                [PKQSqlit addUserWithAccount:model];
                [MBProgressHUD showMessage:@"登陆成功" toView:self.view];
                
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }else{
                [MBProgressHUD showError:@"密码不一样" toView:self.view];
            }
//            
//        }
    }];
}




//微信登录
- (IBAction)weixinDLu:(id)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
        }
        
    });
}
//新浪登录
- (IBAction)wboDLu:(id)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        //          获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            PKQMySelfModel *model = [PKQTool defaultSelf];
            model.myName = snsAccount.userName;
            //model.myImage = snsAccount.iconURL;
            model.myImage = [snsAccount.iconURL dataUsingEncoding:NSUTF8StringEncoding];
            model.logeIn = YES;
            model.account = snsAccount.usid;
            model.password = snsAccount.accessToken;
            [PKQSqlit addUserWithAccount:model];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            //新浪
            
        }});
    
}
//本地账号登陆
- (IBAction)tuzi:(id)sender {
}




- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
