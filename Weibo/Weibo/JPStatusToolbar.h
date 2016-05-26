//
//  JPStatusToolbar.h
//  Weibo
//
//  Created by apple on 15/7/15.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JPStatus;

@interface JPStatusToolbar : UIView

+(instancetype)toolbar;

@property(nonatomic,strong)JPStatus *status;

@end
