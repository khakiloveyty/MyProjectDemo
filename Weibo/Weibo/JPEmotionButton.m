//
//  JPEmotionButton.m
//  Weibo
//
//  Created by apple on 15/7/23.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPEmotionButton.h"
#import "NSString+Emoji.h"//十六进制转码emoji字符

@implementation JPEmotionButton

/**
 * 当控件不是从xib、storyboard中创建时，获取是使用代码创建，就会调用这个方法
 */
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self setupFont];
    }
    return self;
}

/**
 * 当控件是从xib、storyboard中创建时，就会调用这个方法
 */
-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if (self) {
        [self setupFont];
    }
    return self;
}

/**
 * 这个方法在initWithCoder方法执行完之后调用
 */
-(void)awakeFromNib{
    
}

-(void)setupFont{
    //设置emoji大小
    self.titleLabel.font=[UIFont systemFontOfSize:32];
    
    //设置高亮的时候，没有高亮状态
    self.adjustsImageWhenHighlighted=NO;
}

//重写emotion属性的setter方法：
//在JPEmotionPageView的setEmotions方法中调用：在键盘上显示
//在JPEmotionPopView的setEmotion方法中调用：在放大镜上显示
-(void)setEmotion:(JPEmotion *)emotion{
    _emotion=emotion;
    
    //判断是否emoji（emoji是十六进制的字符串）
    if (emotion.png) {
        
        //添加表情图片（默认、浪小花）
        [self setImage:[UIImage imageNamed:emotion.png] forState:UIControlStateNormal];
        //*注意*：要在xib文件上对应的按钮控件的第4个检测器的Type设置为Custom（自定义），不需要系统自动渲染，不然显示图片会变成蓝色
        //或者使用代码：imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal
        //                   渲染模式                   总是原样的模式
        
        self.imageView.contentMode=UIViewContentModeCenter;//图片居中
        
    }else if (emotion.code){
        //emoji：emtion.code 十六进制 --> Emoji字符
        //调用NSString+Emoji分类 emotion.code.emoji转换格式
        [self setTitle:emotion.code.emoji forState:UIControlStateNormal];
        
        //设置emoji大小
        //self.titleLabel.font=[UIFont systemFontOfSize:32];
    }
}

/* 重写highlighted属性的getter方法 */
//点击按钮，系统会自动执行这个方法
//-(void)setHighlighted:(BOOL)highlighted{
//    //什么都不写，就是不执行任何操作，取消高亮状态
//}


@end
