//
//  JPTabBarController.m
//  Weibo
//
//  Created by apple on 15/7/4.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPTabBarController.h"
#import "JPEssenceViewController.h"
#import "JPNewTopicViewController.h"
#import "JPFriendTrendsViewController.h"
#import "JPMeViewController.h"
#import "JPTabBar.h"
#import "JPNavigationViewController.h"
#import <AVKit/AVKit.h>

@interface JPTabBarController ()
@property(nonatomic,strong)AVPlayer *player;
@property(nonatomic,strong)AVPlayerViewController *avViewController;
@end

@implementation JPTabBarController

//在第一次使用这个类时自动调用initialize方法（只调用一次，来设置全局属性）
+ (void)initialize{
    
    //设置文字的样式
    //没有被选中：
    NSMutableDictionary *textAttrs=[NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName]=[UIColor grayColor];
    
    //被选中时：
    NSMutableDictionary *selectTextAttrs=[NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName]=[UIColor darkGrayColor];
    
    //设置全局item属性
    UITabBarItem *item=[UITabBarItem appearance];
    //方法后面带有UI_APPEARANCE_SELECTOR宏的，都能通过appearance对象来统一设置
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.初始化子控制器
    JPEssenceViewController *essence=[[JPEssenceViewController alloc]init];
    [self addChildVcWithController:essence Title:@"精华" andImageName:@"tabBar_essence_icon" andSelectedImageName:@"tabBar_essence_click_icon"];
    
    JPNewTopicViewController *new=[[JPNewTopicViewController alloc]init];
    [self addChildVcWithController:new Title:@"新帖" andImageName:@"tabBar_new_icon" andSelectedImageName:@"tabBar_new_click_icon"];
    
    JPFriendTrendsViewController *friendTrends=[[JPFriendTrendsViewController alloc] init];
    [self addChildVcWithController:friendTrends Title:@"关注" andImageName:@"tabBar_friendTrends_icon" andSelectedImageName:@"tabBar_friendTrends_click_icon"];
    
    JPMeViewController *me=[[JPMeViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self addChildVcWithController:me Title:@"我" andImageName:@"tabBar_me_icon" andSelectedImageName:@"tabBar_me_click_icon"];
    
    //更换自定义的TabBar
    JPTabBar *tabBar=[[JPTabBar alloc]init];
    [self setValue:tabBar forKeyPath:@"tabBar"];
    //[self setValue:tabBar forKeyPath:@"tabBar"]; 这行代码过后，tabBar的delegate就是JPTabBarController
    //说明：所以不用再设置tabBar.delegate=self;
    
}

//设置控制器的tabBar样式（要有扩展性：不要在方法中创建控制器，因为有些控制器创建的方式不同，有些是init，有些是initWith...等等）
-(void)addChildVcWithController:(UIViewController *)childVc Title:(NSString *)title andImageName:(NSString *)imageName andSelectedImageName:(NSString *)selectedImageName{
    
//    childVc.title=title;//这一句相当于同时设置导航栏和tabBar的标签title
    
    childVc.tabBarItem.title=title;
//    childVc.navigationItem.title=title;
    
    //设置图片的样式
    //没有被选中时：
    childVc.tabBarItem.image=[UIImage imageNamed:imageName];
    
    //被选中时：
    //声明：这种图片以后按照原始的样子显示出来，不要自动渲染成蓝色（系统默认自动渲染成蓝色，需要手动设置）
    childVc.tabBarItem.selectedImage=[[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //imageWithRenderingMode：渲染模式
    //UIImageRenderingModeAlwaysOriginal：总是原样的模式
    
    //添加到导航控制器
    JPNavigationViewController *nav=[[JPNavigationViewController alloc]initWithRootViewController:childVc];
    
    //添加带有控制器的导航控制器到TabBarController
    [self addChildViewController:nav];
    
}

-(void)playWithPlayItem:(AVPlayerItem *)playerItem withTopicType:(JPTopicType)type{
    if (type==JPVoiceTopic) {
        if (self.player.currentItem!=playerItem) {
            self.player=[AVPlayer playerWithPlayerItem:playerItem];
        }
        [self.player play];
    }else if (type==JPVideoTopic){
        [self.player pause];
        self.avViewController=[[AVPlayerViewController alloc] init];
        self.avViewController.player=[AVPlayer playerWithPlayerItem:playerItem];
        [self presentViewController:self.avViewController animated:YES completion:^{
            [self.avViewController.player play];
        }];
    }
}

-(void)pause{
    if (self.player.currentItem) {
        [self.player pause];
    }
}

@end
