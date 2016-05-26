//
//  JPSearchBar.m
//  Weibo
//
//  Created by apple on 15/7/6.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPSearchBar.h"
#import "UIView+Extension.h"

@implementation JPSearchBar

+(instancetype)searchBar{
    return [[self alloc]init];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.font=[UIFont systemFontOfSize:15];//设置搜索框内文字大小
        self.placeholder=@"搜索";//设置搜索框内的初始内容
        self.background=[UIImage imageNamed:@"searchbar_textfield_background"];
        
        //设置左边放大镜图标
        UIImageView *searchIcon=[[UIImageView alloc]init];
        //init 控件是没有尺寸的
        //initWithImage 控件的大小则默认为图片的尺寸
        searchIcon.image=[UIImage imageNamed:@"searchbar_textfield_search_icon"];
        searchIcon.width=30;
        searchIcon.height=30;
        searchIcon.contentMode=UIViewContentModeCenter;//设置图片在显示框内为居中（默认是拉伸）
        
        self.leftView=searchIcon;//将图标放到左边
        self.leftViewMode=UITextFieldViewModeAlways;//设置图标总是显示（默认不显示）
    }
    return self;
}

@end
