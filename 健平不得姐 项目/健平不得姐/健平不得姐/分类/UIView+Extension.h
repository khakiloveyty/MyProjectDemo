//
//  UIView+Extension.h
//  Weibo
//
//  Created by apple on 15/7/4.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property(nonatomic,assign)CGFloat x;
@property(nonatomic,assign)CGFloat y;
@property(nonatomic,assign)CGFloat centerX;
@property(nonatomic,assign)CGFloat centerY;
@property(nonatomic,assign)CGFloat width;
@property(nonatomic,assign)CGFloat height;
@property(nonatomic,assign)CGSize size;
@property(nonatomic,assign)CGPoint origin;

@property(nonatomic,assign,getter=isShowingOnKeyWindow)BOOL showingOnKeyWindow;

+(instancetype)viewLoadFromNib;

@end
