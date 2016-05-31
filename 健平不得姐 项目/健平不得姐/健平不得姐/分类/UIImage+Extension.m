//
//  UIImage+Extension.m
//  健平不得姐
//
//  Created by ios app on 16/5/31.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
-(UIImage *)circleImage{
    
    //开启图形上下文
    //参数1：绘制区域
    //参数2：是否为不透明（NO为透明，不透明为黑色背景）
    //参数3：适用于位图的比例因子。如果你指定一个值为0.0时,比例因子设置为设备的主屏幕的比例因子
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    CGRect circleRect=CGRectMake(0, 0, self.size.height, self.size.height);
    
//    //绘制圆形
//    UIBezierPath *path=[UIBezierPath bezierPathWithOvalInRect:circleRect];
//    //裁剪
//    [path addClip];
    
    //获得上下文
    CGContextRef contextRef=UIGraphicsGetCurrentContext();
    
    //添加一个内切圆
    CGContextAddEllipseInRect(contextRef, circleRect); //添加一个正方形的椭圆就是正圆
    //裁剪
    CGContextClip(contextRef);
    
    [self drawInRect:circleRect];//将图片添加进裁剪过的区域，多余部分就会剪掉，这样就得到圆形的图片
    
    //获得图片
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    
    //结束图形上下文
    UIGraphicsEndImageContext();
    
    return image;
}
@end
