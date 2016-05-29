//
//  JPCommentViewController.m
//  健平不得姐
//
//  Created by ios app on 16/5/28.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPCommentViewController.h"
#import "JPTopic.h"
#import "JPTopicCell.h"
#import "JPCommentHeaderView.h"

@interface JPCommentViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)AFHTTPSessionManager *manager;
@property(nonatomic,strong)NSArray *hotComments; //最热评论（数量固定）
@property(nonatomic,strong)NSMutableArray *latesComments; //最新评论
/** 当加载第一页以上的数据时需要这两个参数 */
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,copy)NSString *lastcid;
@property(nonatomic,strong)NSMutableDictionary *params;//用来保存最后发送请求的参数

//@property(nonatomic,strong)NSArray *save_top_cmt; //用来保存self.topic.top_comt数组（因为该页面的表头视图不需要最热评论这个模块）

@property(nonatomic,strong)JPComment *save_top_cmt;//用来保存self.topic.top_comt模型（因为该页面的表头视图不需要最热评论这个模块）

@end

@implementation JPCommentViewController

-(AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager=[AFHTTPSessionManager manager];
    }
    return _manager;
}

-(NSMutableArray *)latesComments{
    if (!_latesComments) {
        _latesComments=[NSMutableArray array];
    }
    return _latesComments;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化设置
    [self setupBasic];
    
    //设置表头视图
    [self setupHeader];
    
    //设置刷新控件
    [self setupRefresh];
}

//初始化设置
-(void)setupBasic{
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    self.title=@"评论";
    
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithTarget:self andAction:@selector(haha) andImageName:@"comment_nav_item_share_icon" andHighImageName:@"comment_nav_item_share_icon_click"];
    
    self.tableView.backgroundColor=JPGlobalColor;
    
    self.tableView.contentInset=UIEdgeInsetsMake(JPTitlesViewY, 0, 0, 0);
    //滚动条的内边距
    self.tableView.scrollIndicatorInsets=self.tableView.contentInset;
    
    //监听键盘的弹出/收回（UIKeyboardWillChangeFrameNotification：键盘弹出/收回都会发送这个通知）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
//    //如果有最热评论模块
//    if (self.save_top_cmt.count) {
//        //返回最热评论数组（回去还是要显示最热评论模块的）
//        self.topic.top_cmt=self.save_top_cmt;
//        //因为cellHeight属性的getter方法使用了懒加载模式，将cellHeight清零重新再算，把最热评论模块的高度加上去
//        [self.topic setValue:@0 forKeyPath:@"cellHeight"];
//    }
    
    //如果有最热评论模块
    if (self.save_top_cmt) {
        //返回最热评论模型（回去还是要显示最热评论模块的）
        self.topic.top_cmt=self.save_top_cmt;
        //因为cellHeight属性的getter方法使用了懒加载模式，将cellHeight清零重新再算，把最热评论模块的高度加上去
        [self.topic setValue:@0 forKeyPath:@"cellHeight"];
    }
    
}

//键盘弹出/收回响应方法
-(void)keyboardWillChangeFrame:(NSNotification *)noti{
    
    //获取键盘弹出/收起后的Frame（UIKeyboardFrameEndUserInfoKey：键盘弹出/收起最终的frame）
    CGRect frame=[noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //获取键盘弹出/收起的动画时间
    CGFloat duration=[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //修改工具条下方约束
    self.bottomSpace.constant=self.view.height-frame.origin.y;
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)haha{
    
}

//设置表头视图（使用JPTopicCell）
-(void)setupHeader{
    
//    //由于这个页面的表头视图不需要用到JPTopicCell上最热评论那个模块，所以要清空self.topic中最热评论数组
//    if (self.topic.top_cmt.count) {
//        self.save_top_cmt=self.topic.top_cmt; //将最热评论数组先保存起来
//        self.topic.top_cmt=nil; //清空
//        
//        [self.topic setValue:@0 forKeyPath:@"cellHeight"];
//        //因为cellHeight属性的getter方法使用了懒加载模式，所以使用KVC将self.topic的cellHeight清零（cellHeight属性被设置为readonly，所以要使用KVC设置），重新运算一次（因为把最热评论数组清空了，清零就可以重新再算，这个页面就不会算上最热评论模块的高度）
//    }
    
    //由于这个页面的表头视图不需要用到JPTopicCell上最热评论那个模块，所以要清空self.topic中最热评论模型
    if (self.topic.top_cmt) {
        self.save_top_cmt=self.topic.top_cmt; //将最热评论模型先保存起来
        self.topic.top_cmt=nil; //清空
        
        [self.topic setValue:@0 forKeyPath:@"cellHeight"];
        //因为cellHeight属性的getter方法使用了懒加载模式，所以使用KVC将self.topic的cellHeight清零（cellHeight属性被设置为readonly，所以要使用KVC设置），重新运算一次（因为把最热评论模型清空了，清零就可以重新再算，这个页面就不会算上最热评论模块的高度）
    }
    
    //创建表头视图
    UIView *headerView=[[UIView alloc] init];
    headerView.width=Screen_Width;
    
    //将JPTopicCell添加到表头视图
    JPTopicCell *cell=[JPTopicCell cell];
    cell.topic=self.topic;
    //给cell一个固定的frame
    cell.frame=CGRectMake(0, 0, headerView.width, self.topic.cellHeight);
    [headerView addSubview:cell];
    
    headerView.height=self.topic.cellHeight+JPTopicCellMargin;
    
    self.tableView.tableHeaderView=headerView;
    
    /*
     
     tableHeaderView是个特殊控件，会不断调用该控件的setFrame方法
        * 由于重写了JPTopicCell的setFrame方法，它的高度使用了-=计算
        * 作为cell时tableview的cell，会根据heightForRowAtIndexPath方法决定高度（高度是协议方法返回的高度，其他为固定值：x为0，y为0，width为tableview的width），每次调用setFrame方法时传过来的高度都是个固定值，所以不会减少。
        * 作为tableHeaderView，【没有heightForRowAtIndexPath方法返回的高度值】，每次调用setFrame方法时（不断调用）传过来的高度都是【上一次的高度】，所以会越减越小
     
     
      解决方法：
        * 直接给cell一个固定的frame，保证每次调用setFrame方法时传过来的高度都是【计算好的高度】
     
     */
}

//设置刷新控件
-(void)setupRefresh{
    //下拉刷新
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    //根据拖拽比例设置透明度
    self.tableView.mj_header.automaticallyChangeAlpha=YES;
    
    //刷新第一次
    [self.tableView.mj_header beginRefreshing];
    
    //上拉刷新
    self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
}

-(void)loadNewComments{
    //执行下拉刷新的时候先停止上拉刷新
    [self.tableView.mj_footer endRefreshing];
    
    //发送请求
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"a"]=@"dataList";
    params[@"c"]=@"comment";
    params[@"data_id"]=self.topic.topicID;
    params[@"hot"]=@1; //传入这个参数才会有最热评论返回
    
    //每次都保存一次参数，以记录最新发送的请求的参数
    self.params=params;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        if (self.params!=params) {
            return ;
        }
        
//        //保存页数和maxtime
//        self.page=0;
//        self.lastcid=responseObject[@"info"][@"maxtime"];
//        
        //字典 ---> 模型
        self.hotComments=[JPComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        self.latesComments=[JPComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
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

-(void)loadMoreComments{
    //执行上拉刷新的时候先停止下拉刷新
    [self.tableView.mj_header endRefreshing];
    
//    //发送请求
//    NSMutableDictionary *params=[NSMutableDictionary dictionary];
//    params[@"a"]=@"list";
//    params[@"c"]=@"data";
//    params[@"type"]=@(self.type);
//    params[@"page"]=@(self.page+1);
//    params[@"maxtime"]=self.maxtime;
//    self.params=params;
//    
//    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
//        
//        if (self.params!=params) {
//            return ;
//        }
//        
//        //保存页数和maxtime
//        self.page+=1;
//        self.maxtime=responseObject[@"info"][@"maxtime"];
//        
//        //字典 ---> 模型
//        NSArray *topices=[JPTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
//        [self.topices addObjectsFromArray:topices];
//        
//        //刷新表格
//        [self.tableView reloadData];
//        
//        //结束刷新
//        [self.tableView.mj_footer endRefreshing];
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        JPLog(@"失败");
//        //结束刷新
//        [self.tableView.mj_footer endRefreshing];
//        [SVProgressHUD showErrorWithStatus:@"加载数据失败"];
//    }];
}

#pragma mark - Table view data source

/*
 
 注意：判断section头视图的标题和数据的来源
 
  * 情况1：有最热评论和最新评论（有最热评论就肯定有最新评论），两个section都要显示，且section头视图标题和section数据要相对应
  * 情况2：没有最热评论只有最新评论，只显示一个section，且只有最新评论数据
  * 情况3：最热评论和最新评论都没有，没有section
 
 */

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //先判断有多少个section
    if (self.hotComments.count) {
        return 2;
    }else if (self.hotComments.count==0 && self.latesComments.count) {
        return 1;
    }else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //判断第一个section对应的是哪种评论（如果有最热评论数据就是最热评论，否则肯定是最新评论）
    if (section==0 && self.hotComments.count) {
        return self.hotComments.count;
    }else{
        return self.latesComments.count;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    //UITableViewHeaderFooterView：tableView的section头和尾视图
    //跟UITableViewCell相似，可循环利用（其实差不多一个样）
    
    JPCommentHeaderView *headerView=[JPCommentHeaderView headerViewWithTableView:tableView]; 
    
    //判断第一个section对应的是哪种评论（如果有最热评论数据就是最热评论，否则肯定是最新评论）
    //设置【新建/从缓存池取出来】的label的内容
    if (section==0 && self.hotComments.count) {
        headerView.title=@"最热评论";
    }else{
        headerView.title=@"最新评论";
    }
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    JPComment *comment=[self commentInIndexPath:indexPath];
    
    cell.textLabel.text=comment.content;
    
    return cell;
}

//判断数据来源
-(JPComment *)commentInIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0 && self.hotComments.count) {
        return (JPComment *)self.hotComments[indexPath.row];
    }else{
        return (JPComment *)self.latesComments[indexPath.row];
    }
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}

//当tableview开始滚动时收起键盘
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

@end
