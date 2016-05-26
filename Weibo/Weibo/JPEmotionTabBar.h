//
//  JPEmotionTabBar.h
//  Weibo
//
//  Created by apple on 15/7/20.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

//表情键盘底部的选项框
//包含：JPEmotionTabBarButton

#import <UIKit/UIKit.h>

typedef enum {
    JPEmotionTabBarButtonTypeRecent,  //最近
    JPEmotionTabBarButtonTypeDefault, //默认
    JPEmotionTabBarButtonTypeEmoji,   //emoji
    JPEmotionTabBarButtonTypeLxh      //浪小花
} JPEmotionTabBarButtonType;

@class JPEmotionTabBar;

@protocol JPEmotionTabBarDelagete <NSObject>
@optional
-(void)emotionTabBar:(JPEmotionTabBar *)tabBar didSelectButton:(JPEmotionTabBarButtonType)buttonType;
@end

@interface JPEmotionTabBar : UIView
@property(nonatomic,weak)id<JPEmotionTabBarDelagete> delegate;
@end
