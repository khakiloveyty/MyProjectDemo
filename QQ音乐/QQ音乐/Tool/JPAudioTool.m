//
//  JPAudioTool.m
//  封装播放音效
//
//  Created by ios app on 16/6/7.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPAudioTool.h"

@implementation JPAudioTool

static NSMutableDictionary *soundIDs_;

+(NSMutableDictionary *)soundIDs{
    //初始化字典
    if (!soundIDs_) {
        soundIDs_=[NSMutableDictionary dictionary];
    }
    return soundIDs_;
}

/** 播放声音文件 */
+(void)playSoundWithSoundName:(NSString *)soundName{
    
    if (!soundName) return;
    
    //1.定义SystemSoundID
    SystemSoundID soundID=0;
    
    //2.从字典中自动取出对应soundID，如果取出时nil，表示之前没有存放在字典
    soundID=[self.soundIDs[soundName] unsignedIntValue];
    
    if (soundID==0) {
        NSURL *url=[[NSBundle mainBundle] URLForResource:soundName withExtension:nil];
        
        if (!url) return;
        
        CFURLRef urlRef=(__bridge CFURLRef)(url);
        AudioServicesCreateSystemSoundID(urlRef, &soundID);
        
        self.soundIDs[soundName]=@(soundID);
    }
    
    AudioServicesPlayAlertSound(soundID);
}

//=====================================================================

static NSMutableDictionary *players_;

+(NSMutableDictionary *)players{
    //初始化字典
    if (!players_) {
        players_=[NSMutableDictionary dictionary];
    }
    return players_;
}

/** 播放音乐文件 */
+(AVAudioPlayer *)playMusicWithSoundName:(NSString *)musicName{
    
    if (!musicName) return nil;
    
    //1.定义播放器
    AVAudioPlayer *player=self.players[musicName];
    
    //2.从字典中去player，如果取出来是空，则创建对应的播放器
    if (!player) {
        //取出资源的url
        NSURL *url=[[NSBundle mainBundle] URLForResource:musicName withExtension:nil];
        
        if (!url) return nil;
        
        //创建播放器
        NSError *error=nil;
        player=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        
        //保存播放器
        self.players[musicName]=player;
        
        //准备播放
        [player prepareToPlay];
    
    }
    
    [player play];
    
    return player;
}

/** 暂停音乐文件 */
+(void)pauseMusicWithSoundName:(NSString *)musicName{
    AVAudioPlayer *player=self.players[musicName];
    if (player) [player pause];
}

/** 停止音乐文件 */
+(void)stopMusicWithSoundName:(NSString *)musicName{
    AVAudioPlayer *player=self.players[musicName];
    
    if (player) {
        
        [player stop];
        
        //从字典中移除
        [self.players removeObjectForKey:musicName];
        
        //清空播放器
        player=nil;
    }
}

@end
