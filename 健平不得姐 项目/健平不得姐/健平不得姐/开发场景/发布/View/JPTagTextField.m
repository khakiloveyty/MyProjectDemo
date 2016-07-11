//
//  JPTagTextField.m
//  健平不得姐
//
//  Created by ios app on 16/6/3.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPTagTextField.h"

@implementation JPTagTextField

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.font=JPTagFont;
        self.height=JPTagHeight;
        
        self.placeholder=@"多个标签用逗号或者换行隔开";
        
        //使用KVC修改占位文字颜色
        [self setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
        
        /*
         *  注意：textField的placeholderLabel是懒加载模式，需要先设置placeholderLabel的内容（即placeholder属性）KVC才能找到相应的成员变量（KVC并不会帮你创建placeholderLabel，只是寻找该成员变量）
         */
    }
    return self;
}

-(void)deleteBackward{
    
    !self.deleteBlock ? : self.deleteBlock();
    
    [super deleteBackward];
    
}

@end
