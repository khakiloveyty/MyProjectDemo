//
//  JPEmotionAttachment.h
//  Weibo
//
//  Created by apple on 15/7/24.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

//继承NSTextAttachment类，为了获取表情图片相对应的文字描述，用于发布微博向服务器发送请求的参数

#import <UIKit/UIKit.h>
@class JPEmotion;

@interface JPEmotionAttachment : NSTextAttachment
@property(nonatomic,strong)JPEmotion *emotion;
@end
