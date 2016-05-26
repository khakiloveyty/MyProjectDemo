//
//  JPHomeViewController.m
//  Weibo
//
//  Created by apple on 15/7/4.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPHomeViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "JPDropdownMenu.h"
#import "JPTitleMenuViewController.h"
#import "AFNetworking.h"
//#import "JPAccount.h"//可不需要再导入这个头文件，因为JPAccountTool中已经导入了这个头文件
#import "JPAccountTool.h"
#import "JPTitleButton.h"
#import "JPStatus.h"
#import "JPUser.h"
#import "MJExtension.h"//使用第三方框架MJExtension实现字典、模型的互相转换
#import "JPStatusCell.h"
#import "MJRefresh.h"//使用第三方框架MJRefresh实现上下拉刷新
#import "JPSubview.h"
#import "JPSubViewController.h"
#import "JPStatusTool.h"

//RGB颜色
#define Color(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface JPHomeViewController ()<JPDropdownMenuDelegate,JPSubViewControllerDelegate,JPSubviewDelegate>
/* 总微博数组：里面的元素都是JPStatusFrame模型，每一个JPStatusFrame模型代表每一条微博的相关信息和frame */
@property(nonatomic,strong)NSMutableArray *statusFrames;

@property(nonatomic,weak)JPSubview *sub;
@property(nonatomic,strong)JPSubViewController *svc;
@property(nonatomic,weak)UIImageView *imageView;
@end

@implementation JPHomeViewController

-(JPSubViewController *)svc{
    if (!_svc) {
        _svc=[[JPSubViewController alloc]init];
        _svc.view.frame=CGRectMake(-100, self.view.y, 100, self.view.height);
        _svc.delegate=self;
    }
    return _svc;
}

-(NSMutableArray *)statusFrames{
    if (!_statusFrames) {
        _statusFrames=[NSMutableArray array];
    }
    return _statusFrames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置背景颜色
    self.tableView.backgroundColor=Color(211, 211, 211);
    
    //使第一个cell距离导航栏有一小段距离
    //self.tableView.contentInset=UIEdgeInsetsMake(StatusCellMargin, 0, 0, 0);
    //不推荐这种做法：会导致上拉刷新的“菊花”也会往下挪了一小段距离
    //推荐：重写cell的setFrame方法
    
    //设置导航栏内容
    [self setupNav];
    
    //获得用户信息（昵称）
    [self setupUserInfo];
    
    //集成下拉刷新控件（加载新的微博）
    [self setupDownRefresh];
    
    //集成上拉刷新控件（加载旧的微博）
    [self setupUpRefresh];
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;//设置没有单元格的分隔线
    
//    //设定一个计时器，每隔5s获取未读数据（新的且未读的微博、评论、私信、新粉丝等等相关数据）
//    NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(setupUnreadCount) userInfo:nil repeats:YES];
//    //若主线程正在处理其他事情（例如滚动着视图），就没有时间去处理上面这个计时器
//    //设置主线程也会抽时间处理timer（不管主线程是否在处理其他事情）
//    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}

//将保存JPStatus的数组转换成JPStatusFrame数组
//从原本数组中的每一个JPStatus --> JPStatusFrame，再保存到新数组中
-(NSArray *)statusFramesWithStatuses:(NSArray *)statuses{
    NSMutableArray *frames=[NSMutableArray array];
    for (JPStatus *status in statuses) {
        JPStatusFrame *sF=[[JPStatusFrame alloc]init];
        sF.status=status;//在这调用status的setter方法，确定了子控件的frame和cell的高度
        [frames addObject:sF];
    }
    return frames;
}

//设置导航栏内容
-(void)setupNav{
    //设置导航栏上面的内容
    //左边的按钮
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self andAction:@selector(friendsearch) andImageName:@"navigationbar_friendsearch" andHighImageName:@"navigationbar_friendsearch_highlighted"];
    
    //右边的按钮
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithTarget:self andAction:@selector(pop) andImageName:@"navigationbar_pop" andHighImageName:@"navigationbar_pop_highlighted"];
    
    //中间的标题按钮
    JPTitleButton *titleButton=[JPTitleButton buttonWithType:UIButtonTypeCustom];
    //自定义按钮样式
    //自定义按钮样式相当于：UIButton *titleButton=[[UIButton alloc]init];
    //JPTitleButton *titleButton=[[JPTitleButton alloc]init];
    
    //设置标题按钮图片和文字
    NSString *name=[JPAccountTool account].name;
    [titleButton setTitle:(name?name:@"首页") forState:UIControlStateNormal];
    
    //添加按钮的响应方法
    [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置导航栏的标题视图为标题按钮
    self.navigationItem.titleView=titleButton;
    
    //什么情况下建议使用按钮的imageEdgeInsets、titleEdgeInsets？
    //如果按钮内部的图片、文字是固定不变的，用这2个属性来设置间距，会比较简单好使
    //
//    //获取标题按钮的文字的宽度
//    CGFloat titleWidth=titleButton.titleLabel.width;
//    //获取标题按钮的左边图片的宽度
//    CGFloat imageWidth=titleButton.imageView.width*[UIScreen mainScreen].scale;
//    //乘上scale系数，保证retina屏幕上宽度是正确的（坐标点 --> 像素点）
//    CGFloat leftEdgInsets=titleWidth+imageWidth;//图片挪动的总长度
//    //设置按钮图片边距（让图片往右挪）
//    titleButton.imageEdgeInsets=UIEdgeInsetsMake(0, leftEdgInsets, 0, 0);//上左下右
//    //imageEdgeInsets：传的是图片的像素点，并不是坐标的点数
//    //设置按钮文字边距（让文字往左挪）
//    titleButton.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 40);
}

//获得用户信息（将标题按钮文字显示为昵称）
-(void)setupUserInfo{
   //用户信息的url：https://api.weibo.com/2/users/show.json
   /*
    请求方式：GET
    请求参数：
        access_token(string)：采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
        uid(int64)：需要查询的用户ID。
    */
    
    
    //1.请求管理者
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    
    //设定服务器返回的数据类型（默认为application/json、text/json、text/javascript，没有text/plain）
    //需手动在AFNetworking代码中添加text/plain类型（因为新浪服务器返回的是text/plain类型）
    //manger.responseSerializer=[AFJSONResponseSerializer serializer];
    //上面这句代码是默认的，不写也可以，只要在AFNetworking代码中添加text/plain类型，就不会报错了（因为新浪服务器返回的是text/plain类型）
    
    //2.拼接请求参数
    JPAccount *account=[JPAccountTool account];//在AppDelegate中已经验证了是否过期，所以可以使用
    
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"access_token"]=account.access_token;
    params[@"uid"]=account.uid;
    
    //3.发送请求
    [manger GET:@"https://api.weibo.com/2/users/show.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        //NSLog(@"用户信息请求成功，%@",responseObject);
        
        // 字典 --> 模型
        JPUser *user=[JPUser objectWithKeyValues:responseObject];
        
        //获取用户的昵称
        NSString *name=user.name; //responseObject[@"name"]
        //获取标题按钮
        UIButton *titleButton=(UIButton *)self.navigationItem.titleView;
        //设置标题按钮的名字为用户昵称
        [titleButton setTitle:name forState:UIControlStateNormal];
        
        //存储昵称到沙盒中
        account.name=name;
        [JPAccountTool saveAccount:account];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"用户信息请求失败，%@",error);
    }];
    
}

//集成下拉刷新控件（用于触发加载新的微博数据的方法）
-(void)setupDownRefresh{
    
    //1.添加刷新控件
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewStatus)];
    
    //2.马上加载微博数据（启动程序不能没有微博数据显示，所以先加载一次）
    [self.tableView headerBeginRefreshing];
    
}

//下拉刷新：加载新的微博数据   UIRefreshControl 进入刷新状态：加载最新的微博数据
-(void)loadNewStatus{
    
    //微博数据的url：https://api.weibo.com/2/statuses/friends_timeline.json
    /*
     请求方式：GET
     请求参数：
     access_token(string)：采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
     */
    
    //1.请求管理者
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    
    //设定服务器返回的数据类型（默认为application/json、text/json、text/javascript，没有text/plain）
    //需手动在AFNetworking代码中添加text/plain类型（因为新浪服务器返回的是text/plain类型）
    //manger.responseSerializer=[AFJSONResponseSerializer serializer];
    //上面这句代码是默认的，不写也可以，只要在AFNetworking代码中添加text/plain类型，就不会报错了（因为新浪服务器返回的是text/plain类型）
    
    //2.拼接请求参数
    JPAccount *account=[JPAccountTool account];
    
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"access_token"]=account.access_token;
    //params[@"count"]=@10;//返回微博数目，默认20条
    
    
    /* 
     * since_id(int64)：若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
     */
    
    //取出最前面的微博（最新的微博，即ID最大的微博）
    JPStatusFrame *firstStatusF=[self.statusFrames firstObject];
    
    //如果是第一次刷新，不存在firstStatus，会报错，所以要先进行判断；若不是第一次下拉刷新，则firstStatus是存在的
    if (firstStatusF) {
        //若指定since_id参数，则返回ID比since_id大的微博（即比since_id时间晚的微博）
        params[@"since_id"]=firstStatusF.status.idstr;
    }
    
    
    //*** 定义一个block处理返回的字典数据 ***
    //好处：不用再新定义一个方法，而且是局部，只存在这个方法里面，外部不能访问
    void(^dealingResult)(NSArray *)=^(NSArray *statuses){
        
        //将“微博字典”数组 转换为 “微博模型”数组
        NSArray *newStatuses=[JPStatus objectArrayWithKeyValuesArray:statuses];
        
        //将保存JPStatus的数组转换成JPStatusFrame数组
        NSArray *newStatusFrames=[self statusFramesWithStatuses:newStatuses];
        //在这调用status的setter方法，确定了子控件的frame和cell的高度
        
        //将新加载的微博数据数组 插入到 总微博数组的最前面
        NSRange range=NSMakeRange(0, newStatuses.count);//设定范围
        NSIndexSet *set=[NSIndexSet indexSetWithIndexesInRange:range];//插入位置
        [self.statusFrames insertObjects:newStatusFrames atIndexes:set];
        //按照插入的范围和位置，插入整个数组
        
        //刷新表格
        [self.tableView reloadData];
        
        //结束刷新
        [self.tableView headerEndRefreshing];
        
        //上拉刷新结束后显示最新微博的数量
        [self showNewStatusCount:newStatuses.count];
    };
    
    
    //3.先从数据库中加载微博数据
    NSArray *statuses=[JPStatusTool statusesWithParams:params];
    
    if (statuses.count) {    //如果数据库有缓存数据
    
        //调用处理返回的字典数据的block
        dealingResult(statuses);
        
    }else{  //数据库没有缓存数据，则向服务器发送请求获取最新数据
    
        //4.发送请求
        [manger GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            
            //NSLog(@"加载新微博数据成功：%@",responseObject[@"statuses"]);
            //responseObject[@"statuses"]是数组类型，里面的每一个元素都保存着一个微博的所有信息（以字典形式保存）
            
            //缓存新浪服务器返回的字典数组
            [JPStatusTool saveStatuses:responseObject[@"statuses"]];
            
            //调用处理返回的字典数据的block
            dealingResult(responseObject[@"statuses"]);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"加载新微博数据失败，%@",error);
            
            //结束刷新
            [self.tableView headerEndRefreshing];
            
        }];
    }

}

//显示最新加载的微博的数量
-(void)showNewStatusCount:(NSInteger )count{
    
    //刷新成功，清空未读数（tabBarItem图标左上角的数字）
    self.tabBarItem.badgeValue=nil;
    //也清空应用程序图标右上角的数字
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    
    //1.创建label
    UILabel *label=[[UILabel alloc]init];
    label.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];//将图片设置为背景颜色，平铺
    //设置尺寸
    label.width=[UIScreen mainScreen].bounds.size.width;
    label.height=35;
    
    //2.设置其他属性
    if (count==0) {
        label.text=@"没有新的微博，稍后再试";
    }else{
        label.text=[NSString stringWithFormat:@"共有%ld条新的微博",count];
    }
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:16];
    label.textAlignment=NSTextAlignmentCenter;
    
    label.y=64-label.height;
    
    //3.将label添加到导航控制器的view中，并且盖在导航栏下面
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    //insertSubview：插入某个子视图
    //belowSubview：放在另一个子视图的下面
    
    //4.添加动画
    CGFloat duration=1.0;//动画时间
    [UIView animateWithDuration:duration animations:^{
        //label.y += label.height;//修改label坐标
        label.transform=CGAffineTransformMakeTranslation(0, label.height);
        //修改label的形变属性的Translate（移动）
    } completion:^(BOOL finished) {
        CGFloat delay=1.0;//设置延迟动画时间，延迟1s后再执行动画
        //UIViewAnimationOptionCurveLinear 匀速执行动画
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            //label.y -= label.height;
            label.transform=CGAffineTransformIdentity;//清空修改过的形变属性
        } completion:^(BOOL finished) {
            [label removeFromSuperview];//退回去之后就把label移除
        }];
    }];
    
    //如果某个动画执行完毕后，又要回到动画执行前的状态，建议使用transform来做动画
}

//集成上拉刷新控件（加载旧的微博数据）
-(void)setupUpRefresh{
    //上拉加载旧的微博数据
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreStatus)];
}

//上拉刷新：加载更多之前的微博数据
-(void)loadMoreStatus{
    
    //微博数据的url：https://api.weibo.com/2/statuses/friends_timeline.json
    /*
     请求方式：GET
     请求参数：
     access_token(string)：采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
     */
    
    //1.创建请求管理者
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    //2.拼接请求参数
    JPAccount *account=[JPAccountTool account];
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"access_token"]=account.access_token;
    
    /*
     * max_id(int64)：若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
     */
    
    //取出最后面的微博（最早加载的微博---ID最大的微博）
    JPStatusFrame *lastStatusF=[self.statusFrames lastObject];
    if (lastStatusF) {
        //若指定此参数，则返回ID小于或等于max_id的微博（即比最早加载的微博更早之前的微博），默认为0
        long long maxID=lastStatusF.status.idstr.longLongValue-1;
        //id这种数据一般都是比较大的，一般转成整数的话，最好是long long类型（因为有很多微博）
        
        params[@"max_id"]=@(maxID);
    }
    
    
    //*** 定义一个block处理返回的字典数据 ***
    //好处：不用再新定义一个方法，而且是局部，只存在这个方法里面，外部不能访问
    void(^dealingResult)(NSArray *)=^(NSArray *statuses){
        
        //将“微博字典”中的每一个微博数据转换成“微博模型”，保存在数组中
        NSArray *newStatuses=[JPStatus objectArrayWithKeyValuesArray:statuses];
        
        //将保存JPStatus的数组转换成JPStatusFrame数组
        NSArray *newStatusFrames=[self statusFramesWithStatuses:newStatuses];
        
        //将更多之前的微博数据添加到总数组的最后面
        [self.statusFrames addObjectsFromArray:newStatusFrames];
        
        //刷新表格
        [self.tableView reloadData];
        
        //结束刷新（隐藏footer）
        [self.tableView footerEndRefreshing];
    };
    
    
    //3.先从数据库中加载微博数据
    NSArray *statuses=[JPStatusTool statusesWithParams:params];
    
    if (statuses.count) {    //如果数据库有缓存数据
        
        //调用处理返回的字典数据的block
        dealingResult(statuses);
        
    }else{  //数据库没有缓存数据，则向服务器发送请求获取旧微博数据
    
        [manager GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            
            //缓存新浪服务器返回的字典数组
            [JPStatusTool saveStatuses:responseObject[@"statuses"]];
            
            //调用处理返回的字典数据的block
            dealingResult(responseObject[@"statuses"]);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"请求更多微博失败：%@",error);
            //结束刷新（隐藏footer）
            [self.tableView footerEndRefreshing];
        }];
        
    }
    
}

//获取未读数据
-(void)setupUnreadCount{
    
    //用户信息的url：https://rm.api.weibo.com/2/remind/unread_count.json
    /*
     请求方式：GET
     请求参数：
     access_token(string)：采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
     uid(int64)：需要获取消息未读数的用户UID，必须是当前登录用户。
     */
    
    //1.请求管理者
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    //2.拼接请求参数
    JPAccount *account=[JPAccountTool account];
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"access_token"]=account.access_token;
    params[@"uid"]=account.uid;
    //3.发送请求
    [manager GET:@"https://rm.api.weibo.com/2/remind/unread_count.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        //NSLog(@"请求未读数据成功：%@",responseObject);
        
        /*
         * responseObject[@"status"]：int，新微博未读数
         */
        
        //设置未读微博数的提醒数字（微博的未读数，就是下方tabBarItem图标右上角的数字）
        //description：将NSNumber 转换成--> NSString，自动转换，例如：@20 --> @"20"
        NSString *statusNumber=[responseObject[@"status"] description];
        
        if ([statusNumber isEqualToString:@"0"]) {
            
            self.tabBarItem.badgeValue=nil; //若没有未读微博，则不需要显示
            
            //也清空应用程序图标右上角的数字
            [UIApplication sharedApplication].applicationIconBadgeNumber=0;
        }else{
            
            //设置下方tabBarItem图标右上角的数字
            self.tabBarItem.badgeValue=statusNumber;//字符串类型
            
            //设置应用程序图标右上角的数字（需要在AppDelegate.m先注册）
            [UIApplication sharedApplication].applicationIconBadgeNumber=statusNumber.intValue;//int类型
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求未读数据失败：%@",error);
    }];
}

//标题点击响应
-(void)titleClick:(UIButton *)titleButton{
    
    //[self.view.window addSubview:dropdownMenu];//把下拉菜单放在窗口（self.view的父视图）上
    //self.view.window相当于[UIApplication sharedApplication].keyWindow
    //建议使用[UIApplication sharedApplication].keyWindow获得窗口
    //UIWindow *window=[UIApplication sharedApplication].keyWindow;
    
//    //这样获得的窗口，是当前最上面的窗口（使下拉菜单别让类似弹出键盘这种新创建的窗口挡住）
//    UIWindow *window=[[UIApplication sharedApplication].windows lastObject];
//    
//    //添加蒙版（使下拉菜单出现时下面的窗口不可用）
//    UIView *cover=[[UIView alloc]init];
//    cover.frame=window.bounds;
//    [window addSubview:cover];
//    
//    UIImageView *dropdownMenu=[[UIImageView alloc]init];
//    dropdownMenu.image=[UIImage imageNamed:@"popover_background"];
//    dropdownMenu.width=217;
//    dropdownMenu.height=217;
//    dropdownMenu.userInteractionEnabled=YES;//开启用户交互功能
//    
//    [cover addSubview:dropdownMenu];
    
    
    //调用封装好的下拉菜单
    JPDropdownMenu *menu=[JPDropdownMenu menu];
    menu.delegate=self;
    
    //设置下拉菜单要显示的内容视图
    JPTitleMenuViewController *titleVC=[[JPTitleMenuViewController alloc]init];
    titleVC.tableView.width=100;
    titleVC.tableView.height=44*3;
    
    menu.contentController=titleVC; //这句代码会根据传入视图的尺寸计算相应下拉菜单尺寸
    
    //显示
    [menu showFrom:titleButton]; //这句代码规定好下拉菜单的位置
    
}

#pragma mark - JPDropdownMenuDelegate协议的代理方法
-(void)dropdownMenuDidDismiss:(JPDropdownMenu *)menu{
    UIButton *titleButton=(UIButton *)self.navigationItem.titleView;
    titleButton.selected=NO;
}
-(void)dropdownMenuDidShow:(JPDropdownMenu *)menu{
    UIButton *titleButton=(UIButton *)self.navigationItem.titleView;
    titleButton.selected=YES;
}



-(void)friendsearch{
    
    JPSubview *sub=[[JPSubview alloc]init];
    sub.frame=self.view.frame;
    sub.delegate=self;
    UIWindow *window=[[UIApplication sharedApplication].windows lastObject];
    [window addSubview:sub];
    self.sub=sub;
    
    UIWindow *window2=[UIApplication sharedApplication].keyWindow;
    UIImageView *imageView=[[UIImageView alloc]init];
    imageView.frame=[UIScreen mainScreen].bounds;
    imageView.image=[UIImage imageNamed:@"Default@2x.png"];
    UIView *view=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [imageView addSubview:view];
    self.imageView=imageView;
    [window2 insertSubview:imageView belowSubview:self.tabBarController.view];
    
    [sub addSubview:self.svc.view];
    
    CGFloat duration=0.25;
    [UIView animateWithDuration:duration animations:^{
        self.svc.view.x=0;
        self.tabBarController.view.transform=CGAffineTransformMakeScale(0.5, 0.5);
        self.tabBarController.view.x=300;
    } completion:^(BOOL finished) {
        
    }];
    
    /*
     window
     JPSubview
     JPSubViewController
     imageView
     view
     tabBarController
     */
}
-(void)resume{
    CGFloat duration=0.25;
    [UIView animateWithDuration:duration animations:^{
        self.tabBarController.view.transform=CGAffineTransformIdentity;
        self.tabBarController.view.x=0;
        self.svc.view.x=-100;
    } completion:^(BOOL finished) {
        [self.sub removeFromSuperview];
        [self.imageView removeFromSuperview];
    }];
}
-(void)SubviewdidDismiss:(JPSubview *)sub{
    [self resume];
}
-(void)didDismiss:(JPSubViewController *)svc{
    [self resume];
}



-(void)pop{
    NSLog(@"a");
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.statusFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //获得cell
    JPStatusCell *cell=[JPStatusCell cellWithTableView:tableView];
    
    //获取这行对应的微博信息
    cell.statusFrame=self.statusFrames[indexPath.row];//在此行调用了cell的statusFrame属性的setter方法：添加子控件，给子控件添加的内容（而子控件的frame和各自的cell高度已经在self.statusFrames中已经确定好了）
    
    
    //NSLog(@"%@",userDic);
    /*
     * 在每一个status中的user中保存着用户的头像图片：
     *  avatar_hd 高清图
     *  avatar_large 大图
     *  profile_image_url 缩略图
     */
    
    return cell;
}

//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JPStatusFrame *statusFrame=self.statusFrames[indexPath.row];
    return statusFrame.cellHeight;
}

//点击cell的响应方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"ffgfg");
}

@end
