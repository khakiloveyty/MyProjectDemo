//
//  JPEmotionTabBarButton.m
//  Weibo
//
//  Created by apple on 15/7/22.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPEmotionTabBarButton.h"

@implementation JPEmotionTabBarButton

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        //设置按钮文字颜色
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//平常状态
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];//不可用状态
        //设置字体大小
        self.titleLabel.font=[UIFont systemFontOfSize:13];
    }
    return self;
}

/* 重写highlighted属性的getter方法 */
//点击按钮，系统会自动执行这个方法
-(void)setHighlighted:(BOOL)highlighted{
    //什么都不写，就是不执行任何操作，取消高亮状态
}

@end
