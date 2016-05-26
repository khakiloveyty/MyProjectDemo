//
//  JPMeViewController.m
//  健平不得姐
//
//  Created by ios app on 16/5/12.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPMeViewController.h"

@interface JPMeViewController ()

@end

@implementation JPMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=@"我的";
    
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self andAction:@selector(leftBtnClick) andImageName:@"nav_coin_icon" andHighImageName:@"nav_coin_icon_click"];
    
    UIBarButtonItem *settingBarBtn=[UIBarButtonItem itemWithTarget:self andAction:@selector(setting) andImageName:@"mine-setting-icon" andHighImageName:@"mine-setting-icon-click"];
    UIBarButtonItem *moonBarBtn=[UIBarButtonItem itemWithTarget:self andAction:@selector(moon) andImageName:@"mine-sun-icon" andHighImageName:@"mine-sun-icon-click"];
    self.navigationItem.rightBarButtonItems=@[settingBarBtn,moonBarBtn];
    
    self.view.backgroundColor=JPGlobalColor;
}

-(void)leftBtnClick{
    JPLog(@"haha");
}

-(void)setting{
    JPLog(@"haha");
}

-(void)moon{
    JPLog(@"haha");
}

@end
