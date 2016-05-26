//
//  JPTextPart.h
//  Weibo
//
//  Created by apple on 15/7/28.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

//微博内容使用正则表达式之后打碎的某一段文字内容（有属性的或普通的）

#import <Foundation/Foundation.h>

@interface JPTextPart : NSObject
@property(nonatomic,copy)NSString *text;//文字内容
@property(nonatomic,assign)NSRange range;//文字范围

/** 是否为特殊文字 */
@property(nonatomic,assign,getter=isSpecial)BOOL special;
/** 是否为表情 */
@property(nonatomic,assign,getter=isEmotion)BOOL emotion;
@end
