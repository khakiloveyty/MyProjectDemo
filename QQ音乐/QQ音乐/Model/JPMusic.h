//
//  JPMusic.h
//  QQ音乐
//
//  Created by ios app on 16/6/7.
//  Copyright © 2016年 cb2015. All rights reserved.
//

// **** 歌曲模型类 ****

#import <Foundation/Foundation.h>

@interface JPMusic : NSObject
/** 歌手名 */
@property(nonatomic,copy)NSString *singer;

/** 歌曲文件名 */
@property(nonatomic,copy)NSString *filename;

/** 歌曲图标 */
@property(nonatomic,copy)NSString *icon;

/** 歌曲名 */
@property(nonatomic,copy)NSString *name;

/** 歌词文件名 */
@property(nonatomic,copy)NSString *lrcname;

/** 歌手图标 */
@property(nonatomic,copy)NSString *singerIcon;
@end
