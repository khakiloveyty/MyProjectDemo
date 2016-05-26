//
//  JPPostViewController.m
//  健平不得姐
//
//  Created by ios app on 16/5/12.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPPostViewController.h"

@interface JPPostViewController ()

@end

@implementation JPPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏内容
    self.navigationItem.titleView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    self.view.backgroundColor=JPGlobalColor;
}

-(void)leftBtnClick{
    JPLog(@"haha");
}

@end
