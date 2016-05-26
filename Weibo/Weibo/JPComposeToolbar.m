//
//  JPComposeToolbar.m
//  Weibo
//
//  Created by apple on 15/7/19.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPComposeToolbar.h"
#import "UIView+Extension.h"

@interface JPComposeToolbar()
//表情按钮
@property(nonatomic,strong)UIButton *emotionButton;
@end

@implementation JPComposeToolbar

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        //colorWithPatternImage：使用图片以平铺的方式填充整个背景
        
        //初始化工具条上的按钮
        [self setupButtonWithImage:@"compose_camerabutton_background" andHighImage:@"compose_camerabutton_background_highlighted" type:JPComposeToolbarButtonTypeCamera];//照相机按钮
        [self setupButtonWithImage:@"compose_toolbar_picture" andHighImage:@"compose_toolbar_picture_highlighted" type:JPComposeToolbarButtonTypePicture];//相册按钮
        [self setupButtonWithImage:@"compose_mentionbutton_background" andHighImage:@"compose_mentionbutton_background_highlighted" type:JPComposeToolbarButtonTypeMention];//@按钮
        [self setupButtonWithImage:@"compose_trendbutton_background" andHighImage:@"compose_trendbutton_background_highlighted" type:JPComposeToolbarButtonTypeTrend];//#按钮
        //保存表情按钮
        self.emotionButton=[self setupButtonWithImage:@"compose_emoticonbutton_background" andHighImage:@"compose_emoticonbutton_background_highlighted" type:JPComposeToolbarButtonTypeEmotion];//表情按钮
    }
    return self;
}

//创建一个按钮
-(UIButton *)setupButtonWithImage:(NSString *)image andHighImage:(NSString *)highImage type:(JPComposeToolbarButtonType)type{
    UIButton *button=[[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    //给button标识（是哪个按钮）
    button.tag=type;
    [self addSubview:button];
    
    return button;
}

//重写showEmotionButton的setter方法：用于切换表情\键盘图标
-(void)setShowKeyboardButton:(BOOL)showKeyboardButton{
    _showKeyboardButton=showKeyboardButton;
    
    if (showKeyboardButton) {
        //切换成键盘图标
        [self.emotionButton setImage:[UIImage imageNamed:@"compose_keyboardbutton_background"] forState:UIControlStateNormal];
        [self.emotionButton setImage:[UIImage imageNamed:@"compose_keyboardbutton_background_highlighted"] forState:UIControlStateHighlighted];
    }else{
        //切换成表情图标
        [self.emotionButton setImage:[UIImage imageNamed:@"compose_emoticonbutton_background"] forState:UIControlStateNormal];
        [self.emotionButton setImage:[UIImage imageNamed:@"compose_emoticonbutton_background_highlighted"] forState:UIControlStateHighlighted];
    }
}


#pragma mark - 按钮响应事件
//监听按钮点击
-(void)buttonClick:(UIButton *)button{
    //先判断遵守了自定义的协议的类中是否有composeToolbar:didClickButton:这个方法
    if ([self.delegate respondsToSelector:@selector(composeToolbar:didClickButton:)]) {
        //叫代理方去执行协议的方法
        [self.delegate composeToolbar:self didClickButton:(int)button.tag];
    }
}

/* 设置或修改子控件的frame要写在layoutSubviews方法中 */
//在发微博控制器中创建工具条时并没有设置frame，是alloc之后才设置的，所以调用initWithFrame时frame参数为空，因此不能在initWithFrame方法中设置，因为没有工具条的frame就不能设置各个按钮的frame
-(void)layoutSubviews{
    [super layoutSubviews];
    
    //设置所有按钮的frame
    NSUInteger count=self.subviews.count;
    CGFloat buttonW=self.width/count;
    CGFloat buttonH=self.height;
    for (NSUInteger i=0; i<count; i++) {
        UIButton *button=self.subviews[i];
        button.x=i*buttonW;
        button.y=0;
        button.width=buttonW;
        button.height=buttonH;
    }
}


@end
