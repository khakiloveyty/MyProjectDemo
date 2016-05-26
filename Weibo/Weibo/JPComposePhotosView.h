//
//  JPComposePhotosView.h
//  Weibo
//
//  Created by apple on 15/7/20.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

//要发布的图片的相册（存放拍照或者相册中选择的图片）

#import <UIKit/UIKit.h>

@interface JPComposePhotosView : UIView
-(void)addPhoto:(UIImage *)photo;

//保存要发布的微博图片的数组（只读，不让修改）
@property(nonatomic,strong,readonly)NSMutableArray *photos;

//声明了只读，既不会生成setter方法
//如果重写了getter方法，就不会生成“_”开头的成员变量
//也就是：同时重写了属性setter方法和getter方法，就不会生成“_”开头的成员变量

@end
