//
//  JPStatusFrame.h
//  Weibo
//
//  Created by apple on 15/7/13.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

//模型：保存微博数据，确定各个子控件在cell中的frame和cell的高度

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JPStatus.h"

#define StatusCellNameFont [UIFont systemFontOfSize:15] //昵称的字体大小
#define StatusCellTimeFont [UIFont systemFontOfSize:12] //时间的字体大小
#define StatusCellSourceFont [UIFont systemFontOfSize:12] //来源的字体大小

#define StatusCellContentFont [UIFont systemFontOfSize:14] //原创微博的正文的字体大小

#define StatusCellRetweetContentFont [UIFont systemFontOfSize:13] //被转发的微博的正文的字体大小

@interface JPStatusFrame : NSObject

//微博数据
@property(nonatomic,strong)JPStatus *status;

/* 原创微博及其子控件的Frame */
@property(nonatomic,assign)CGRect originalViewF;//整体view
@property(nonatomic,assign)CGRect iconViewF;//头像
@property(nonatomic,assign)CGRect photosViewF;//配图
@property(nonatomic,assign)CGRect vipViewF;//会员图标
@property(nonatomic,assign)CGRect nameLabelF;//昵称
@property(nonatomic,assign)CGRect timeLabelF;//发布时间
@property(nonatomic,assign)CGRect sourceLabelF;//来源
@property(nonatomic,assign)CGRect contentLabelF;//微博正文

/* 转发微博及其子控件的Frame */
@property(nonatomic,assign)CGRect retweetViewF;//转发微博整体view
@property(nonatomic,assign)CGRect retweetContentLabelF;//转发微博正文+昵称
@property(nonatomic,assign)CGRect retweetPhotosViewF;//转发配图

/* 底部工具条 */
@property(nonatomic,assign)CGRect toolbarF;

@property(nonatomic,assign)CGFloat cellHeight;//cell高度

@end
