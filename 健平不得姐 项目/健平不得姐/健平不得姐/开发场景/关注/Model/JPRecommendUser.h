//
//  JPRecommendUser.h
//  健平不得姐
//
//  Created by ios app on 16/5/13.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPRecommendUser : NSObject
@property(nonatomic,copy)NSString *introduction;
@property(nonatomic,copy)NSString *uid;
@property(nonatomic,copy)NSString *header;
@property(nonatomic,assign)NSInteger gender;
@property(nonatomic,assign)NSInteger is_vip;
@property(nonatomic,assign)NSInteger fans_count;
@property(nonatomic,assign)NSInteger tiezi_count;
@property(nonatomic,assign)NSInteger is_follow;
@property(nonatomic,copy)NSString *screen_name;
@end
