//
//  JPEmotionAttachment.m
//  Weibo
//
//  Created by apple on 15/7/24.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPEmotionAttachment.h"
#import "JPEmotion.h"

@implementation JPEmotionAttachment

//重写emotion属性的setter方法：
//在JPEmotionTextView的insertEmotion方法中调用
-(void)setEmotion:(JPEmotion *)emotion{
    _emotion=emotion;
    
    //设置图片附件
    self.image=[UIImage imageNamed:emotion.png];
}

@end
