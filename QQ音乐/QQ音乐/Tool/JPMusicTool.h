//
//  JPMusicTool.h
//  QQ音乐
//
//  Created by ios app on 16/6/7.
//  Copyright © 2016年 cb2015. All rights reserved.
//

// **** 提取歌曲模型工具类 ****

#import <Foundation/Foundation.h>
@class JPMusic;

@interface JPMusicTool : NSObject

/** 获取所有歌曲模型 */
+(NSArray *)musics;

/** 获取当前播放的歌曲模型 */
+(JPMusic *)playingMusic;

/** 设置当前播放的歌曲模型 */
+(void)setPlayingMusic:(JPMusic *)playingMusic;

/** 获取下一首播放的歌曲模型 */
+(JPMusic *)nextMusic;

/** 获取上一首播放的歌曲模型 */
+(JPMusic *)previousMusic;

@end
