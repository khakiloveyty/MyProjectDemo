//
//  JPTextView.m
//  Weibo
//
//  Created by apple on 15/7/19.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPTextView.h"

@implementation JPTextView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        //添加通知观察者，监听是否开始编辑微博
        //当UITextView的文字发生改变时，UITextView自己会发出一个UITextViewTextDidChangeNotification通知（触发通知的时机）
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
        //object:self 声明是自己发出的通知（若不设置为self且有两个textView，当另一个textView也发出这个通知，就会触发自己的响应方法）
    }
    return self;
}



/*
 * 使用自定义控件，修改其属性值要能够即时实现修改
 * 需要重写自定义属性和常用属性的setter方法
 */
//重写placeholder属性的setter方法：
-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder=[placeholder copy];
    //重绘：第一时间更新，调用最新值
    //防止：本类创建之后，设置占位文字后，没有即时添加
    [self setNeedsDisplay];
}

//重写placeholderColor属性的setter方法：
-(void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor=placeholderColor;
    //重绘：第一时间更新，调用最新值
    //防止：本类创建之后，设置占位文字颜色后，没有即时修改
    [self setNeedsDisplay];
}

//重写text属性的setter方法：
-(void)setText:(NSString *)text{
    //因为text属性是系统自带的，所以要先让父类调用setter方法
    [super setText:text];
    //重绘：第一时间更新，调用最新值
    //防止：一开始编写文字时，没有即时去除占位文字
    [self setNeedsDisplay];
}

//重写attributedText属性的setter方法：
-(void)setAttributedText:(NSAttributedString *)attributedText{
    //因为attributedText属性是系统自带的，所以要先让父类调用setter方法
    [super setAttributedText:attributedText];
    //重绘：第一时间更新，调用最新值
    //防止：一开始添加表情时，没有即时去除占位文字
    [self setNeedsDisplay];
}

//重写font属性的setter方法：
-(void)setFont:(UIFont *)font{
    //因为font属性是系统自带的，所以要先让父类调用setter方法
    [super setFont:font];
    //重绘：第一时间更新，调用最新值
    //防止：本类创建之后，修改文字大小，没有即时修改
    [self setNeedsDisplay];
}



//监听文字改变（开始输入文字）
-(void)textDidChange{
    //重绘（调用drawRect，不能手动调用drawRect）
    [self setNeedsDisplay];
}
-(void)dealloc{ //使用了通知要记得在销毁本程序时移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)drawRect:(CGRect)rect {
    
    //hasText：是否在输入内容
    if (self.hasText) {
        //有内容输入，退出方法，即什么都不画
        return;
    }else{
        //否则没有内容输入，画出占位文字
        
        //设置占位文字属性
        NSMutableDictionary *attrs=[NSMutableDictionary dictionary];
        attrs[NSFontAttributeName]=self.font;//设置占位文字字体大小
        attrs[NSForegroundColorAttributeName]=self.placeholderColor ? self.placeholderColor : [UIColor grayColor];//设置占位文字字体颜色，如果没有设置颜色，那么就使用灰色
        
        //设置占位文字的显示区域
        CGFloat x=5;
        CGFloat y=8;
        CGFloat width=rect.size.width-2*x;
        CGFloat height=rect.size.height-2*y;
        //rect即是textView的bounds
        CGRect placeholderRect=CGRectMake(x, y, width, height);
        
        //画占位文字
        [self.placeholder drawInRect:placeholderRect withAttributes:attrs];
    }
    
}


@end
