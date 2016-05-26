//
//  JPSaveEmotionTool.h
//  Weibo
//
//  Created by apple on 15/7/25.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JPEmotion;

@interface JPEmotionTool : NSObject

/** 保存点击过的表情模型到沙盒（最近表情数组） */
+(void)saveRecentEmotion:(JPEmotion *)emotion;

/** 从沙盒获取点击过的表情模型（最近表情数组） */
+(NSArray *)recentEmotions;

+(NSArray *)defaultEmotions;//获取所有默认表情
+(NSArray *)emojiEmotions;//获取所有emoji表情
+(NSArray *)lxhEmotions;//获取所有浪小花表情

/** 
 * 方法：根据表情的文字描述获取相应的表情图片
 * 参数：表情的文字描述
 */
+(JPEmotion *)emotionWithChs:(NSString *)chs;
@end
