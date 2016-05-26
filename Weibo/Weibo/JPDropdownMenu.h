//
//  JPDropdownMenu.h
//  Weibo
//
//  Created by apple on 15/7/6.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JPDropdownMenu;

//规定协议
@protocol JPDropdownMenuDelegate <NSObject>
@optional
-(void)dropdownMenuDidDismiss:(JPDropdownMenu *)menu;
-(void)dropdownMenuDidShow:(JPDropdownMenu *)menu;
@end


@interface JPDropdownMenu : UIView

@property(nonatomic,weak)id<JPDropdownMenuDelegate> delegate;

//内容
@property(nonatomic,strong)UIView *content;
//内容控制器
@property(nonatomic,strong)UIViewController *contentController;

//创建下拉菜单的实例
+(instancetype)menu;
//显示
-(void)showFrom:(UIView *)fromView;
//销毁
-(void)dismiss;
@end
