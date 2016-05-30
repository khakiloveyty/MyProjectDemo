//
//  JPTopicesViewController.m
//  健平不得姐
//
//  Created by ios app on 16/5/19.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPTopicesViewController.h"
#import "JPTopic.h"
#import "JPTopicCell.h"
#import "JPCommentViewController.h"
#import "JPTopWindow.h"

@interface JPTopicesViewController ()

@property(nonatomic,strong)AFHTTPSessionManager *manager;
@property(nonatomic,strong)NSMutableArray *topices;

/** 当加载第一页以上的数据时需要这两个参数 */
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,copy)NSString *maxtime;

@property(nonatomic,strong)NSMutableDictionary *params;//用来保存最后发送请求的参数

@end

@implementation JPTopicesViewController

-(NSMutableArray *)topices{
    if (!_topices) {
        _topices=[NSMutableArray array];
    }
    return _topices;
}

-(AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager=[AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //在应用顶部添加窗口
    //作用：点击这个窗口让所有scrollView能回滚到最上面（本来要在appdelegate的applicationDidBecomeActive方法中调用，但xcode7不知道为什么不允许这样子做，只好放这里，反正这方法只调用一次就行）
    [JPTopWindow show];
    
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
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopices)];
    //根据拖拽比例设置透明度
    self.tableView.mj_header.automaticallyChangeAlpha=YES;
    
    //刷新第一次
    [self.tableView.mj_header beginRefreshing];
    
    //上拉刷新
    self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopices)];
}

#pragma mark - 数据处理
-(void)loadNewTopices{
    
    //执行下拉刷新的时候先停止上拉刷新
    [self.tableView.mj_footer endRefreshing];
    
    //发送请求
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"a"]=@"list";
    params[@"c"]=@"data";
    params[@"type"]=@(self.type);
    //每次都保存一次参数，以记录最新发送的请求的参数
    self.params=params;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        if (self.params!=params) {
            return ;
        }
        
//        [responseObject writeToFile:@"/Users/iosapp/Desktop/百思不得姐数据.plist" atomically:YES];
        
        //保存页数和maxtime
        self.page=0;
        self.maxtime=responseObject[@"info"][@"maxtime"];
        
        //字典 ---> 模型
        self.topices=[JPTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        //刷新表格
        [self.tableView reloadData];
        
        //结束刷新
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        JPLog(@"失败");
        if (self.params != params) {
            return ;
        }
        //结束刷新
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"加载数据失败"];
    }];
}

-(void)loadMoreTopices{
    
    //执行上拉刷新的时候先停止下拉刷新
    [self.tableView.mj_header endRefreshing];
    
    //发送请求
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"a"]=@"list";
    params[@"c"]=@"data";
    params[@"type"]=@(self.type);
    params[@"page"]=@(self.page+1);
    params[@"maxtime"]=self.maxtime;
    //每次都保存一次参数，以记录最新发送的请求的参数
    self.params=params;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        if (self.params!=params) {
            return ;
        }
        
        //保存页数和maxtime
        self.page+=1;
        self.maxtime=responseObject[@"info"][@"maxtime"];
        
        //字典 ---> 模型
        NSArray *topices=[JPTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.topices addObjectsFromArray:topices];
        
        //刷新表格
        [self.tableView reloadData];
        
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        JPLog(@"失败");
        if (self.params != params) {
            return ;
        }
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"加载数据失败"];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //若没有帖子数就隐藏上拉刷新控件
    self.tableView.mj_footer.hidden=(self.topices.count==0);
    return self.topices.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JPTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JPTopicCell" forIndexPath:indexPath];
    cell.topic=self.topices[indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JPCommentViewController *commentVC=[[JPCommentViewController alloc] init];
    commentVC.topic=self.topices[indexPath.row];
    
    [self.navigationController pushViewController:commentVC animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //取出帖子模型
    JPTopic *topic=self.topices[indexPath.row];
    
    /*
     * 将cell高度的计算过程放到JPTopic的cellHeight属性的getter方法里面
     * 好处：heightForRowAtIndexPath方法调用多次（每次重用都会调用），如果把计算过程放到这里会进行多次计算，浪费cpu资源，放到模型的属性里面，并作出判断（只计算一次），保证了每个cell的计算过程只执行一次。
     */
    
    return topic.cellHeight;

}

@end
