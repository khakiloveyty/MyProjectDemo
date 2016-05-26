//
//  JPEmotionKeyboard.m
//  Weibo
//
//  Created by apple on 15/7/20.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPEmotionKeyboard.h"
#import "JPEmotionListView.h"
#import "JPEmotionTabBar.h"
#import "UIView+Extension.h"
#import "MJExtension.h"//第三方库：字典 --> 模型
#import "JPEmotion.h"
#import "JPEmotionTool.h"

@interface JPEmotionKeyboard()<JPEmotionTabBarDelagete>

//容纳正在显示listView（用于切换listView：移除上一个listView，将另一个listView放上去）
@property(nonatomic,weak)JPEmotionListView *showingListView;

//表情键盘的表情内容（最近表情）
@property(nonatomic,strong)JPEmotionListView *recentListView;
//表情键盘的表情内容（默认表情）
@property(nonatomic,strong)JPEmotionListView *defaultListView;
//表情键盘的表情内容（emoji表情）
@property(nonatomic,strong)JPEmotionListView *emojiListView;
//表情键盘的表情内容（浪小花表情）
@property(nonatomic,strong)JPEmotionListView *lxhListView;
//使用strong引用，即使removeFromSuperview，表情内容视图还是存在

//表情键盘底部的选项框
@property(nonatomic,weak)JPEmotionTabBar *tabBar;
@end

@implementation JPEmotionKeyboard

//懒加载表情内容（只创建一次，不必每次切换表情内容都要再次创建）
-(JPEmotionListView *)recentListView{
    if(!_recentListView){
        _recentListView=[[JPEmotionListView alloc]init];
        //加载沙盒中的最近表情数组
        _recentListView.emotions=[JPEmotionTool recentEmotions];
    }
    return _recentListView;
}
-(JPEmotionListView *)defaultListView{
    if(!_defaultListView){
        _defaultListView=[[JPEmotionListView alloc]init];
//        NSString *path=[[NSBundle mainBundle] pathForResource:@"EmotionIcons/default/info" ofType:@"plist"];
//        //EmotionIcons/default/info：因为有3个同名的plist文件，所以要明确好路径
//        _defaultListView.emotions=[JPEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
        _defaultListView.emotions=[JPEmotionTool defaultEmotions];
    }
    return _defaultListView;
}
-(JPEmotionListView *)emojiListView{
    if(!_emojiListView){
        _emojiListView=[[JPEmotionListView alloc]init];
//        NSString *path=[[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info" ofType:@"plist"];
//        //EmotionIcons/emoji/info：因为有3个同名的plist文件，所以要明确好路径
//        _emojiListView.emotions=[JPEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
        _emojiListView.emotions=[JPEmotionTool emojiEmotions];
    }
    return _emojiListView;
}
-(JPEmotionListView *)lxhListView{
    if(!_lxhListView){
        _lxhListView=[[JPEmotionListView alloc]init];
//        NSString *path=[[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/info" ofType:@"plist"];
//        //EmotionIcons/lxh/info：因为有3个同名的plist文件，所以要明确好路径
//        _lxhListView.emotions=[JPEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
        _lxhListView.emotions=[JPEmotionTool lxhEmotions];
    }
    return _lxhListView;
}




-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        //创建并添加表情键盘底部的选项框
        JPEmotionTabBar *tabBar=[[JPEmotionTabBar alloc]init];
        tabBar.delegate=self;//设置自己为代理方
        [self addSubview:tabBar];
        self.tabBar=tabBar;
        
        //监听表情被点击的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelect) name:@"EmotionDidSelectNotification" object:nil];
    }
    return self;
}
-(void)dealloc{ //使用了通知要记得在销毁本程序时移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//监听表情被点击的通知的响应方法
-(void)emotionDidSelect{
    //刷新*最近表情*的内容
    //每次点击任意表情都会调用JPEmotionListView的setEmotions方法
    self.recentListView.emotions=[JPEmotionTool recentEmotions];
}

/* 设置子控件的frame要写在layoutSubviews方法中 */
//自定义 表情内容 和 表情键盘底部的选项框 的位置和尺寸
-(void)layoutSubviews{
    [super layoutSubviews];
    
    //1.tabBar
    self.tabBar.height=37;
    self.tabBar.width=self.width;
    self.tabBar.x=0;
    self.tabBar.y=self.height-self.tabBar.height;
    
    //2.showingListView
    self.showingListView.height=self.tabBar.y;
    self.showingListView.width=self.width;
    self.showingListView.x=0;
    self.showingListView.y=0;
    
}



#pragma mark - JPEmotionTabBarDelagete
//获取点击的是表情选项框上的哪个表情类型按钮
-(void)emotionTabBar:(JPEmotionTabBar *)tabBar didSelectButton:(JPEmotionTabBarButtonType)buttonType{
    
    //将表情文件夹拖进沙盒里时要选 Create folder references
    
    
    
    //1.移除showingListView之前显示的控件
    [self.showingListView removeFromSuperview];
    
    //2.根据按钮类型，切换contentView的listView
    switch (buttonType) {
        case JPEmotionTabBarButtonTypeRecent: {    // 最近
            [self addSubview:self.recentListView];
            break;
        }
        case JPEmotionTabBarButtonTypeDefault: {   // 默认
            [self addSubview:self.defaultListView];
            break;
        }
        case JPEmotionTabBarButtonTypeEmoji: {     // emoji
            [self addSubview:self.emojiListView];
            break;
        }
        case JPEmotionTabBarButtonTypeLxh: {       // 浪小花
            [self addSubview:self.lxhListView];
            break;
        }
        default:
            break;
    }
    
    //3.设置正在显示的listView
    self.showingListView = [self.subviews lastObject];
    
    //4.计算listView的frame
    [self setNeedsLayout];
    //setNeedsLayout：内部会在恰当的时机，重新调用layoutSubviews，重新布局子控件，包括子控件的子控件
    
    //统一使用showingListView容纳各种表情视图，要在引用之后再调用setNeedsLayout方法才可以得出showingListView的frame，界面才能显示出来
}

@end
