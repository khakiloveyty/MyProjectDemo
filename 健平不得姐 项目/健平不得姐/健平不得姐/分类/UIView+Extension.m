//
//  UIView+Extension.m
//  Weibo
//
//  Created by apple on 15/7/4.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

-(void)setX:(CGFloat)x{
    CGRect frame=self.frame;
    frame.origin.x=x;
    self.frame=frame;
}

-(CGFloat)x{
    return self.frame.origin.x;
}

-(void)setY:(CGFloat)y{
    CGRect frame=self.frame;
    frame.origin.y=y;
    self.frame=frame;
}

-(CGFloat)y{
    return self.frame.origin.y;
}

-(void)setCenterX:(CGFloat)centerX{
    CGPoint center=self.center;
    center.x=centerX;
    self.center=center;
}

-(CGFloat)centerX{
    return self.center.x;
}

-(void)setCenterY:(CGFloat)centerY{
    CGPoint center=self.center;
    center.y=centerY;
    self.center=center;
}

-(CGFloat)centerY{
    return self.center.y;
}

-(void)setWidth:(CGFloat)width{
    CGRect frame=self.frame;
    frame.size.width=width;
    self.frame=frame;
}

-(CGFloat)width{
    return self.frame.size.width;
}

-(void)setHeight:(CGFloat)height{
    CGRect frame=self.frame;
    frame.size.height=height;
    self.frame=frame;
}

-(CGFloat)height{
    return self.frame.size.height;
}

-(void)setSize:(CGSize)size{
    CGRect frame=self.frame;
    frame.size=size;
    self.frame=frame;
}

-(CGSize)size{
    return self.frame.size;
}

-(void)setOrigin:(CGPoint)origin{
    CGRect frame=self.frame;
    frame.origin=origin;
    self.frame=frame;
}

-(CGPoint)origin{
    return self.frame.origin;
}

-(BOOL)isShowingOnKeyWindow{
    
    /*
       判断该视图是否在主窗口上的条件：
         * 1.没有隐藏
         * 2.透明度大于0.01
         * 3.它的窗口要在主窗口上（就例如tabbarController，切换另一个控制器，上一个控制器的view就看不见了，因为不在keyWindow上了）
         * 4.显示在主窗口的范围之内（即跟主窗口的bounds要有相交）
     */
    
    UIWindow *keyWindow=[UIApplication sharedApplication].keyWindow;
    
    //判断子视图是否在主窗口上需要转换坐标系（要在相同坐标系下才可以进行判断，这里是将self的坐标转换为相对于keyWindow上的坐标）
    CGRect onKeyWindowframe=[self.superview convertRect:self.frame toView:keyWindow];
    //参数1：原来坐标系（一般取它的父控件）
    //参数2：要转换的控件
    //参数3：目标坐标系（默认为主窗口，即可以填nil）
    
    return !self.isHidden                                               // ---- 条件1
        && self.alpha>0.01                                              // ---- 条件2
        && self.window==keyWindow                                       // ---- 条件3
        && CGRectIntersectsRect(keyWindow.bounds, onKeyWindowframe);    // ---- 条件4
        //CGRectIntersectsRect(rect1,rect2)：判断rect1和rect2是否相交
    
    //严谨一点：添加subview.window==keyWindow条件（防止这种情况：在这里创建个scrollView没有添加到父控件上，其他的条件也能符合）
    
}

@end
