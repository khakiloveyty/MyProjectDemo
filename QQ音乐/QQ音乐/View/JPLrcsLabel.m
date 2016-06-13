//
//  JPLrcsLabel.m
//  QQ音乐
//
//  Created by ios app on 16/6/13.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPLrcsLabel.h"

@implementation JPLrcsLabel

-(void)setProgress:(CGFloat)progress{
    _progress=progress;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    //获取填充区域
    CGRect fillRect=CGRectMake(0, 0, self.bounds.size.width*self.progress, self.bounds.size.height);
    //这里不建议使用rect：这里的rect有可能不准确，如果使用了自动布局rect会不准确
    
    //设置颜色
    [[UIColor colorWithRed:38/255.0 green:187/255.0 blue:102/255.0 alpha:1.0] set];
    
    //填充区域（使用带有枚举的填充方法）
    UIRectFillUsingBlendMode(fillRect, kCGBlendModeSourceIn);
    
    /**
     * kCGBlendModeSourceIn ---> R = S*Da ---> 填充颜色 * 内容的alpha值 = 透明的地方透明，不透明的地方即填充
     *  - Da ：label上某个区域的alpha值
     *  - S  ：要填充的alpha值
     */
}


@end
