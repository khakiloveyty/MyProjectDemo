//
//  JPAudioTool.h
//  封装播放音效
//
//  Created by ios app on 16/6/7.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface JPAudioTool : NSObject

/** 播放声音文件 */
+(void)playSoundWithSoundName:(NSString *)soundName;



/** 播放音乐文件 */
+(AVAudioPlayer *)playMusicWithSoundName:(NSString *)musicName;

/** 暂停音乐文件 */
+(void)pauseMusicWithSoundName:(NSString *)musicName;

/** 停止音乐文件 */
+(void)stopMusicWithSoundName:(NSString *)musicName;

@end
