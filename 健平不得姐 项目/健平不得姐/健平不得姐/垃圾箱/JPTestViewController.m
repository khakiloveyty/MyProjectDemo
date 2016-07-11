//
//  JPTestViewController.m
//  健平不得姐
//
//  Created by ios app on 16/5/13.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPTestViewController.h"

@interface JPTestViewController ()

@end

@implementation JPTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    JPTestViewController *testVC=[[JPTestViewController alloc]init];
    testVC.view.backgroundColor=JPRandomColor;
    [self.navigationController pushViewController:testVC animated:YES];
}

@end
