//
//  JPVerticalButton.m
//  健平不得姐
//
//  Created by ios app on 16/5/17.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPVerticalButton.h"

@implementation JPVerticalButton

-(void)setup{
    self.titleLabel.textAlignment=NSTextAlignmentCenter;
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
    self.imageView.x=0;
    self.imageView.y=0;
    self.imageView.width=self.width;
    self.imageView.height=self.imageView.width;
    
    //调整文字
    self.titleLabel.x=0;
    self.titleLabel.y=self.imageView.height;
    self.titleLabel.width=self.width;
    self.titleLabel.height=self.height-self.titleLabel.y;
}

@end
