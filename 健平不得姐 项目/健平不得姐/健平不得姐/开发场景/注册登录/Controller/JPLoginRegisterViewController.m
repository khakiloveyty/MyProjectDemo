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

//让当前控制器对应的状态栏为白色
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

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
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
