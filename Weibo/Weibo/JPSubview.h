//
//  JPSubview.h
//  Weibo
//
//  Created by apple on 15/7/29.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JPSubview;
//规定协议
@protocol JPSubviewDelegate <NSObject>
@optional
-(void)SubviewdidDismiss:(JPSubview *)sub;
@end

@interface JPSubview : UIView
@property(nonatomic,weak)id<JPSubviewDelegate> delegate;
@end
