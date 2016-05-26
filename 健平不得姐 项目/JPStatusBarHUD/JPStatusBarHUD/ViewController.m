//
//  ViewController.m
//  JPStatusBarHUD
//
//  Created by ios app on 16/5/26.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "ViewController.h"
#import "JPStatusBarHUD.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)success:(id)sender {
    [JPStatusBarHUD showSuccess:@"加载成功"];
}

- (IBAction)wrong:(id)sender {
    [JPStatusBarHUD showError:@"加载失败"];
}

- (IBAction)load:(id)sender {
    [JPStatusBarHUD showLoading:@"正在加载中..."];
}

- (IBAction)hide:(id)sender {
    [JPStatusBarHUD hide];
}

- (IBAction)message:(id)sender {
    [JPStatusBarHUD showMessage:@"哈哈"];
}

- (IBAction)messageimage:(id)sender {
    [JPStatusBarHUD showMessage:@"曹操" image:[UIImage imageNamed:@"star"]];
}

@end
