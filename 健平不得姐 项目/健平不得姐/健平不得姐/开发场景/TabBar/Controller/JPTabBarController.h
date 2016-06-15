//
//  JPTabBarController.h
//  Weibo
//
//  Created by apple on 15/7/4.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPTabBarController : UITabBarController
-(void)playWithPlayItem:(AVPlayerItem *)playerItem withTopicType:(JPTopicType)type;
-(void)pause;
@end
