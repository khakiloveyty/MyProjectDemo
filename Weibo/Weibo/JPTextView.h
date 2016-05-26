//
//  JPTextView.h
//  Weibo
//
//  Created by apple on 15/7/19.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

//自定义文本编辑视图：用于编辑微博（拥有占位功能）

#import <UIKit/UIKit.h>

@interface JPTextView : UITextView
/* 占位文字 */
@property(nonatomic,copy)NSString *placeholder;
/* 占位文字颜色 */
@property(nonatomic,strong)UIColor *placeholderColor;

@end
