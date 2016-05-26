//
//  JPStatusPhoto.m
//  Weibo
//
//  Created by apple on 15/7/18.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPStatusPhoto.h"
#import "JPPhoto.h"
#import "UIImageView+WebCache.h"//导入第三方框架SDWebImage
#import "UIView+Extension.h"

@interface JPStatusPhoto()
@property(nonatomic,weak)UIImageView *gifImage;
@end

@implementation JPStatusPhoto

//gifImage懒加载：需要用到时调用
-(UIImageView *)gifImage{
    if (!_gifImage) {
        UIImageView *gifImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"timeline_image_gif"]];
        //initWithImage：按图片的尺寸创建
        [self addSubview:gifImage];
        self.gifImage=gifImage;
    }
    return _gifImage;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
        /*
         UIImageView的内容模式：
            UIViewContentModeScaleToFill ------ 拉伸图片至填充整个imageView（默认）
            UIViewContentModeScaleAspectFit --- 保持原来图片的宽高比拉伸缩放到imageView内完全显示（图片不是正方形的话会有空白部分）
            UIViewContentModeScaleAspectFill -- 保持原来图片的宽高比拉伸居中到imageView，拉伸至 图片的宽度\高度 等于 imageView的宽度\高度 为止（如果图片过大会则超出imageView范围）
            UIViewContentModeRedraw ----------- 当调用setNeedsDisplay方法也会将图片重绘一遍
            UIViewContentModeCenter ----------- 保持原来图片的尺寸放到imageView，中点重合
            UIViewContentModeTop -------------- 保持原来图片的尺寸放到imageView，顶部重合
            UIViewContentModeBottom ----------- 保持原来图片的尺寸放到imageView，底部重合
            UIViewContentModeLeft ------------- 保持原来图片的尺寸放到imageView，左边重合
            UIViewContentModeRight ------------ 保持原来图片的尺寸放到imageView，右边重合
            UIViewContentModeTopLeft ---------- 保持原来图片的尺寸放到imageView，左上重合
            UIViewContentModeTopRight --------- 保持原来图片的尺寸放到imageView，右上重合
            UIViewContentModeBottomLeft ------- 保持原来图片的尺寸放到imageView，左下重合
            UIViewContentModeBottomRight ------ 保持原来图片的尺寸放到imageView，右上重合
         
        规律：
            1.凡是带有Scale单词的，图片都会拉伸
            2.凡是带有Aspect单词的，图片都会保持原来的宽高比，即图片不会变形
         */
        
        //设置图片视图的内容模式
        self.contentMode=UIViewContentModeScaleAspectFill;
        //将超出imageView尺寸的部分剪切掉
        self.clipsToBounds=YES;
    }
    return self;
}

//重写photo属性的setter方法：加载图片
//在JPStatusPhotosView的setPhotos方法中调用
-(void)setPhoto:(JPPhoto *)photo{
    _photo=photo;
    //加载图片
    [self sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    
    //显示\隐藏gif提示控件
    //hasSuffix：判断后缀名 ---- 如果图片的后缀名是gif就显示gif图标，不是则隐藏
    //lowercaseString：将字符串以小写字母表示（防止出现后缀名为“GIF”）
    self.gifImage.hidden=![photo.thumbnail_pic.lowercaseString hasSuffix:@"gif"];
}

/* 设置子控件的frame要写在layoutSubviews方法中 */
//自定义gifImage的位置（设置为在图片的右下角）
-(void)layoutSubviews{
    [super layoutSubviews];
    self.gifImage.x=self.width-self.gifImage.width;
    self.gifImage.y=self.height-self.gifImage.height;
}

@end
