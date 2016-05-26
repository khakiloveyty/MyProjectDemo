//
//  UITextView+Extension.h
//  Weibo
//
//  Created by apple on 15/7/23.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

//插入带有属性和附件的字符串在光标处

#import <UIKit/UIKit.h>

@interface UITextView (Extension)
//插入*自定义*的带有附件的字符串在光标处（仅仅插入表情）
-(void)insertAttributedString:(NSAttributedString *)text;

//插入*自定义*的带有附件的字符串在光标处（插入表情，并添加其他属性）
-(void)insertAttributedString:(NSAttributedString *)text settingBlock:(void (^)(NSMutableAttributedString *attributedText))settingBlock;

//(void (^)(NSMutableAttributedString *attributedText))settingBlock：用于保存外界写入的操作
//void：block的返回值类型
//NSMutableAttributedString *attributedText：给外界调用的内部参数
//settingBlock：这个block的名称

//使用block：因为这个分类的作用是插入表情，也可以自定义其他属性

@end
