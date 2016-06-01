//
//  JPMeSquareButton.m
//  健平不得姐
//
//  Created by ios app on 16/6/1.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPMeSquareButton.h"
#import "JPMeSquare.h"
#import <UIButton+WebCache.h>

@implementation JPMeSquareButton

-(void)setup{
    self.titleLabel.textAlignment=NSTextAlignmentCenter;
    self.titleLabel.font=[UIFont systemFontOfSize:15];
    [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"mainCellBackground"] forState:UIControlStateNormal];
}

//通过xib创建
-(void)awakeFromNib{
    [self setup];
}

//通过代码创建
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    //设置文字在图片的下方
    
    //调整图片
    self.imageView.width=self.width*0.5;
    self.imageView.height=self.imageView.width;
    self.imageView.x=(self.width-self.imageView.width)*0.5;
    self.imageView.y=self.height*0.15;
    
    //调整文字
    self.titleLabel.x=0;
    self.titleLabel.y=CGRectGetMaxY(self.imageView.frame);
    self.titleLabel.width=self.width;
    self.titleLabel.height=self.height-self.titleLabel.y;
}

-(void)setMeSquare:(JPMeSquare *)meSquare{
    _meSquare=meSquare;
    
    [self setTitle:meSquare.name forState:UIControlStateNormal];
    
    //使用SDWebImage下载按钮图片
    [self sd_setImageWithURL:[NSURL URLWithString:meSquare.icon] forState:UIControlStateNormal];
}

@end
