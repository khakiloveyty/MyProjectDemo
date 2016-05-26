//
//  JPComposePhotosView.m
//  Weibo
//
//  Created by apple on 15/7/20.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPComposePhotosView.h"
#import "UIView+Extension.h"

@implementation JPComposePhotosView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        //不能使用懒加载，因为声明了只读，懒加载即重写getter方法，生成不了成员变量
        _photos=[NSMutableArray array];
    }
    return self;
}

-(void)addPhoto:(UIImage *)photo{
    UIImageView *photoView=[[UIImageView alloc]init];
    photoView.image=photo;
    [self addSubview:photoView];
    
    //将选择的图片保存
    [self.photos addObject:photo];
}

/* 设置子控件的frame要写在layoutSubviews方法中 */
//自定义photoView的位置和尺寸
-(void)layoutSubviews{
    [super layoutSubviews];
    
    //获取最大列数
    NSUInteger maxCols=3;
    
    CGFloat imageWH=70;
    CGFloat imageMargin=10;
    
    //遍历所有的图片控件，设置图片
    for (int i=0; i<self.subviews.count; i++) {
        //获取图片控件
        UIImageView *photoView=self.subviews[i];
        
        //设置frame
        
        //获取所在列数
        int col=i%maxCols;
        photoView.x=col*(imageWH+imageMargin);
        
        //获取所在行数
        int row=i/maxCols;
        photoView.y=row*(imageWH+imageMargin);
        
        photoView.width=imageWH;
        photoView.height=imageWH;
        
    }
}

@end
