//
//  JPComposeToolbar.h
//  Weibo
//
//  Created by apple on 15/7/19.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

//键盘顶部的工具条

#import <UIKit/UIKit.h>

//设置工具条按钮枚举（识别按钮）
typedef enum{
    JPComposeToolbarButtonTypeCamera,   //拍照
    JPComposeToolbarButtonTypePicture,  //相册
    JPComposeToolbarButtonTypeMention,  // @
    JPComposeToolbarButtonTypeTrend,    // #
    JPComposeToolbarButtonTypeEmotion   //表情
}JPComposeToolbarButtonType;

@class JPComposeToolbar;

@protocol JPComposeToolbarDelegate <NSObject>
@optional
-(void)composeToolbar:(JPComposeToolbar *)toolbar didClickButton:(JPComposeToolbarButtonType)buttonType;
@end

@interface JPComposeToolbar : UIView
@property(nonatomic,weak)id<JPComposeToolbarDelegate> delegate;
//表情按钮是否显示键盘图标
@property(nonatomic,assign)BOOL showKeyboardButton;
@end
