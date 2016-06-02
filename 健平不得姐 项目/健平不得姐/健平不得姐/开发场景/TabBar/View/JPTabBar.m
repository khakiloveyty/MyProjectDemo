//
//  JPTabBar.m
//  Weibo
//
//  Created by apple on 15/7/6.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPTabBar.h"
#import "UIView+Extension.h"
//#import "JPPublishView.h"
#import "JPPublishViewController.h"
#import "JPPostWordViewController.h"

@interface JPTabBar()
@property(nonatomic,weak)UIButton *plusButton;
@property(nonatomic,weak)UIView *fengexianView;
@end

@implementation JPTabBar

//在别处调用init时会自动调用这方法
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
        //添加“+”按钮到Tab上
        UIButton *plusButton=[[UIButton alloc]init];
        
        [plusButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [plusButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        [plusButton setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [plusButton setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        
        //设置按钮尺寸跟图片大小一致
//        plusButton.size=plusButton.currentBackgroundImage.size;
    
        //监听按钮：弹出发布页面
        [plusButton addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:plusButton];//initWithFrame之后则执行layoutSubviews
        self.plusButton=plusButton;
        
        //设置背景图
        self.backgroundImage=[UIImage imageNamed:@"tabbar-light"];
        
        
        
        /** 个人的尝试 --- 修改中间按钮尺寸 */
        plusButton.size=CGSizeMake(plusButton.currentBackgroundImage.size.width*1.5, plusButton.currentBackgroundImage.size.height*1.5);

        /** 个人的尝试 --- 自定义分隔线 */
        UIView *fengexianView=[[UIView alloc] init];
        fengexianView.backgroundColor=[UIColor whiteColor];
        fengexianView.size=CGSizeMake(Screen_Width, 2);
        [self addSubview:fengexianView];
        self.fengexianView=fengexianView;
        
        [self setShadowImage:[UIImage new]];
        
    }
    return self;
}

//推出发布页面
-(void)plusClick{
//    [JPPublishView show];
    
//    JPPublishViewController *publish = [[JPPublishViewController alloc] init];
//    [KeyWindow.rootViewController presentViewController:publish animated:NO completion:nil];
    
    UITabBarController *tabBarController=(UITabBarController *)KeyWindow.rootViewController;
    UINavigationController *navi=(UINavigationController *)tabBarController.selectedViewController;
    JPPostWordViewController *postWordVC=[[JPPostWordViewController alloc] init];
    [navi pushViewController:postWordVC animated:YES];
}

/* 设置子控件的frame要写在layoutSubviews方法中 */
//自定义tabbarButton的位置和尺寸
-(void)layoutSubviews{
    
    [super layoutSubviews];//先让系统按照自己规格排布好（没有参数，是系统的自动布局）
    
    //再自定义布局
    
    //设置“+”按钮位置
    self.plusButton.centerX=self.width*0.5;
//    self.plusButton.centerY=self.height*0.5;
    
    /** 个人的尝试 --- 设置分隔线和中间按钮的位置，并设置它们的下标为最上面（将自带的分隔线盖住） */
    self.plusButton.centerY=15;
    self.fengexianView.x=0;
    self.fengexianView.y=-0.5;
    [self insertSubview:self.plusButton atIndex:self.subviews.count-1];
    [self insertSubview:self.fengexianView belowSubview:self.plusButton];
    
    //设置其他tabbarButton的位置和尺寸
    //long count=self.subviews.count;//获取tabbar上的子视图（还包括tabbar的背景视图和tabbar上面的分割线，所以这里有7个，要作判断）
    
    CGFloat tabbarBtnWidth=self.width/5; //tabbar上有4个控制器和1个按钮
    CGFloat tabbarBtnX=0;//初始化tabbarButton的x位置
    
    static BOOL added=NO; //用来标记按钮是否已经添加过监听器
    
    for (UIControl *child in self.subviews) {
        //self.subviews 系统自带属性：包含子控制器的视图，还有tabbar的背景视图和tabbar上面的分割线
        
        Class class=NSClassFromString(@"UITabBarButton");//获取此类类型用于判断
        //UITabBarButton 不能调用，是系统内部的类
        
        if ([child isKindOfClass:class]) { //判断是否属于此类
            child.width=tabbarBtnWidth;
            child.x=tabbarBtnX*child.width;
            tabbarBtnX++;
            if (tabbarBtnX==2) {
                tabbarBtnX+=1;
            }
            
            if (added==NO) {
                //添加监听器
                [child addTarget:self action:@selector(tabBarBtnClick) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    
    added=YES; //全部添加完了，改为YES，以后不再添加
    
    //[super layoutSubviews]; //不能放在这里，因为会再一次根据系统的规格布局
}

-(void)tabBarBtnClick{
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:JPTabBarDidSelectedNotification object:nil userInfo:nil];
}

/*
    layoutSubviews在以下情况下会被调用：
        1、init初始化不会触发layoutSubviews
        2、initWithFrame会触发layoutSubviews
        3、addSubview会触发layoutSubviews
        4、设置view的Frame会触发layoutSubviews，当然前提是frame的值设置前后发生了变化
        5、滚动一个UIScrollView会触发layoutSubviews
        6、旋转Screen会触发父UIView上的layoutSubviews事件
        7、改变一个UIView大小的时候也会触发父UIView上的layoutSubviews事件
 */

@end
