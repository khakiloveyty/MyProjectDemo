//
//  JPEmotionListView.h
//  Weibo
//
//  Created by apple on 15/7/20.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

//表情键盘的表情内容（各自包含各自类别的所有表情，即用来装scrollView上的某种类型的表情所有页）
//包含：scrollView（包含：JPEmotionPageView）+pageControl

#import <UIKit/UIKit.h>

@interface JPEmotionListView : UIView
/** 这个类别的所有表情的数组（里面存放着JPEmotion这个模型类存储的表情） */
@property(nonatomic,strong)NSArray *emotions;
@end
