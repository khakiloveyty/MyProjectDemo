//
//  UIBarButtonItem+Extension.h
//  Weibo
//
//  Created by apple on 15/7/5.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Extension.h"

@interface UIBarButtonItem (Extension)
+(UIBarButtonItem *)itemWithTarget:(id)target andAction:(SEL)action andImageName:(NSString *)imageName andHighImageName:(NSString *)highImageName;
@end
