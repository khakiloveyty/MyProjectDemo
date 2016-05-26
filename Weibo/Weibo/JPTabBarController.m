//
//  JPTabBarController.m
//  Weibo
//
//  Created by apple on 15/7/4.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPTabBarController.h"
#import "JPHomeViewController.h"
#import "JPMessageViewController.h"
#import "JPDiscoverViewController.h"
#import "JPProfileViewController.h"
#import "JPNavigationViewController.h"
#import "UIView+Extension.h"
#import "JPTabBar.h"
#import "JPComposeViewController.h"

//RGB颜色
#define Color(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

//随机色 arc4random_uniform(256)：0~255的随机数
#define RandomColor Color(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))

@interface JPTabBarController ()<JPTabBarDelegate>

@end

@implementation JPTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.初始化子控制器
    JPHomeViewController *home=[[JPHomeViewController alloc]init];
    [self addChildVcWithController:home Title:@"首页" andImageName:@"tabbar_home" andSelectedImageName:@"tabbar_home_selected"];
    
    JPMessageViewController *message=[[JPMessageViewController alloc]init];
    [self addChildVcWithController:message Title:@"消息" andImageName:@"tabbar_message_center" andSelectedImageName:@"tabbar_message_center_selected"];
    
    JPDiscoverViewController *discover=[[JPDiscoverViewController alloc]initWithStyle:UITableViewStyleGrouped];
    [self addChildVcWithController:discover Title:@"发现" andImageName:@"tabbar_discover" andSelectedImageName:@"tabbar_discover_selected"];
    
    JPProfileViewController *profile=[[JPProfileViewController alloc]initWithStyle:UITableViewStyleGrouped];
    [self addChildVcWithController:profile Title:@"我" andImageName:@"tabbar_profile" andSelectedImageName:@"tabbar_profile_selected"];
    
//    [self addChildViewController:home];
//    [self addChildViewController:message];
//    [self addChildViewController:discover];
//    [self addChildViewController:profile];

    
    //2.更换系统自带的tabbar
    //self.tabBar是只读属性，不能修改
    
    JPTabBar *tabBar=[[JPTabBar alloc]init];
    [self setValue:tabBar forKeyPath:@"tabBar"];
    //[self setValue:tabBar forKeyPath:@"tabBar"]; 这行代码过后，tabBar的delegate就是JPTabBarController
    //说明：所以不用再设置tabBar.delegate=self;
    
    //使用KVC：[self setValue:tabBar forKeyPath:@"tabBar"];
    //等同于self.tabBar=[[JPTabBar alloc]init];
    //遇到这种只读的属性，想要修改就使用KVC
    
    //如果tabBar设置完delegate后（[self setValue:tabBar forKeyPath:@"tabBar"];），再执行tabBar.delegate=self; 修改delegate，就会报错
    //错误原因：不允许修改TabBar的delegate属性（这个TabBar是被TabBarViewController所管理的）
    
    //3.添加“+”按钮到Tab上（在JPTabBar的init方法中）
    
}

//设置控制器的tabBar样式（要有扩展性：不要在方法中创建控制器，因为有些控制器创建的方式不同，有些是init，有些是initWith...等等）
-(void)addChildVcWithController:(UIViewController *)childVc Title:(NSString *)title andImageName:(NSString *)imageName andSelectedImageName:(NSString *)selectedImageName{
    
    //设置title
//    childVc.tabBarItem.title=title;//设置tabBar的title
//    childVc.navigationItem.title=title;//设置导航栏的title
    childVc.title=title;//这一句相当于同时设置导航栏和tabBar的标签title
    
    //设置文字的样式
    //没有被选中：
    NSMutableDictionary *textAttrs=[NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName]=Color(123, 123, 123);
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    //被选中时：
    NSMutableDictionary *selectTextAttrs=[NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName]=[UIColor orangeColor];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    //设置图片的样式
    //没有被选中时：
    childVc.tabBarItem.image=[UIImage imageNamed:imageName];
    //被选中时：
    //声明：这种图片以后按照原始的样子显示出来，不要自动渲染成蓝色（系统默认自动渲染成蓝色，需要手动设置）
    childVc.tabBarItem.selectedImage=[[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //imageWithRenderingMode：渲染模式
    //UIImageRenderingModeAlwaysOriginal：总是原样的模式
    
    //设置背景图颜色
    //childVc.view.backgroundColor=RandomColor;
    //若执行这句代码即创建对应控制器的view（执行对应控制器的viewDidLoad方法）
    
    //添加到导航控制器
    JPNavigationViewController *nav=[[JPNavigationViewController alloc]initWithRootViewController:childVc];

    //添加带有控制器的导航控制器到TabBarController
    [self addChildViewController:nav];
    
}

//证明了：即使视图已经创建好再改变tabbar子视图的位置是不行的
//在JPTabBar的layoutSubviews中实现
//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    long count=self.tabBar.subviews.count;//获取tabbar上的子视图
//    for (int i=0; i<count; i++) {
//        UIView *child=self.tabBar.subviews[i];
//        Class class=NSClassFromString(@"UITabBarButton");//获取此类类型用于判断
//        //UITabBarButton 不能调用，是系统内部的类
//        if ([child isKindOfClass:class]) { //判断是否属于此类
//            child.width=self.tabBar.width/count;
//        }
//    }
//}

#pragma mark - JPTabBarDelegate协议的代理方法
//JPTabBarDelegate协议的方法
//推出发微博界面
-(void)tabBarDidClickPlusButton:(JPTabBar *)tabBar{
    //创建发微博界面
    JPComposeViewController *composeVC=[[JPComposeViewController alloc]init];
    //套上导航栏
    JPNavigationViewController *nav=[[JPNavigationViewController alloc]initWithRootViewController:composeVC];
    //推出
    [self presentViewController:nav animated:YES completion:nil];
}

@end
