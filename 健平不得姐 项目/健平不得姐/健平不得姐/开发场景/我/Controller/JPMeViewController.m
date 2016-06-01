//
//  JPMeViewController.m
//  健平不得姐
//
//  Created by ios app on 16/5/12.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPMeViewController.h"
#import "JPMeCell.h"
#import "JPMeFooterView.h"

@interface JPMeViewController () <JPMeFooterViewDelegate>

@end

@implementation JPMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    [self setupNavigation];
    
    //设置tableView
    [self setupTableView];
    
}

//设置导航栏
-(void)setupNavigation{
    self.navigationItem.title=@"我的";
    
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self andAction:@selector(leftBtnClick) andImageName:@"nav_coin_icon" andHighImageName:@"nav_coin_icon_click"];
    
    UIBarButtonItem *settingBarBtn=[UIBarButtonItem itemWithTarget:self andAction:@selector(setting) andImageName:@"mine-setting-icon" andHighImageName:@"mine-setting-icon-click"];
    UIBarButtonItem *moonBarBtn=[UIBarButtonItem itemWithTarget:self andAction:@selector(moon) andImageName:@"mine-moon-icon" andHighImageName:@"mine-moon-icon-click"];
    self.navigationItem.rightBarButtonItems=@[settingBarBtn,moonBarBtn];
}

//设置tableView
-(void)setupTableView{
    self.tableView.backgroundColor=JPGlobalColor;
    
    [self.tableView registerClass:[JPMeCell class] forCellReuseIdentifier:@"JPMeCell"];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator=NO;
    
    self.tableView.sectionHeaderHeight=0;
    self.tableView.sectionFooterHeight=JPTopicCellMargin;
    //因为tableView的样式是grouped样式，第一个cell会距离顶部有35点，所以调整inset
    self.tableView.contentInset=UIEdgeInsetsMake(JPTopicCellMargin-35, 0, 0, 0);
    
    //设置表尾视图
    JPMeFooterView *footerView=[[JPMeFooterView alloc] init];
    footerView.delegate=self;
    self.tableView.tableFooterView=footerView;
    
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableView.contentSize=CGSizeMake(0, CGRectGetMaxY(self.tableView.tableFooterView.frame)+35);
    JPLog(@"%lf",self.tableView.contentSize.height);
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JPMeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JPMeCell" forIndexPath:indexPath];
    
    if (indexPath.section==0) {
        cell.imageView.image=[UIImage imageNamed:@"setup-head-default"];
        cell.textLabel.text=@"登录/注册";
    } else if (indexPath.section==1) {
        cell.textLabel.text=@"离线下载";
    }
    
    return cell;
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - JPMeFooterViewDelegate

-(void)requestSuccess{
    self.tableView.contentSize=CGSizeMake(0, CGRectGetMaxY(self.tableView.tableFooterView.frame)+35);
    JPLog(@"%lf",self.tableView.contentSize.height);
}

@end
