//
//  JPLoginRegisterViewController.m
//  健平不得姐
//
//  Created by ios app on 16/5/16.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPLoginRegisterViewController.h"

@interface JPLoginRegisterViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewLeftConstraint;

@end

@implementation JPLoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent; //修改状态栏为轻色系
}

/*
 
     //让当前控制器对应的状态栏为白色
     -(UIStatusBarStyle)preferredStatusBarStyle{
         return UIStatusBarStyleLightContent;
     } 
     ---------- 该方法已无效 -----------
 
     原因：由于在keyWindow的状态栏位置添加了个自定义window（用来让scrollView回滚到顶部），这个自定义window会对状态栏产生【影响】
 
     影响：preferredStatusBarStyle方法无效
 
     解决方法：
       1.在info.plist中加上View controller-based status bar appearance并设置为NO（意思是：NO就是让状态栏样式【不再】基于控制器来控制（即preferredStatusBarStyle），改为由[UIApplication sharedApplication]控制）
       2.在当前控制器设置[UIApplication sharedApplication].statusBarStyle
 
     注意：1和2缺一不可，而且返回时记得恢复原来样式（如果不同）
 
 */


- (IBAction)showLoginOrRegister:(UIButton *)sender {
    
    //退出键盘
    [self.view endEditing:YES];
    
    if (self.loginViewLeftConstraint.constant==0) {
        self.loginViewLeftConstraint.constant=-self.view.width;
        sender.selected=YES;
    }else{
        self.loginViewLeftConstraint.constant=0;
        sender.selected=NO;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
    
}

- (IBAction)close:(id)sender {
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault; //返回时恢复状态栏原来样式
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
