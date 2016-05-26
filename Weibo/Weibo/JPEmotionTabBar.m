//
//  JPEmotionTabBar.m
//  Weibo
//
//  Created by apple on 15/7/20.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPEmotionTabBar.h"
#import "UIView+Extension.h"
#import "JPEmotionTabBarButton.h"

@interface JPEmotionTabBar()
@property(nonatomic,strong)JPEmotionTabBarButton *selectButton;
@end

@implementation JPEmotionTabBar

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self setupButton:@"最近" andButtonType:JPEmotionTabBarButtonTypeRecent];
        [self setupButton:@"默认" andButtonType:JPEmotionTabBarButtonTypeDefault];
        [self setupButton:@"Emoji" andButtonType:JPEmotionTabBarButtonTypeEmoji];
        [self setupButton:@"浪小花" andButtonType:JPEmotionTabBarButtonTypeLxh];
    }
    return self;
}

//创建选项框的按钮
-(void)setupButton:(NSString *)title andButtonType:(JPEmotionTabBarButtonType )buttonType{
    //创建按钮
    JPEmotionTabBarButton *btn=[[JPEmotionTabBarButton alloc]init];
    [btn setTitle:title forState:UIControlStateNormal];
    
    [self addSubview:btn];
    
    //设置按钮背景图片
    NSString *image=@"compose_emotion_table_mid_normal";
    NSString *selectImage=@"compose_emotion_table_mid_selected";
    if (self.subviews.count==1) {
        image=@"compose_emotion_table_left_normal";
        selectImage=@"compose_emotion_table_left_selected";
    }else if(self.subviews.count==4){
        image=@"compose_emotion_table_right_normal";
        selectImage=@"compose_emotion_table_right_selected";
    }
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];//平常状态
    [btn setBackgroundImage:[UIImage imageNamed:selectImage] forState:UIControlStateDisabled];//不可用状态
    
    //监听按钮
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //设定按钮类型
    btn.tag=buttonType;
}

//按钮的响应方法：让按钮点击后处于不可用状态，改变表情内容
-(void)buttonClick:(JPEmotionTabBarButton *)button{
    //1.先让其他按钮恢复可用
    self.selectButton.enabled=YES;
    //2.让点击的按钮不可用
    button.enabled=NO;
    //3.保存点击的这个按钮
    self.selectButton=button;
    
    //通知代理
    //先判断代理是否存在委托方法
    if ([self.delegate respondsToSelector:@selector(emotionTabBar:didSelectButton:)]) {
        [self.delegate emotionTabBar:self didSelectButton:(int)button.tag];
    }
}

//重写代理的setter方法
-(void)setDelegate:(id<JPEmotionTabBarDelagete>)delegate{
    _delegate=delegate;
    //当设置好代理方之后就让 默认表情按钮 响应
    [self buttonClick:(JPEmotionTabBarButton *)[self viewWithTag:JPEmotionTabBarButtonTypeDefault]];
    //按钮响应之后，代理方就执行委托方法 emotionTabBar: didSelectButton:
}


/* 设置子控件的frame要写在layoutSubviews方法中 */
//自定义表情选项按钮的位置和尺寸
-(void)layoutSubviews{
    [super layoutSubviews];
    
    //设置按钮的frame
    NSUInteger count=self.subviews.count;
    CGFloat btnW=self.width/count;
    CGFloat btnH=self.height;
    for (int i=0; i<count; i++) {
        UIButton *btn=self.subviews[i];
        btn.y=0;
        btn.width=btnW;
        btn.height=btnH;
        btn.x=i*btnW;
    }
}

@end
