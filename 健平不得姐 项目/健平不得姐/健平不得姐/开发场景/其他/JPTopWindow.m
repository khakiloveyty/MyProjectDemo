//
//  JPTopWindow.m
//  健平不得姐
//
//  Created by ios app on 16/5/30.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPTopWindow.h"

@implementation JPTopWindow

static UIWindow *topWindow_;

+(void)initialize{
    //该方法只会执行一次 ---> 保证window_只会创建一次
    topWindow_=[[UIWindow alloc] init];
    topWindow_.backgroundColor=[UIColor clearColor];
    topWindow_.frame=CGRectMake(0, 0, Screen_Width, 20);
    topWindow_.windowLevel=UIWindowLevelAlert;
    
    [topWindow_ addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(windowClick)]];
    //注意：在类方法中的self指的是类本身，target为self时，选择的方法要设置为类方法
}

+(void)show{
    if (topWindow_.hidden==YES) topWindow_.hidden=NO;
}

//监听窗口点击
+(void)windowClick{
    [self searchScrollViewInView:KeyWindow];
}

//让主窗口上的scrollView才回滚到最顶部
+(void)searchScrollViewInView:(UIView *)superview{
    for (UIScrollView *subview in superview.subviews) {
        
        if ([subview isKindOfClass:[UIScrollView class]] && subview.isShowingOnKeyWindow) {
            
            CGPoint offset=subview.contentOffset; //取出偏移量
            offset.y=-subview.contentInset.top;   //只修改竖直方向的偏移量，水平方向保持原来数值
            
            [subview setContentOffset:offset animated:YES];
            
            //取出偏移量只修改该y值，不然会乱套
            //例子：
            //1.如果设置成CGPoint(0,-subview.contentInset.top)：精华的底层scrollView会回滚到第一个子视图的位置
            //2.如果设置成CGPoint(subview.x,-subview.contentInset.top)：精华的子视图(类型为tableView，除了第一个)会往左偏移自身在父控件上的x值
            
        }
        
        //继续寻找子控件的子控件是否有scrollView直到没有为止
        [self searchScrollViewInView:subview];
    }
}

@end
