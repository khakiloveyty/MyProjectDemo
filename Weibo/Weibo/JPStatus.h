//
//  JPStatus.h
//  Weibo
//
//  Created by apple on 15/7/10.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPUser.h"

@interface JPStatus : NSObject
/*
 * 模型：某条微博（的信息）
 * 其他参数详情看官方api文档，这里只取目前所需要用到的
 * idstr(string)：字符串型的微博ID
 * text(string)：微博信息内容
 * user(object)：微博作者的用户信息字段
 * created_at(string)：微博创建时间
 * source(string)：微博来源
 * pic_urls(NSArray)：微博配图地址。多图时返回多图链接，无配图返回“[]”
 * 
 * retweeted_status(object)：被转发的原微博信息字段，当该微博为转发微博时返回
 *
 * reposts_count(int)：转发数
 * comments_count(int)：评论数
 * attitudes_count(int)：表态数
 */
@property(nonatomic,copy)NSString *idstr; //微博ID

@property(nonatomic,copy)NSString *text; //微博内容
@property(nonatomic,copy)NSAttributedString *attributedText;//微博内容（带有表情和属性的文字）

@property(nonatomic,strong)JPUser *user; //微博用户

@property(nonatomic,copy)NSString *created_at; //微博发布时间
@property(nonatomic,copy)NSString *source; //微博来源

@property(nonatomic,strong)NSArray *pic_urls; //微博配图地址

/** 被转发的原微博信息字段，当该微博为转发微博时返回  */
@property(nonatomic,strong)JPStatus *retweeted_status;//被转发的微博（也是一个微博模型）
@property(nonatomic,copy)NSAttributedString *retweetedAttributedText;//被转发的微博内容（带有表情和属性的文字）

/* 工具条 */
@property(nonatomic,assign)int reposts_count; //转发数
@property(nonatomic,assign)int comments_count; //评论数
@property(nonatomic,assign)int attitudes_count; //表态数

@end
