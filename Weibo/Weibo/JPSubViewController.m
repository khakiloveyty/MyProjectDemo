//
//  JPSubViewController.m
//  Weibo
//
//  Created by apple on 15/7/29.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPSubViewController.h"

//RGB颜色
#define Color(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

//随机色 arc4random_uniform(256)：0~255的随机数
#define RandomColor Color(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))

@interface JPSubViewController ()

@end

@implementation JPSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button=[[UIButton alloc]init];
    button.frame=CGRectMake(10, 30, 80, 44);
    [button setBackgroundColor:RandomColor];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setTitleColor:RandomColor forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

-(void)buttonClick{
    
    //通知外界，自己被销毁了（让首页标题的箭头变成向下）
    if ([self.delegate respondsToSelector:@selector(didDismiss:)]) {
        [self.delegate didDismiss:self];
    }
    
}

@end
