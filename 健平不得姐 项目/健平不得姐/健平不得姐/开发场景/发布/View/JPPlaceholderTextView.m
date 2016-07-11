//
//  JPPlaceholderTextView.m
//  健平不得姐
//
//  Created by ios app on 16/6/3.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPPlaceholderTextView.h"

static CGFloat const JPCursorMargin=5.0;    //光标初始x值
static CGFloat const JPLabelEdgeMargin=0.5; //label文本距离边缘的小间距

@interface JPPlaceholderTextView ()
@property(nonatomic,weak)UILabel *placeholderLabel;
@end

@implementation JPPlaceholderTextView

-(UILabel *)placeholderLabel{
    if (!_placeholderLabel) {
        UILabel *placeholderLabel=[[UILabel alloc] init];
        
        CGRect frame=placeholderLabel.frame;
        frame.origin.x=self.textContainerInset.left+JPCursorMargin;
        frame.origin.y=self.textContainerInset.top-JPLabelEdgeMargin;
        placeholderLabel.frame=frame;
        
        placeholderLabel.numberOfLines=0;
        
        [self addSubview:placeholderLabel];
        _placeholderLabel=placeholderLabel;
    }
    return _placeholderLabel;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        //添加通知观察者，监听是否开始编辑
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
        //object:self 声明是自己发出的通知（若不设置为self且有两个textView，当另一个textView也发出这个通知，就会触发自己的响应方法）
        
        //设置占位文字的字体默认颜色
        self.placeholderColor=[UIColor grayColor];
        
        //【不需要在这里创建placeholderLabel】
        //因为设置默认颜色时会调用self.placeholderColor的setter方法，setter方法里面会设置placeholderLabel的字体颜色，而placeholderLabel使用了懒加载模式，所以就顺便就创建了placeholderLabel并将默认颜色设置成它的文字颜色
        
        self.alwaysBounceVertical=YES; //垂直方向永远可拖动
    }
    return self;
}

//监听文字改变（开始输入文字）
-(void)textDidChange{
    self.placeholderLabel.hidden=self.hasText; //隐藏或显示placeholderLabel
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect frame=self.placeholderLabel.frame;
    frame.size.width=self.bounds.size.width-2*self.placeholderLabel.frame.origin.x;
    self.placeholderLabel.frame=frame;
    
    //根据占位文字刷新placeholderLabel的尺寸
    [self.placeholderLabel sizeToFit];
}

//修改字体大小
-(void)setFont:(UIFont *)font{
    //因为font属性是系统自带的，所以要先让父类调用setter方法
    [super setFont:font];
    
    //刷新placeholderLabel尺寸
    self.placeholderLabel.font=font;
    [self setNeedsLayout];
}

//修改占位文字内容
-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder=[placeholder copy];
    
    //刷新placeholderLabel尺寸
    self.placeholderLabel.text=placeholder;
    [self setNeedsLayout];
}

//修改占位文字颜色
-(void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor=placeholderColor;
    self.placeholderLabel.textColor=placeholderColor;
}

-(void)setText:(NSString *)text{
    [super setText:text];
    [self textDidChange];
}

-(void)setAttributedText:(NSAttributedString *)attributedText{
    [super setAttributedText:attributedText];
    [self textDidChange];
}

/**
 * setNeedsLayout ------- 系统会在恰当的时刻调用layoutSubviews方法（比如确定了自身或子控件的尺寸、刷新页面）
 * setNeedsDisplay ------ 系统会在恰当的时刻调用drawRect:方法（比如每次runloop循环时）
 */

@end
