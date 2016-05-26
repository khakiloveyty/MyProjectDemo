//
//  JPHttpTool.h
//  Weibo
//
//  Created by apple on 15/7/26.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPHttpTool : NSObject
+(void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

+(void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
@end
