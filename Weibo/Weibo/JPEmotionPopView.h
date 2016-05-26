//
//  JPEmotionPopView.h
//  Weibo
//
//  Created by apple on 15/7/23.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JPEmotion;
@class JPEmotionButton;

@interface JPEmotionPopView : UIView

+(instancetype)popView;

@property(nonatomic,strong)JPEmotion *emotion;

//显示popView放大镜
-(void)showFrom:(JPEmotionButton *)button;
@end
