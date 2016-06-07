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

//在第一次使用这个类时就加载这个数组（不需要每次都加载，只加载一次就够了）
+(void)initialize{
    musics_=[JPMusic mj_objectArrayWithFile:[[NSBundle mainBundle] pathForResource:@"Musics" ofType:@"plist"]];
}

+(NSArray *)musics{
    return musics_;
}
@end
