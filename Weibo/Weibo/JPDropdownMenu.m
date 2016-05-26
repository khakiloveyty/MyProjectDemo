//
//  JPDropdownMenu.m
//  Weibo
//
//  Created by apple on 15/7/6.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPDropdownMenu.h"
#import "UIView+Extension.h"

@interface JPDropdownMenu()
@property(nonatomic,weak)UIImageView *containerView;//用来显示具体内容的容器
@end

@implementation JPDropdownMenu

//下拉菜单
//懒加载，需要用到时才创建
-(UIImageView *)containerView{
    if (!_containerView) {
        UIImageView *containerView=[[UIImageView alloc]init];
        containerView.image=[UIImage imageNamed:@"popover_background"];
//        containerView.width=217;
//        containerView.height=217;
        containerView.userInteractionEnabled=YES;//开启用户交互功能
        [self addSubview:containerView];
        _containerView=containerView;
    }
    return _containerView;
}

//重写content的setter方法：当content有值时，添加到containerView上，此时先调用containerView的懒加载创建实例出来再把content添加上去
-(void)setContent:(UIView *)content{
    _content=content;
    
    //调整内容在下拉菜单中的位置
    content.x=9;
    content.y=15;
    
    //根据内容的尺寸来调整下拉菜单的尺寸
    //调整下拉菜单的宽度
    self.containerView.width=CGRectGetMaxX(content.frame)+9;
    //调整下拉菜单的高度
    self.containerView.height=CGRectGetMaxY(content.frame)+11;
    //CGRectGetMaxY 取y值的最大值（按钮为一个矩形区域，上边缘为y的最小值，下边缘为y的最大值）
    
    //添加内容到下拉菜单上
    [self.containerView addSubview:content];
    
    //******记得将下拉菜单的图片设置为拉伸*******
}

//重写contentController的setter方法：给content赋值，调用content的setter方法
-(void)setContentController:(UIViewController *)contentController{
    _contentController=contentController;
    self.content=contentController.view;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

+(instancetype)menu{
    return [[self alloc]init];
}

//显示
-(void)showFrom:(UIView *)fromView{
    
    //1.获取最上面的窗口
    UIWindow *window=[[UIApplication sharedApplication].windows lastObject];
    
    //2.设置尺寸
    self.frame=window.bounds;
    
    //3.调整下拉菜单的位置
    //默认情况下，frame是以父控件左上角为坐标原点
    //可以转换坐标系原点，改变frame的参照点
    //fromView默认参照点是以fromView.superview的左上点为原点，修改为window（屏幕）的左上角为原点
    CGRect newFrame=[fromView.superview convertRect:fromView.frame toView:window];
    //或 [fromView convertRect:fromView.bounds toView:nil]//nil即window（屏幕）
    
    self.containerView.centerX=CGRectGetMidX(newFrame);//取出newFrame在屏幕的x值的中值
    self.containerView.y=CGRectGetMaxY(newFrame);//取出newFrame在屏幕的y值的最大值

    //4.添加自己到最上面的窗口
    [window addSubview:self];
    
    //通知外界，自己被显示了（让首页标题的箭头变成向上）
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidShow:)]) {
        [self.delegate dropdownMenuDidShow:self];
    }
    
}

//销毁
-(void)dismiss{
    [self removeFromSuperview];
    
    //通知外界，自己被销毁了（让首页标题的箭头变成向下）
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidDismiss:)]) {
        [self.delegate dropdownMenuDidDismiss:self];
    }
}

//点击空白处（除了内容视图的其他部分），让下拉菜单消失
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}

@end
