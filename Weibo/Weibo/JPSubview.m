//
//  JPSubview.m
//  Weibo
//
//  Created by apple on 15/7/29.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPSubview.h"

@implementation JPSubview

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[touches anyObject];
    CGPoint point=[touch locationInView:self];
    if (CGRectContainsPoint(CGRectMake(100, 0, self.bounds.size.width-100, self.bounds.size.height), point)) {
        //通知外界，自己被销毁了
        if ([self.delegate respondsToSelector:@selector(SubviewdidDismiss:)]) {
            [self.delegate SubviewdidDismiss:self];
        }
    }
}

@end
