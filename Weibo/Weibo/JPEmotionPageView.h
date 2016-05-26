//
//  JPEmotionPageView.h
//  Weibo
//
//  Created by apple on 15/7/23.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

//用来显示每一页的表情（显示1~20个）

#import <UIKit/UIKit.h>

#define EmotionMaxRows 3 //最大行数
#define EmotionMaxCols 7 //最大列数
#define EmotionPageCount ((EmotionMaxRows*EmotionMaxCols)-1) //每一页能显示表情的最多个数

@interface JPEmotionPageView : UIView
/** 这一页显示的表情（里面都是JPEmotion模型） */
@property(nonatomic,strong)NSArray *emotions;
@end
