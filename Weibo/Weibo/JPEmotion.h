//
//  JPEmotion.h
//  Weibo
//
//  Created by apple on 15/7/22.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

//表情模型

#import <Foundation/Foundation.h>

@interface JPEmotion : NSObject <NSCoding>//当需要用到归档技术把这个类的对象保存到沙盒中，就要遵守NSCoding协议，并设置好协议中的方法

/** 表情的文字描述（用于向新浪服务器发送请求的参数） */
@property(nonatomic,copy)NSString *chs;//简体
/** 表情的png图片名 */
@property(nonatomic,copy)NSString *png;

/** emoji表情的16进制编码 */
@property(nonatomic,copy)NSString *code;
//仅在emoji的plist文件中才有这属性，当其他表情通过这个模型类保存数据，那么这个code属性为空，相反是emoji表情通过这个模型类保存数据的话，那另外两个属性则为空

@end
