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
#import "JPCommentCell.h"

@interface JPCommentViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)AFHTTPSessionManager *manager;
@property(nonatomic,strong)NSArray *hotComments; //最热评论（数量固定）
@property(nonatomic,strong)NSMutableArray *latesComments; //最新评论

/** 当加载第一页以上的数据时需要这个参数 */
@property(nonatomic,assign)NSInteger page; //页数

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
    
    self.title=@"评论";
    
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithTarget:self andAction:@selector(rightBarButtonClick) andImageName:@"comment_nav_item_share_icon" andHighImageName:@"comment_nav_item_share_icon_click"];
    
    self.tableView.backgroundColor=JPGlobalColor;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JPCommentCell" bundle:nil] forCellReuseIdentifier:@"JPCommentCell"];
    
    //移除分隔线
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    
    //设置cell的高度
    //1.cell里面的约束要确定 ---> 上方跟下方必须要连好线，确定cell与子控件的高度关系
    
    self.tableView.estimatedRowHeight=100; //2.给tableView一个cell的估算高度
    
    self.tableView.rowHeight=UITableViewAutomaticDimension; //3.让tableview自动计算cell高度
    
    //123三个步骤缺一不可（iOS8才可以使用该方法）
    //注意：要cell内部子控件全部确定好才使用该方法，太复杂的cell就别用这方法了，例如JPTopicCell（部分控件显示不确定）
    
    
    //监听键盘的弹出/收回（UIKeyboardWillChangeFrameNotification：键盘弹出/收回都会发送这个通知）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

//退出页面时的处理
-(void)dealloc{
    
    //移除观察者
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
    
    
    //退出这个界面时，要取消所有请求任务，防止回调请求方法的block
    
    //第一种方法：让这个管理者manager里面的所有请求任务task执行cancel方法（调用cancel方法其实就是直接调用【请求失败的block】代码）
//    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //makeObjectsPerformSelector：让数组中的每个元素都调用selector指向的方法
    
    //第二种方法：让这个管理者manager的session取消当前所有任务task（直接让这个session死了），但会使这个session不能再开启任务task
    [self.manager invalidateSessionCancelingTasks:YES];
    
    //个人推荐第二种：反正退出页面了不会再请求的了，而且因为我在【请求失败的block中】调用了HUD，如果使用第一种方法就会弹出这个HUD，我不想在手动结束请求时出现这个HUD
    
    //清空菜单控制器的自定义选项
    UIMenuController *menuC=[UIMenuController sharedMenuController];
    if (menuC.menuItems.count) {
        menuC.menuItems=nil;
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

-(void)rightBarButtonClick{
    
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
    cell.frame=CGRectMake(0, 0, headerView.width, cell.topic.cellHeight);
    //如果只设置尺寸不设置y值，调用[JPTopicCell cell]时会调用一次setFrame方法，因为cell里面的y值使用了+=计算，然后再设置尺寸时再调用一次setFrame方法，因为y值没设置，所以再叠加一次，所以位置尺寸要一起设置。
    
    [headerView addSubview:cell];
    headerView.height=self.topic.cellHeight;
    
    self.tableView.tableHeaderView=headerView;
    
    /*
     
     tableHeaderView是个特殊控件，会不断调用该控件的setFrame方法
        * 由于重写了JPTopicCell的setFrame方法，它的高度使用了-=计算
        * 作为cell时tableview的cell，会根据heightForRowAtIndexPath方法决定高度（高度是协议方法返回的高度，其他为固定值：x为0，y为经过高度协议方法计算而得出的值，width为tableview的width），每次调用setFrame方法时传过来的高度都是个固定值，所以不会减少。
        * 作为tableHeaderView，【没有heightForRowAtIndexPath方法返回的高度值】，每次调用setFrame方法时（不断调用）传过来的高度都是【上一次的高度】，所以会越减越小
     
     
      解决方法：
        * 先创建一个父视图（headerView）作为tableHeaderView，再将cell放到父控件上面，这样就不会重复调用cell的高度-=计算。
     
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
    
    //若没有帖子数就隐藏上拉刷新控件（如果是xib创建的这个控制器不是tableViewController，不会第一时间执行数据源方法，所以先在这里隐藏上拉刷新控件）
    self.tableView.mj_footer.hidden=YES;
}

-(void)loadNewComments{
    
    /*
     
     //结束之前所有的请求
     [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
     
     不使用这个方法的理由：
      * 调用cancel方法其实就是直接调用【请求失败的block】代码
      * 因为我在【请求失败的block中】调用了HUD，我不想手动结束请求时出现这个HUD
      * 所以还是用老方法：自定义字典保存最近请求的参数，然后回调block时对比一下现在这个字典是否为最近的参数
     
     */
    
    //执行下拉刷新的时候先停止上拉刷新
    [self.tableView.mj_footer endRefreshing];
    
    //发送请求
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"a"]=@"dataList";
    params[@"c"]=@"comment";
    params[@"data_id"]=self.topic.topicID;
    params[@"hot"]=@1; //传入这个参数才会有最热评论返回
    self.params=params;
    
    //每次都保存一次参数，以记录最新发送的请求的参数
    self.params=params;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        if (self.params!=params) {
            return ;
        }
        
#warning 百思不得姐【评论接口】问题：当没有评论数据时，responseObject会是个数组类型
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            [self.tableView.mj_header endRefreshing];
            return;
        } //说明没有评论数据
        
        //字典 ---> 模型
        self.hotComments=[JPComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        self.latesComments=[JPComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        //保存页数
        self.page=1;
        
        //刷新表格
        [self.tableView reloadData];
        
        //结束刷新
        [self.tableView.mj_header endRefreshing];
        
        NSInteger total=[responseObject[@"total"] integerValue]; //total：服务器返回的评论总数（偶尔会这个数会比实际返回的数目少一点，所以直接用>=来判断）
        if (self.latesComments.count>=total) {
            //如果全部加载了就隐藏上拉刷新控件
            self.tableView.mj_footer.hidden=YES;
        }
        
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

-(void)loadMoreComments{
    
    /*
     
     //结束之前所有的请求
     [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
     
     不使用这个方法：
        * 调用cancel方法其实就是直接调用【请求失败的block】代码
        * 因为我在【请求失败的block中】调用了HUD，我不想手动结束请求时出现这个HUD
        * 所以还是用老方法：自定义字典保存最近请求的参数，然后回调block时对比一下现在这个字典是否为最近的参数
     
     */
    
    //执行上拉刷新的时候先停止下拉刷新
    [self.tableView.mj_header endRefreshing];
    
    //发送请求
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"a"]=@"dataList";
    params[@"c"]=@"comment";
    params[@"data_id"]=self.topic.topicID;
    params[@"page"]=@(self.page+1);
    params[@"lastcid"]=[[self.latesComments lastObject] commentID]; //当前最后一条评论的id
    self.params=params;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        if (self.params!=params) {
            return ;
        }
        
#warning 百思不得姐【评论接口】问题：当没有评论数据时，responseObject会是个数组类型
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            self.tableView.mj_footer.hidden=YES;
            return;
        } //说明没有评论数据
        
        //字典 ---> 模型
        NSArray *moreComments=[JPComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.latesComments addObjectsFromArray:moreComments];
        
        //保存页数
        self.page+=1;
        
        //刷新表格
        [self.tableView reloadData];
        
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
        
        NSInteger total=[responseObject[@"total"] integerValue]; //total：服务器返回的评论总数（偶尔会这个数会比实际返回的数目少一点，所以直接用>=来判断）
        if (self.latesComments.count>=total) {
            //如果全部加载了就隐藏上拉刷新控件
            self.tableView.mj_footer.hidden=YES;
        }
        
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
    
    //若没有帖子数就隐藏上拉刷新控件
    self.tableView.mj_footer.hidden=(self.latesComments.count==0);
    
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
    
    JPCommentCell *cell=[tableView dequeueReusableCellWithIdentifier:@"JPCommentCell"];
    
    cell.comment=[self commentInIndexPath:indexPath];
    
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
    
    //先获取菜单控制器
    UIMenuController *menuC=[UIMenuController sharedMenuController];
    
    //判断是否已经显示
    if (menuC.isMenuVisible) {                  //如果已经显示
        
        [menuC setMenuVisible:NO animated:YES]; //就隐藏
        
    }else{
        
        JPCommentCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        
        //成为第一响应者才能显示菜单控制器
        [cell becomeFirstResponder];
        
        //显示菜单控制器
        CGRect targetRect=CGRectMake(0, 40, cell.width, cell.height-40-10);
        [menuC setTargetRect:targetRect inView:cell];
        
        //创建自定义操作选项 ------ 需要控制器去实现响应方法
        UIMenuItem *ding=[[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)];
        UIMenuItem *replay=[[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(replay:)];
        UIMenuItem *report=[[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(report:)];
        menuC.menuItems=@[ding,replay,report];
        
        [menuC setMenuVisible:YES animated:YES];
    }
    
    /*
     
     说明：* UIMenuController依赖于第一响应者，当所在控件不是第一响应者会自动消失。
          * 如果已经有个cell被点击了，那个cell是第一响应者，当点击另一个cell时，点击的那个cell会成为第一响应者，之前那个cell会先放弃第一响应者，它的UIMenuController会自动消失，然后才来到这个方法重新显示。
     
     */
    
}

#pragma mark - UIMenuItem的响应方法
//顶
-(void)ding:(UIMenuController *)menu{
    NSIndexPath *indexPath=[self.tableView indexPathForSelectedRow];
    NSLog(@"顶 --- %@",[self commentInIndexPath:indexPath].user.username);
}

//回复
-(void)replay:(UIMenuController *)menu{
    NSIndexPath *indexPath=[self.tableView indexPathForSelectedRow];
    NSLog(@"回复 --- %@",[self commentInIndexPath:indexPath].user.username);
}

//举报
-(void)report:(UIMenuController *)menu{
    NSIndexPath *indexPath=[self.tableView indexPathForSelectedRow];
    NSLog(@"举报 --- %@",[self commentInIndexPath:indexPath].user.username);
}

#pragma mark - UIScrollerViewDelegate

//当tableview开始滚动时收起键盘和隐藏菜单控制器
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    //隐藏UIMenuController
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}

#warning 不知道为什么这个页面点击顶部回不到顶部，offset会有很大偏差！！！
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    JPLog(@"%lf",scrollView.contentOffset.y);
}

@end
