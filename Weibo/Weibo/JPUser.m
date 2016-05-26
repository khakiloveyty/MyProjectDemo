//
//  JPUser.m
//  Weibo
//
//  Created by apple on 15/7/10.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPUser.h"

@implementation JPUser

//重写mbtype的setter方法：一赋值就判断这个用户是否为会员
-(void)setMbtype:(int)mbtype{
    _mbtype=mbtype;
    self.vip=mbtype>2;
}

@end
