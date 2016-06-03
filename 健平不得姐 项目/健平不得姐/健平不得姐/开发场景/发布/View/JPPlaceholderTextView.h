//
//  JPPlaceholderTextView.h
//  健平不得姐
//
//  Created by ios app on 16/6/3.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPPlaceholderTextView : UITextView

/* 占位文字 */
@property(nonatomic,copy)NSString *placeholder;
/* 占位文字颜色 */
@property(nonatomic,strong)UIColor *placeholderColor;

@end
