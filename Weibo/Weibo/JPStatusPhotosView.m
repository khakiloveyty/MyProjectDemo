//
//  JPStatusPhotosView.m
//  Weibo
//
//  Created by apple on 15/7/17.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPStatusPhotosView.h"
#import "JPPhoto.h"
#import "UIView+Extension.h"
#import "JPStatusPhoto.h"

#define StatusPhotoWH 70 //配图的尺寸
#define StatusPhotoMargin 10 //配图与配图之间的间距

/*
 新浪微博当只有一张配图时会以配图原本的宽高比显示，但是我们用的是开发者接口不是官方接口，没有返回配图的尺寸，所以不能实现这功能。
 */

//当微博配图只有4张图片时，以2×2方式排布，最大列数为2，其余情况最大列数则为3
#define StatusPhotoMaxCol(count) ((count==4)?2:3)

@implementation JPStatusPhotosView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

//重写图片数组的setter方法：
//在JPStatusCell的setStatusFrame方法中调用
-(void)setPhotos:(NSArray *)photos{
    _photos=photos;
    
    //创建*足够数量*的图片控件
    while (self.subviews.count<photos.count) {
        //当已经拥有的图片控件数还是小于这条微博的配图数
        //则新建
        JPStatusPhoto *photoView=[[JPStatusPhoto alloc]init];
        //再添加（到self.subviews）
        [self addSubview:photoView];
    }
    
    /* 有多少张才创建多少个图片控件，而且只创建一次 */
    /* 若已经创建的图片控件多于某条微博的配图数，则将多出来的图片控件隐藏掉，等需要用到时再显示出来 */
    
    //遍历所有的图片控件，设置图片
    for (int i=0; i<self.subviews.count; i++) {
        //获取图片控件
        JPStatusPhoto *photoView=self.subviews[i];
        
        if (i<photos.count) {
            //如果已经创建的图片控件跟微博配图数一样，则显示图片控件
            photoView.hidden=NO;
            
            //加载图片，调用重写的photo属性的setter方法
            photoView.photo=photos[i];//获取相应的图片模型
            
        }else{
            //否则已经创建的图片控件多于微博配图数，将多出来的图片控件隐藏
            photoView.hidden=YES;
        }
        
    }
}

/* 设置子控件的frame要写在layoutSubviews方法中 */
//设置图片控件的位置和尺寸
-(void)layoutSubviews{
    [super layoutSubviews];
    
    //获取最大列数
    NSUInteger maxCols=StatusPhotoMaxCol(self.photos.count);
    
    //遍历所有的图片控件，设置图片
    for (int i=0; i<self.photos.count; i++) {
        //获取图片控件
        UIImageView *photoView=self.subviews[i];
        
        //设置frame
        
        //获取所在列数
        int col=i%maxCols;
        photoView.x=col*(StatusPhotoWH+StatusPhotoMargin);
        
        //获取所在行数
        int row=i/maxCols;
        photoView.y=row*(StatusPhotoWH+StatusPhotoMargin);
        
        photoView.width=StatusPhotoWH;
        photoView.height=StatusPhotoWH;

    }
}

//根据微博配图数计算配图视图的Size
+(CGSize)sizeWithPhotosCount:(NSUInteger)count{
    
    //获取最大列数
    NSUInteger maxCols=StatusPhotoMaxCol(count);
    
    //计算列数
    NSUInteger cols=(count>=maxCols)? maxCols:count;
    //得出宽度
    CGFloat photosViewW=cols*StatusPhotoWH+(cols-1)*StatusPhotoMargin;
    
    //计算行数（count能整除3就是3、6、9张图，不能整除就是1、2、4、5、7、8张图）
    NSUInteger rows=(count%maxCols==0)? (count/maxCols):(count/maxCols+1);
    //NSUInteger rows=(count+3-1)/3;//行数=(图片数+最大列数-1)/最大列数;
    //得出高度
    CGFloat photosViewH=rows*StatusPhotoWH+(rows-1)*StatusPhotoMargin;
    
    return CGSizeMake(photosViewW, photosViewH);
}
@end
