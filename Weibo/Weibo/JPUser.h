//
//  JPUser.h
//  Weibo
//
//  Created by apple on 15/7/10.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import <Foundation/Foundation.h>

//自定义枚举 --- 根据verified_type返回的数字判定微博认证类型
typedef enum {
    JPUserVerifiedTypeNone=-1, //没有任何认证
    
    JPUserVerifiedPersonal=0,   //个人认证：明星
    
    //官方认证：
    JPUserVerifiedOrgEnterprice=2,  //企业官方：搜狐新闻客户端、CSDN等
    JPUserVerifiedOrgMedia=3,   //媒体官方：南方日报
    JPUserVerifiedOrgWebsite=5, //网站官方：天猫
    
    JPUserVerifiedDaren=220 //微博达人
    
} JPUserVerifiedType;

@interface JPUser : NSObject
/*  
 * 模型：某条微博所属用户的信息
 * 其他参数详情看官方api文档，这里只取目前所需要用到的
 * idstr(string)：字符串型的用户UID
 * name(string)：友好显示名称
 * profile_image_url(string)：用户头像地址（中图），50×50像素
 */
@property(nonatomic,copy)NSString *idstr;//字符串型的用户UID
@property(nonatomic,copy)NSString *name;//友好显示名称
@property(nonatomic,copy)NSString *profile_image_url;//用户头像地址（缩略图）

//会员类型，值 > 2，才是会员（小于等于2有可能是微博达人那种类型）
@property(nonatomic,assign)int mbtype;
//会员等级
@property(nonatomic,assign)int mbrank;
//判断是否为会员
@property(nonatomic,assign,getter=isVip)BOOL vip;

//微博认证类型（官方认证、微博达人等类型）
@property(nonatomic,assign)JPUserVerifiedType verified_type;
@end
