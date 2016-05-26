//
//  JPWordViewController.m
//  健平不得姐
//
//  Created by ios app on 16/5/19.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPWordViewController.h"
#import "JPTopic.h"
#import "JPTopicCell.h"

@interface JPWordViewController ()
@property(nonatomic,strong)AFHTTPSessionManager *manager;
@property(nonatomic,strong)NSMutableArray *wordTopices;

/** 当加载第一页以上的数据时需要这两个参数 */
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,copy)NSString *maxtime;

@property(nonatomic,strong)NSMutableDictionary *params;//用来保存最后发送请求的参数
@end

@implementation JPWordViewController

-(NSMutableArray *)wordTopices{
    if (!_wordTopices) {
        _wordTopices=[NSMutableArray array];
    }
    return _wordTopices;
}

-(AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager=[AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化tableview
    [self setupTableView];
    
    //设置刷新控件
    [self setupRefresh];
    
}

#pragma mark - 初始化tableview
-(void)setupTableView{
    self.tableView.backgroundColor=[UIColor clearColor];
    
    //设置内边距
    CGFloat top=JPTitlesViewY+JPTitlesViewHeight;
    CGFloat bottom=self.tabBarController.tabBar.height;
    self.tableView.contentInset=UIEdgeInsetsMake(top, 0, bottom, 0);
    //滚动条的内边距
    self.tableView.scrollIndicatorInsets=self.tableView.contentInset;
    
    //移除系统自带的分隔线
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"JPTopicCell" bundle:nil] forCellReuseIdentifier:@"JPTopicCell"];
}

#pragma mark - 设置刷新控件
-(void)setupRefresh{
    //下拉刷新
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewWordTopices)];
    //根据拖拽比例设置透明度
    self.tableView.mj_header.automaticallyChangeAlpha=YES;
    
    //刷新第一次
    [self.tableView.mj_header beginRefreshing];
    
    //上拉刷新
    self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreWordTopices)];
}

#pragma mark - 数据处理
-(void)loadNewWordTopices{
    
    //执行下拉刷新的时候先停止上拉刷新
    [self.tableView.mj_footer endRefreshing];
    
    //发送请求
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"a"]=@"list";
    params[@"c"]=@"data";
    params[@"type"]=@29;
    self.params=params;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        if (self.params!=params) {
            return ;
        }
        
        self.page=0;
        self.maxtime=responseObject[@"info"][@"maxtime"];
        
        //字典 ---> 模型
        self.wordTopices=[JPTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        //刷新表格
        [self.tableView reloadData];
        
        //结束刷新
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        JPLog(@"失败");
        //结束刷新
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"加载数据失败"];
    }];
}

-(void)loadMoreWordTopices{
    
    //执行上拉刷新的时候先停止下拉刷新
    [self.tableView.mj_header endRefreshing];
    
    //发送请求
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"a"]=@"list";
    params[@"c"]=@"data";
    params[@"type"]=@29;
    params[@"page"]=@(self.page+1);
    params[@"maxtime"]=self.maxtime;
    self.params=params;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        if (self.params!=params) {
            return ;
        }
        
        self.page+=1;
        self.maxtime=responseObject[@"info"][@"maxtime"];
        
        //字典 ---> 模型
        NSArray *wordTopices=[JPTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.wordTopices addObjectsFromArray:wordTopices];
        
        //刷新表格
        [self.tableView reloadData];
        
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        JPLog(@"失败");
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"加载数据失败"];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //若没有帖子数就隐藏上拉刷新控件
    self.tableView.mj_footer.hidden=(self.wordTopices.count==0);
    return self.wordTopices.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JPTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JPTopicCell"];
    
    cell.topic=self.wordTopices[indexPath.row];
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

@end
