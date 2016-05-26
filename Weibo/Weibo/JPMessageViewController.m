//
//  JPMessageViewController.m
//  Weibo
//
//  Created by apple on 15/7/4.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPMessageViewController.h"
#import "TestViewController.h"

@interface JPMessageViewController ()

@end

@implementation JPMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"写私信" style:UIBarButtonItemStylePlain target:self action:@selector(composeMsg)];
    //style：用于设置背景，在iOS7之前效果比较明显，iOS7中没有任何效果（扁平化）
    
    self.navigationItem.rightBarButtonItem.enabled=NO;
    //二：
    //而我们想再控制器需要用到时才创建对应的view，所以把JPTabBarController.m中的childVc.view.backgroundColor=RandomColor除去，这样就能使控制器的view在用到时才会创建（调用viewDidLoad），并且可以先创建好导航栏，即先渲染好主题，这样就不用把self.navigationItem.rightBarButtonItem.enabled=NO放到viewWillAppear中
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //self.navigationItem.rightBarButtonItem.enabled=NO;
    //一：
    //因为之前在JPTabBarController.m有调用childVc.view.backgroundColor=RandomColor这个方法，调用这个方法会提前创建控制器的view（调用控制器的viewDidLoad方法），即程序一开始就已经创建好4个控制器，而导航栏是在创建好4个控制器之后才创建并渲染主题
    //所以如果放到viewDidLoad中，当执行完这句代码时渲染主题颜色（不可用状态和普通状态的字体颜色）的那部分代码还没就绪好，所以要放到这里，让渲染主题颜色的代码先就绪好
}

-(void)composeMsg{
    
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.text=[NSString stringWithFormat:@"test-message-%ld",indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TestViewController *testVC=[[TestViewController alloc]init];
    [self.navigationController pushViewController:testVC animated:YES];
}

@end
