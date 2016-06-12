//
//  JPLrcLine.h
//  QQ音乐
//
//  Created by ios app on 16/6/12.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPLrcLine : NSObject

+(instancetype)lrcLineWithLrcLineString:(NSString *)lrcLineString;

@property(nonatomic,assign,readonly)NSTimeInterval time;
@property(nonatomic,copy,readonly)NSString *text;
@end
