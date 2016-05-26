//
//  UITextView+Extension.m
//  Weibo
//
//  Created by apple on 15/7/23.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "UITextView+Extension.h"

@implementation UITextView (Extension)
//插入*自定义*的带有附件的字符串在光标处（仅仅插入表情）
-(void)insertAttributedString:(NSAttributedString *)text{
    [self insertAttributedString:text settingBlock:nil];
}

//插入*自定义*的带有附件的字符串在光标处（插入表情，并添加其他属性）
-(void)insertAttributedString:(NSAttributedString *)text settingBlock:(void (^)(NSMutableAttributedString *attributedText))settingBlock{
    
    //1.创建带有属性的字符串
    NSMutableAttributedString *attributedText=[[NSMutableAttributedString alloc]init];
    
    //2.拼接之前的内容（图片和普通文字）
    //因为self.textView.attributedText=attributedText这句代码会把之前所有的文本覆盖掉，所以要拼接
    [attributedText appendAttributedString:self.attributedText];
    
    //3.拼接表情图片到光标所在之处
    //获取光标所在位置（selectedRange.location：光标在文本内容中的位置）
    NSUInteger location=self.selectedRange.location;
    //[attributedText insertAttributedString:text atIndex:location];//拼接到光标所在的位置
    
    //将表情覆盖掉光标选择的文本区域（没有选择区域，则是拼接到光标的所在位置）
    [attributedText replaceCharactersInRange:self.selectedRange withAttributedString:text];//replaceCharactersInRange：替换的区域
    
    
    
    //4.执行Block
    //因为执行完第5步之后，就不能再更改其文本的其他属性，只能在第5步之前设置
    //所以创建一个block，保存*调用这个方法时*设置好的block方法，然后回到这里才执行
    if (settingBlock) {
        settingBlock(attributedText);
        /*
         相当于在这里执行了：
         [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];
         */
    }
    //在外界设置添加属性的操作，在这里面执行
    
    
    
    //5.显示设置好的带有属性（已经插入表情图片）的文本
    self.attributedText=attributedText;
    
    //6.将光标回到插入表情的后面（因为光标会在第5步之后自动跑到文本的最后面，所以要设置之后回到插入表情的后面）
    self.selectedRange=NSMakeRange(location+1, 0);
    
    /*
     selectedRange：
     1.本来是控制textView的文字选中范围
     2.如果length是0，相当于是用来控制textView的光标位置
     
     关于textView文字的字体
     1.如果是普通文字（text），文字大小由textView.font控制
     2.如果是属性文字（attributedText），文字大小不受textView.font控制，应该利用NSMutableAttributedString的 addAttribute: value: range: 方法设置字体
     */
}

@end
