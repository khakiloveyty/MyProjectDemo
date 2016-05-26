//
//  JPTabBar.m
//  Weibo
//
//  Created by apple on 15/7/6.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPTabBar.h"
#import "UIView+Extension.h"

@interface JPTabBar()
@property(nonatomic,weak)UIButton *plusButton;
@end

@implementation JPTabBar

//在别处调用init时会自动调用这方法
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        //添加“+”按钮到Tab上
        UIButton *plusButton=[[UIButton alloc]init];
        [plusButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [plusButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        [plusButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [plusButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        plusButton.size=plusButton.currentBackgroundImage.size;
        
        [plusButton addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
        
        //设置位置应在layoutSubviews方法中实现
//        plusButton.centerX=self.width*0.5;
//        plusButton.centerY=self.height*0.5;
        
        self.plusButton=plusButton;
        
        [self addSubview:plusButton];//initWithFrame之后则执行layoutSubviews
        
    }
    return self;
}

//委托：推出发微博控制器
-(void)plusClick{
    //如果代理方有tabBarDidClickPlusButton方法的实现
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
        [self.delegate tabBarDidClickPlusButton:self];
    }
}


/* 设置子控件的frame要写在layoutSubviews方法中 */
//自定义tabbarButton的位置和尺寸
-(void)layoutSubviews{
    
    [super layoutSubviews];//先让系统按照自己规格排布好（没有参数，是系统的自动布局）
    
    //再自定义布局
    
    //设置“+”按钮位置
    self.plusButton.centerX=self.width*0.5;
    self.plusButton.centerY=self.height*0.5;
    
    //设置其他tabbarButton的位置和尺寸
    //long count=self.subviews.count;//获取tabbar上的子视图（还包括tabbar的背景视图和tabbar上面的分割线，所以这里有7个，要作判断）
    
    CGFloat tabbarBtnWidth=self.width/5; //tabbar上有4个控制器和1个按钮
    CGFloat tabbarBtnX=0;//初始化tabbarButton的x位置
    
    for (UIView *child in self.subviews) {
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
        }
    }
    
    //[super layoutSubviews]; //不能放在这里，因为会再一次根据系统的规格布局
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
