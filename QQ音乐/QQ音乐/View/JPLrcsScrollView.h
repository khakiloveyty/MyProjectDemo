//
//  JPLrcsScrollView.h
//  QQ音乐
//
//  Created by ios app on 16/6/12.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPLrcsScrollView : UIScrollView
@property(nonatomic,weak)UITableView *tableView;

/** 歌词文件名 */
@property(nonatomic,copy)NSString *lrcsName;

/** 当前播放时间 */
@property(nonatomic,assign)NSTimeInterval currentTime;

@property(nonatomic,copy)void (^timeBlock)(NSTimeInterval time);
@end
