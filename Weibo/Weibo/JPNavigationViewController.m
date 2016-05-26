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

//在第一次使用这个类时自动调用initialize方法
+ (void)initialize{
    
    //设置整个项目所有item的主题样式  全局设置
    UIBarButtonItem *item=[UIBarButtonItem appearance];//获取导航栏全局的UIBarButtonItem
    
    //设置item普通状态的样式
    NSMutableDictionary *textAttrs=[NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName]=[UIColor orangeColor];
    //key：NS****AttributeName
    //NSForegroundColorAttributeName 字体前景颜色
    //NSBackgroundColorAttributeName 字体背景颜色
    textAttrs[NSFontAttributeName]=[UIFont systemFontOfSize:15];//字体大小
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    //设置item不可用状态的样式
    NSMutableDictionary *disableTextAttrs=[NSMutableDictionary dictionary];
    disableTextAttrs[NSForegroundColorAttributeName]=[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.7];
    //字体大小跟普通状态保持一致
    disableTextAttrs[NSFontAttributeName]=textAttrs[NSFontAttributeName];
    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
}

/*
 * 重写这个push方法的目的：能够拦截所有push进来的控制器，进行修改
 */
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    //每次启动程序时，都会push根控制器，第一次进入这方法时还没push，count为0，不符合条件，跳过；然后第二次进入这方法时也还没push，但count则为1，符合判断条件，执行下面代码
    if (self.viewControllers.count>0) {
        
        viewController.hidesBottomBarWhenPushed=YES;
        
        //设置导航栏上面的内容
        //左边的返回按钮
        viewController.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self andAction:@selector(back) andImageName:@"navigationbar_back" andHighImageName:@"navigationbar_back_highlighted"];
        
        //右边的更多按钮
        viewController.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithTarget:self andAction:@selector(more) andImageName:@"navigationbar_more" andHighImageName:@"navigationbar_more_highlighted"];
    }
    
    //每push一个控制器，self.viewControllers的count就会加1（多一个元素），pop就会删除。
    [super pushViewController:viewController animated:YES];//不写这句，导航栏控制器里面的根控制器就不会push进来
}

-(void)back{
    [self popViewControllerAnimated:YES];
}

-(void)more{
    [self popToRootViewControllerAnimated:YES];
}

@end
