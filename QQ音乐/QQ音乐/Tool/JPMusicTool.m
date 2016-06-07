//
//  JPMusicTool.m
//  QQ音乐
//
//  Created by ios app on 16/6/7.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPMusicTool.h"
#import <MJExtension.h>
#import "JPMusic.h"

@implementation JPMusicTool

static NSArray *musics_;
static JPMusic *playingMusic_;

+(void)initialize{
    //在第一次使用这个类时就加载这个数组（不需要每次都加载，只加载一次就够了）
    musics_=[JPMusic mj_objectArrayWithFile:[[NSBundle mainBundle] pathForResource:@"Musics" ofType:@"plist"]];
    
    //设置第一首歌曲为默认歌曲
    playingMusic_=musics_[0];
}

/** 获取所有歌曲模型 */
+(NSArray *)musics{
    return musics_;
}

/** 获取当前播放的歌曲模型 */
+(JPMusic *)playingMusic{
    return playingMusic_;
}

/** 设置当前播放的歌曲模型 */
+(void)setPlayingMusic:(JPMusic *)playingMusic{
    playingMusic_=playingMusic;
}

/** 获取下一首播放的歌曲模型 */
+(JPMusic *)nextMusic{
    //获取当前播放歌曲的下标
    NSInteger currentIndex=[musics_ indexOfObject:playingMusic_];
    
    NSInteger nextIndex=currentIndex+1;
    if (nextIndex>=musics_.count) {
        //如果超出范围，则返回第一首
        nextIndex=0;
    }
    
    return musics_[nextIndex];
}

/** 获取上一首播放的歌曲模型 */
+(JPMusic *)previousMusic{
    //获取当前播放歌曲的下标
    NSInteger currentIndex=[musics_ indexOfObject:playingMusic_];
    
    NSInteger previousIndex=currentIndex-1;
    if (previousIndex<0) {
        //如果超出范围，则返回最后一首
        previousIndex=musics_.count-1;
    }
    
    return musics_[previousIndex];
}

@end
