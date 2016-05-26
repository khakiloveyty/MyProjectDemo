//
//  JPTextPart.m
//  Weibo
//
//  Created by apple on 15/7/28.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPTextPart.h"

@implementation JPTextPart
-(NSString *)description{
    return [NSString stringWithFormat:@"%@ - %@",self.text,NSStringFromRange(self.range)];
}
@end
