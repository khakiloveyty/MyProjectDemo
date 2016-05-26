//
//  JPRecommendViewController.m
//  健平不得姐
//
//  Created by ios app on 16/5/13.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPRecommendViewController.h"
#import "JPRecommendTypeCell.h"
#import "JPRecommendType.h"
#import "JPRecommendUserCell.h"
#import "JPRecommendUser.h"

//获取左边选中的那个类别cell的对应的recommmendType模型
//indexPathForSelectedRow ----> 获取选中的那个cell的indexPath
#define JPSelectedType self.recommendTypes[self.leftTableView.indexPathForSelectedRow.row]

@interface JPRecommendViewController ()<UITabBarDelegate,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property(nonatomic,strong)NSMutableArray *recommendTypes;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;

@property(nonatomic,strong)NSMutableDictionary *params;//用来保存最后发送请求的参数
@property(nonatomic,strong)AFHTTPSessionManager *manager;
@end

@implementation JPRecommendViewController

-(NSMutableArray *)recommendTypes{
    if (!_recommendTypes) {
        _recommendTypes=[NSMutableArray array];
    }
    return _recommendTypes;
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
    
    //添加刷新控件
    [self setupRefresh];
    
    //显示指示器
    [SVProgressHUD show];
    
    //加载左侧类别栏目
    [self loadLeftTableView];
    
}

-(void)setupTableView{
    //当一个控制器的view包含了两个以上的tableView，只会有一个tableview（貌似是随机一个）会自动调整间距
    //设置成不会自动调整，然后手动调整
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.leftTableView.contentInset=UIEdgeInsetsMake(64, 0, 0, 0);
    self.rightTableView.contentInset=self.leftTableView.contentInset;
    
    self.title=@"推荐关注";
    
    self.view.backgroundColor=JPGlobalColor;
    
    [self.leftTableView registerNib:[UINib nibWithNibName:@"JPRecommendTypeCell" bundle:nil] forCellReuseIdentifier:@"JPRecommendTypeCell"];
    [self.rightTableView registerNib:[UINib nibWithNibName:@"JPRecommendUserCell" bundle:nil] forCellReuseIdentifier:@"JPRecommendUserCell"];
}

-(void)setupRefresh{
    self.rightTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUsers)];
    
    self.rightTableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];
}

-(void)loadLeftTableView{
    //发送请求
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"a"]=@"category";
    params[@"c"]=@"subscribe";
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        //服务器返回JSON格式数据
        //字典 ---> 模型
        self.recommendTypes=[JPRecommendType mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        //刷新表格
        [self.leftTableView reloadData];
        
        //默认选中第一行
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        
        //刷新加载右侧响应内容
        [self.rightTableView.mj_header beginRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        JPLog(@"失败");
        [SVProgressHUD showErrorWithStatus:@"加载数据失败"];
    }];
}

//加载最新用户数据
-(void)loadNewUsers{
    
    JPRecommendType *recommendType=JPSelectedType;

    //向服务器发送请求
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"a"]=@"list";
    params[@"c"]=@"subscribe";
    params[@"category_id"]=@(recommendType.ID);
    params[@"page"]=@(1);
    
    //保存现在的参数（用来对比）
    self.params=params;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //设置当前页数为1
        recommendType.currentPage=1;
        
        //服务器返回JSON格式数据
        //字典 ---> 模型
        NSArray *users=[JPRecommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        //先清除所有旧数据
        [recommendType.users removeAllObjects];
        
        //添加当前类别对应的用户数组中
        [recommendType.users addObjectsFromArray:users];
        
        //保存这个类别的数据总数
        recommendType.total=[responseObject[@"total"] integerValue];
        
        //对比是否为现在的参数，决定请求返回的block是否要执行后面的代码（以防上次请求结束前切换到另一个类别，然后执行上个请求的block代码的刷新代码，只需执行完数据处理的代码即可）
        if (self.params != params) {
            //执行完上面的代码即可，不要刷新
            return ;
        }
        
        //刷新表格
        [self.rightTableView reloadData];
        
        //结束刷新
        [self.rightTableView.mj_header endRefreshing];
        
        //判断footer状态
        [self checkFooterState];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        JPLog(@"失败");
        if (self.params != params) {
            return ;
        }
        [SVProgressHUD showErrorWithStatus:@"加载数据失败"];
        //结束刷新
        [self.rightTableView.mj_header endRefreshing];
    }];
}

//加载更多用户数据
-(void)loadMoreUsers{
    
    JPRecommendType *recommendType=JPSelectedType;
    
    //向服务器发送请求
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"a"]=@"list";
    params[@"c"]=@"subscribe";
    params[@"category_id"]=@(recommendType.ID);
    
    NSInteger page=recommendType.currentPage+1;
    params[@"page"]=@(page);
    
    //保存现在的参数（用来对比）
    self.params=params;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //记录当前页
        recommendType.currentPage=page;
        
        //服务器返回JSON格式数据
        //字典 ---> 模型
        NSArray *users=[JPRecommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        //添加当前类别对应的用户数组中
        [recommendType.users addObjectsFromArray:users];
        
        //对比是否为现在的参数，决定请求返回的block是否要执行后面的代码
        //（以防这次请求结束前切换到另一个类别执行下个请求，然后上个请求结束了，防止执行上个请求的block代码后面的刷新代码，让block代码只需执行完数据处理的代码即可）
        if (self.params != params) {
            //执行完上面的代码即可，不要刷新
            return ;
        }
        
        //刷新表格
        [self.rightTableView reloadData];
        
        //判断footer状态
        [self checkFooterState];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        JPLog(@"失败");
        if (self.params != params) {
            return ;
        }
        [SVProgressHUD showErrorWithStatus:@"加载数据失败"];
        //结束刷新
        [self.rightTableView.mj_footer endRefreshing];
    }];
}

//判断footer状态
-(void)checkFooterState{
    
    //获取左边选中的那个类别cell的对应的recommmendType模型
    JPRecommendType *recommendType=JPSelectedType;
    
    //每次刷新右边tableview数据时，根据是否有数据来控制footer显示或隐藏
    self.rightTableView.mj_footer.hidden=recommendType.users.count ? NO : YES;
    
    //判断footer状态
    if (recommendType.users.count==recommendType.total) {
        //如果已经达到了数据总数（全部加载完）
        [self.rightTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        //还没达到数据总数（还没加载完）
        [self.rightTableView.mj_footer endRefreshing];
    }
    
}


#pragma mark - tableView data source

//系统第一次加载这个控制器页面时，每个tableview会调用这个方法4次左右，不知道为毛？？？
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView==self.leftTableView) {
        
        return self.recommendTypes.count;
        
    }else{
        
        if (self.recommendTypes.count) {
            
            //先判断footer状态
            [self checkFooterState];
            return [JPSelectedType users].count;
            
        }else{
            self.rightTableView.mj_footer.hidden=YES;
            return 0;
        }
        
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (tableView==self.leftTableView) {
        JPRecommendTypeCell *cell=[tableView dequeueReusableCellWithIdentifier:@"JPRecommendTypeCell"];
        JPRecommendType *recommmendType=self.recommendTypes[indexPath.row];
        cell.recommmendType=recommmendType;
        return cell;
    }else{
        JPRecommendUserCell *cell=[tableView dequeueReusableCellWithIdentifier:@"JPRecommendUserCell"];
        cell.recommmendUser=[JPSelectedType users][indexPath.row];//JPSelectedType是直接从数组中取出来的对象，是id类型，id类型不能使用点语法，只能用[JPSelectedType users]获取该对象的users属性
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.leftTableView) {
        return 44;
    }else{
        return 80;
    }
}

#pragma mark - tableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==self.leftTableView) {
        
        //结束刷新
        [self.rightTableView.mj_header endRefreshing];
        [self.rightTableView.mj_footer endRefreshing];
        
        //获取相应推荐内容
        JPRecommendType *recommendType=self.recommendTypes[indexPath.row];
        
        //如果当前类别对应的用户数组有数据
        if (recommendType.users.count) {
            
            //直接加载已经缓存的数据
            [self.rightTableView reloadData];
            
        }else{
            
            //向服务器请求
            
            //刷新数据（获取左边选中的那个类别cell的对应的recommmendType模型，此时recommmendType的users数组为空，清空）
            [self.rightTableView reloadData];
            
            //进入下拉刷新（向服务器请求获取新数据）
            [self.rightTableView.mj_header beginRefreshing];
            
        }

    }else{
        //设置了右边tableview的selection为no selection，这方法就不会响应
        JPLog(@"点右边了");
    }
    
}


#pragma mark - 销毁
-(void)dealloc{
    //当控制器销毁时，停止所有请求队列
    [self.manager.operationQueue cancelAllOperations];
}

@end
