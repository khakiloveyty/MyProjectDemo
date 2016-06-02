//
//  JPNavigationViewController.m
//  Weibo
//
//  Created by apple on 15/7/4.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPNavigationViewController.h"
#import "UIBarButtonItem+Extension.h"

@interface JPNavigationViewController ()

@end

@implementation JPNavigationViewController

//在第一次使用这个类时自动调用initialize方法（只调用一次，来设置全局属性）
+ (void)initialize{
    
    //appearanceWhenContainedInInstancesOfClasses：当导航栏用在JPNavigationViewController这个控制器类，appearance设置才会生效
    UINavigationBar *bar=[UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[self class]]];//获取导航栏全局*属于这个类*的UINavigationBar
    
    //设置导航栏的背景图
    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    
    //设置导航栏标题字体属性
    [bar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    
    
    
    //获取左右按钮的全局设置
    UIBarButtonItem *item=[UIBarButtonItem appearance];
    
    //左右按钮样式
    NSMutableDictionary *itemNormalAttrs=[NSMutableDictionary dictionary];
    itemNormalAttrs[NSForegroundColorAttributeName]=[UIColor blackColor];
    itemNormalAttrs[NSFontAttributeName]=[UIFont systemFontOfSize:17];
    
    [item setTitleTextAttributes:itemNormalAttrs forState:UIControlStateNormal];
    
    //设置不能点击样式（不知道为什么不能用同一个字典，会把普通样式也变成灰色）
//    itemAttrs[NSForegroundColorAttributeName]=[UIColor lightGrayColor];
    
    NSMutableDictionary *itemDisabledAttrs=[NSMutableDictionary dictionary];
    itemDisabledAttrs[NSForegroundColorAttributeName]=[UIColor lightGrayColor];
    itemDisabledAttrs[NSFontAttributeName]=[UIFont systemFontOfSize:17];
    
    [item setTitleTextAttributes:itemDisabledAttrs forState:UIControlStateDisabled];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //使用了自定义的leftBarbuttonItem左滑返回手势会失效，需要重新设置代理：
    self.interactivePopGestureRecognizer.delegate=(id<UIGestureRecognizerDelegate>)self;
}

/*
 * 重写这个push方法的目的：能够拦截所有push进来的控制器，进行修改
 */
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    //每次启动程序时，都会push根控制器，第一次进入这方法时还没push，count为0，不符合条件，跳过；然后第二次进入这方法时也还没push，但count则为1，符合判断条件，执行下面代码
    if (self.viewControllers.count>0) {
        
        //隐藏TabBar
        viewController.hidesBottomBarWhenPushed=YES;
        
        //设置导航栏上面的内容
        //左边的返回按钮
        UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [backBtn setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//        [backBtn sizeToFit];
        backBtn.contentEdgeInsets=UIEdgeInsetsMake(0, -10, 0, 0);
        backBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;//让按钮内部所有内容左对齐
        backBtn.size=CGSizeMake(70, 30);
        viewController.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:backBtn];
        
    }
    
    //每push一个控制器，self.viewControllers的count就会加1（多一个元素），pop就会删除。
    [super pushViewController:viewController animated:YES];//不写这句，导航栏控制器里面的根控制器就不会push进来
}

-(void)back{
    [self popViewControllerAnimated:YES];
}

@end
