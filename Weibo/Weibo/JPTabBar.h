//
//  JPTabBar.h
//  Weibo
//
//  Created by apple on 15/7/6.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JPTabBar;
@protocol JPTabBarDelegate <UITabBarDelegate> // 要遵守父类的协议
@optional
-(void)tabBarDidClickPlusButton:(JPTabBar *)tabBar;
@end

@interface JPTabBar : UITabBar
@property(nonatomic,weak)id<JPTabBarDelegate> delegate;
@end
