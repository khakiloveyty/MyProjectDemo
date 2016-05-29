//
//  JPComment.h
//  健平不得姐
//
//  Created by ios app on 16/5/27.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPUser.h"

@interface JPComment : NSObject
@property(nonatomic,copy)NSString *content; //评论内容
@property(nonatomic,copy)NSString *ctime; //评论时间
@property(nonatomic,assign)NSInteger like_count; //点赞数
@property(nonatomic,assign)NSInteger voicetime; //音频时长（单位：秒）
@property(nonatomic,copy)NSString *voiceuri; //音频地址
@property(nonatomic,strong)JPUser *user; //用户
@end
