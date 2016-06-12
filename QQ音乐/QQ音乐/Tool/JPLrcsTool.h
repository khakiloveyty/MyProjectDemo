//
//  JPLrcsTool.h
//  QQ音乐
//
//  Created by ios app on 16/6/12.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPLrcsTool : NSObject
/** 解析歌词文件 */
+(NSArray *)serializationLrcsWithLrcsName:(NSString *)lrcsName;
@end
