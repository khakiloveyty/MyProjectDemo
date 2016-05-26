//
//  JPSaveEmotionTool.m
//  Weibo
//
//  Created by apple on 15/7/25.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

//保存点击过的表情模型在沙盒的路径
#define JPRecentEmotionsPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"emotions.archive"]

#import "JPEmotionTool.h"
#import "JPEmotion.h"
#import "MJExtension.h"

@implementation JPEmotionTool

//类方法不能使用成员变量和属性（是对象专属）

//最近表情数组
//设置全局变量（变量存在内存中，在app存活期间不会被销毁）
static NSMutableArray *_recentEmotions;//命名规范：变量名前面加“_”以区分局部变量和全局变量

//initialize：第一次使用这个类时才会调用这方法，且只调用一次
//所以将读取沙盒中的表情数据的操作放在这方法中，以减少系统的IO操作
+(void)initialize{
    //解档：从沙盒中取出最近表情数组
    _recentEmotions=[NSKeyedUnarchiver unarchiveObjectWithFile:JPRecentEmotionsPath];
    if (_recentEmotions==nil) {
        _recentEmotions=[NSMutableArray array];
    }
}



/** 保存点击过的表情模型（最近表情数组）到沙盒 */
+(void)saveRecentEmotion:(JPEmotion *)emotion{
    
    //1.删除重复的表情
    //方法一：
    [_recentEmotions removeObject:emotion];//调用了JPEmotion重写的isEqual方法，因为使用removeObject方法时会先自动调用isEqual方法
    
    //方法二：
//    //遍历沙盒中的最近表情数组
//    for (JPEmotion *e in emotions) {
//        if ([e.chs isEqualToString:emotion.chs] || [e.code isEqualToString:emotion.code]) {
//            [emotions removeObject:e];
//            break;//删除之后就没必要继续遍历
//        }
//    }
    
    //2.将表情插入到最近表情数组的最前面（最新点击过的表情应显示在最前面）
    [_recentEmotions insertObject:emotion atIndex:0];
    
    //3.归档
    [NSKeyedArchiver archiveRootObject:_recentEmotions toFile:JPRecentEmotionsPath];
}

/** 获取点击过的表情模型（最近表情数组） */
+(NSArray *)recentEmotions{
    //不再需要从沙盒中读取
    return _recentEmotions;
}

//各种表情的数组
//设置全局变量（变量存在内存中，在app存活期间不会被销毁）
//懒加载：只需要从沙盒中获取一次（也可以放在initialize中创建，因为initialize只会执行一次）
static NSArray *_defaultEmotions,*_emojiEmotions,*_lxhEmotions;//命名规范：变量名前面加“_”以区分局部变量和全局变量

//获取所有默认表情
+(NSArray *)defaultEmotions{
    if (!_defaultEmotions) {
        NSString *path=[[NSBundle mainBundle] pathForResource:@"EmotionIcons/default/info" ofType:@"plist"];
        //EmotionIcons/default/info：因为有3个同名的plist文件，所以要明确好路径
        _defaultEmotions=[JPEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _defaultEmotions;
}

//获取所有emoij表情
+(NSArray *)emojiEmotions{
    if (!_emojiEmotions) {
        NSString *path=[[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info" ofType:@"plist"];
        //EmotionIcons/emoji/info：因为有3个同名的plist文件，所以要明确好路径
        _emojiEmotions=[JPEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _emojiEmotions;
}

//获取所有浪小花表情
+(NSArray *)lxhEmotions{
    if (!_lxhEmotions) {
        NSString *path=[[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/info" ofType:@"plist"];
        //EmotionIcons/lxh/info：因为有3个同名的plist文件，所以要明确好路径
        _lxhEmotions=[JPEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _lxhEmotions;
}

//根据表情的文字描述获取相应的表情图片
+(JPEmotion *)emotionWithChs:(NSString *)chs{
    
    //遍历所有默认表情
    for (JPEmotion *emotion in [self defaultEmotions]) {
        if ([emotion.chs isEqualToString:chs]) {
            return emotion;
        }
    }
    
    //emoji表情不用遍历，本来就是字符串
    
    //遍历所有浪小花表情
    for (JPEmotion *emotion in [self lxhEmotions]) {
        if ([emotion.chs isEqualToString:chs]) {
            return emotion;
        }
    }
    
    return nil;
}

@end
