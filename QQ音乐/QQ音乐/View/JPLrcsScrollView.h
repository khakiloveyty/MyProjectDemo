//
//  JPLrcsScrollView.h
//  QQ音乐
//
//  Created by ios app on 16/6/12.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JPLrcsLabel;

@interface JPLrcsScrollView : UIScrollView
@property(nonatomic,weak)UITableView *tableView;

/** 歌词文件名 */
@property(nonatomic,copy)NSString *lrcsName;

/** 当前播放时长 */
@property(nonatomic,assign)NSTimeInterval currentTime;

/** 歌曲总时长 */
@property(nonatomic,assign) NSTimeInterval duration;

/** 封面的歌词label */
@property(nonatomic,weak) JPLrcsLabel *lrcsLabel;

@property(nonatomic,copy)void (^timeBlock)(NSTimeInterval time);

@end
