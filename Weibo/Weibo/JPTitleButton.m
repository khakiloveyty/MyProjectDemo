//
//  JPTitleButton.m
//  Weibo
//
//  Created by apple on 15/7/9.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPTitleButton.h"
#import "UIView+Extension.h"

#define JPMargin 5 //标题和图标的间距

@implementation JPTitleButton

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
        //设置字体颜色
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //设置字体样式
        self.titleLabel.font=[UIFont boldSystemFontOfSize:17];//设置为粗体
        //设置按钮普通状态的图片
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
        //设置按钮高亮状态的图片
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
        
        //设置按钮图片的内容为居中
        self.imageView.contentMode=UIViewContentModeCenter;
        
        //在重写setImage方法中调用[self sizeToFit]（自适应）就不需要上面这句代码了
        //******** 不知道为何启动程序时标题会往右移？？？ *********

    }
    return self;
}

////设置按钮内部imageView的frame，参数：按钮的bounds
//-(CGRect)imageRectForContentRect:(CGRect)contentRect{
//    CGFloat x=80;
//    CGFloat y=0;
//    CGFloat width=15;
//    CGFloat height=contentRect.size.height;
//    return CGRectMake(x, y, width, height);
//}
//
////设置按钮内部titleLabel的frame，参数：按钮的bounds
//-(CGRect)titleRectForContentRect:(CGRect)contentRect{
//    CGFloat x=0;
//    CGFloat y=0;
//    CGFloat width=self.titleLabel.width;
//    //!!!注意!!!：当系统执行到上面这句代码时，需要获取self.titleLabel.width，所以就会自动调用titleRectForContentRect方法获取titleLabel的frame，也就是调用自己，然后再执行到上面这句代码又会重复调用自己，从而进入死循环
//    CGFloat height=contentRect.size.height;
//    return CGRectMake(x, y, width, height);
//}

//所以！！！！，不推荐使用imageRectForContentRect和titleRectForContentRect方法，
//因为！！！！，需要获取本身的titleLabel的frame和imageView的frame，会造成死循环

//推荐！！！！：在layoutSubviews（布局子视图方法）中实现按钮的文字和图片的排布
-(void)layoutSubviews{
    [super layoutSubviews];
    
    //如果仅仅是调整按钮内部的titleLabel和imageView的位置，那么在layoutSubviews中单独设置位置即可
    
    //NSLog(@"%f,%f",self.imageView.x,self.titleLabel.x);
    
    //1.计算titleLabel的x
    CGFloat x=self.imageView.x;
    self.titleLabel.x=x;

    //2.计算imageView的x
    self.imageView.x=CGRectGetMaxX(self.titleLabel.frame)+JPMargin;
    //由于添加的间距，所以要重写setFrame方法，保证按钮的尺寸能框住整个按钮里面的内容
    
}

//目的：想在系统计算和设置完按钮的尺寸（[self sizeToFit]）后，再修改一下尺寸
/*
 * 重写setFrame方法
 * 目的：拦截设置按钮尺寸的过程
 * 如果想在系统设置完控件的尺寸后，再作修改，而且要保证修改成功，一般都是在setFrame中设置
 */
-(void)setFrame:(CGRect)frame{
    //系统只根据标题、图片的尺寸设置按钮的尺寸，并没有把标题和图片的间距也算进来
    //所以要算上间距
    frame.size.width+=JPMargin;//注意：要先修改，再让父类调用
    [super setFrame:frame];
}

//重写：每次设置按钮文字都会自适应
-(void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    //设置按钮自适应（根据按钮的文字和图片自动调整按钮的宽和高）
    [self sizeToFit];
}

//重写：每次设置按钮图片都会自适应
-(void)setImage:(UIImage *)image forState:(UIControlState)state{
    [super setImage:image forState:state];
    //设置按钮自适应（根据按钮的文字和图片自动调整按钮的宽和高）
    [self sizeToFit];
}


@end
