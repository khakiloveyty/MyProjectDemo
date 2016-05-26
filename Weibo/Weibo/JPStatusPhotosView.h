//
//  JPStatusPhotosView.h
//  Weibo
//
//  Created by apple on 15/7/17.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

//微博配图的整体（显示1~9张图片）

#import <UIKit/UIKit.h>

@interface JPStatusPhotosView : UIView
@property(nonatomic,strong)NSArray *photos;//保存微博的配图
//根据微博配图数计算配图视图的Size
+(CGSize)sizeWithPhotosCount:(NSUInteger)count;
@end
