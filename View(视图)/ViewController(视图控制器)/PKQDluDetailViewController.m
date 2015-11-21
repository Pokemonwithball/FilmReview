//
//  PKQDluDetailViewController.m
//  FilmReview
//
//  Created by tarena on 15/11/17.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQDluDetailViewController.h"
#import "PKQDLuViewController.h"
#import "UMSocial.h"
#import "UIButton+WebCache.h"
@interface PKQDluDetailViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
//头像图片
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
//当前图片的名字
@property (strong,nonatomic)NSData *headImage;
@property (weak, nonatomic) IBOutlet UITextField *nameTextFile;
@property (weak, nonatomic) IBOutlet UITextField *detailTextFile;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFile;
@property (weak, nonatomic) IBOutlet UITextField *passwordagainTextFile;

@end

@implementation PKQDluDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    PKQMySelfModel *model = [PKQTool defaultSelf];
    self.nameTextFile.text = model.myName;
    self.detailTextFile.text = model.signature;
    if (model.myImage == nil) {
        [self.headBtn setBackgroundImage:[UIImage imageNamed:@"noImage"] forState:UIControlStateNormal];
    }else{
    [self.headBtn setBackgroundImage:[UIImage imageWithData:model.myImage] forState:UIControlStateNormal];
    NSURL *url = [NSURL URLWithString:[[NSString alloc]initWithData:model.myImage encoding:NSUTF8StringEncoding]];
    [self.headBtn sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headBtn.layer.cornerRadius = 40;
    self.headBtn.layer.masksToBounds = YES;
    self.headBtn.layer.borderWidth = 2;
    self.headBtn.layer.borderColor = PKQLoveColor.CGColor;
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)getHeadImage:(id)sender {
    UIImagePickerController *pc = [UIImagePickerController new];
    pc.delegate = self;
    pc.allowsEditing = YES;
    pc.mediaTypes = @[(NSString*)kUTTypeMovie,(NSString*)kUTTypeImage];
    pc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    //来源选择成相机
    //pc.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:pc animated:YES completion:nil];
}

#pragma mark ----UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    image = info[UIImagePickerControllerEditedImage];
    [self.headBtn setBackgroundImage:image forState:UIControlStateNormal];
    //把图片转换成date存储
    self.headImage = UIImagePNGRepresentation(image);
    PKQMySelfModel *model = [PKQTool defaultSelf];
    model.myImage = self.headImage;
//    NSData *image = [NSData da]
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


//注销
- (IBAction)switchingAccounts:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否确定注销" message:@"一旦注销信息就回不了来" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        PKQMySelfModel *model = [PKQTool defaultSelf];
        model.logeIn = NO;
        [PKQSqlit getUser:model];
        [PKQSqlit removeAllUserDeals];
        [self dismissViewControllerAnimated:YES completion:nil];

    }];
    UIAlertAction *actionB = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    
    
    [alert addAction:action];
    [alert addAction:actionB];
    
    
    
    
}
//取消
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//完成
- (IBAction)completeBack:(id)sender {
    //更新数据库的数据
    PKQMySelfModel *model = [PKQTool defaultSelf];
    if (self.passwordTextFile.text.length <1) {
        //model.myImage = [self.headBtn backgroundImageForState:UIControlStateNormal];
        if (self.headImage) {
             model.myImage = self.headImage;
        }
        model.myName = self.nameTextFile.text;
        model.signature = self.detailTextFile.text;
        [PKQSqlit getUser:model];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        //2个密码错误
        if (self.passwordTextFile.text == self.passwordagainTextFile.text) {
            //model.myImage = [self.headBtn backgroundImageForState:UIControlStateNormal];
            model.myImage = self.headImage;
            model.myName = self.nameTextFile.text;
            model.signature = self.detailTextFile.text;
            model.password = self.passwordTextFile.text;
            [PKQSqlit getUser:model];
            [MBProgressHUD showMessage:@"改变密码成功" toView:self.view];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [MBProgressHUD showError:@"两个密码不正确" toView:self.view];
        }

    }
    
}


@end
