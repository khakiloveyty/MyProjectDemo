//
//  JPProgressView.m
//  健平不得姐
//
//  Created by ios app on 16/5/23.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPProgressView.h"

@implementation JPProgressView

-(void)awakeFromNib{
    //设置进度条圆角
    self.roundedCorners=2;
    //设置进度文字颜色
    self.progressLabel.textColor=[UIColor whiteColor];
}

-(void)setProgress:(CGFloat)progress animated:(BOOL)animated{
    if (progress>=1.0) {
        //以防重用时会在已经下载完毕的图片上显示正在下载的那个cell的进度条，所以隐藏（虽然在很快划动的情况下还会偶然有这种bug）
        self.hidden=YES;
        return;
    }else{
        self.hidden=NO;
    }
    
    //调用父类的setProgress方法（去执行相应的进度方法）
    [super setProgress:progress animated:animated];
    
    //设置进度文字（BUG：有可能出现 -0 的情况，替换成空字符串）
    self.progressLabel.text=[[NSString stringWithFormat:@"%.0f%%",progress*100] stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

@end
