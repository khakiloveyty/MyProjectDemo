//
//  JPEmotionTextView.h
//  Weibo
//
//  Created by apple on 15/7/23.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

//继承于JPTextView，为了让JPTextView能作用于其他程序
//自定义文本编辑视图：用于编辑微博（拥有定义占位文字功能、插入表情图片功能）

#import "JPTextView.h"
@class JPEmotion;

@interface JPEmotionTextView : JPTextView
//插入表情图片
-(void)insertEmotion:(JPEmotion *)emotion;

//不能将图片作为上传参数，要解析发布微博的内容：将表情转为字符串
-(NSString *)fullText;
@end
