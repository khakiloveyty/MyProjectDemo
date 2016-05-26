//
//  JPEmotionPopView.m
//  Weibo
//
//  Created by apple on 15/7/23.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPEmotionPopView.h"
#import "JPEmotion.h"
#import "JPEmotionButton.h"
#import "UIView+Extension.h"

@interface JPEmotionPopView()
@property (weak, nonatomic) IBOutlet JPEmotionButton *emotionButton;

@end

@implementation JPEmotionPopView

//从xib文件中抽取对应的视图
+(instancetype)popView{
    return [[[NSBundle mainBundle] loadNibNamed:@"JPEmotionPopView" owner:nil options:nil] lastObject];
}

//重写emotion属性的setter方法：
//在JPEmotionPageView的buttonClick方法中调用
-(void)setEmotion:(JPEmotion *)emotion{
    _emotion=emotion;
    self.emotionButton.emotion=emotion;
}

//显示popView放大镜
-(void)showFrom:(JPEmotionButton *)button{
    //获取表情按钮对应的表情模型
    self.emotion=button.emotion;
    
    //获取最上面的窗口（keyWindow是最上面的主窗口，并不是最上面的窗口，因为键盘能覆盖它）
    UIWindow *window=[[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    //计算出被点击的按钮在window中的frame（将 自身坐标系 转换成 在window上的坐标系）
    CGRect buttonFrame=[button convertRect:button.bounds toView:window];
    self.y=CGRectGetMidY(buttonFrame)-self.height;
    self.centerX=CGRectGetMidX(buttonFrame);
}

@end
