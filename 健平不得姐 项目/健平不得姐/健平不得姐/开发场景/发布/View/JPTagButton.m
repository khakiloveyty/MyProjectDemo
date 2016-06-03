//
//  JPTagButton.m
//  健平不得姐
//
//  Created by ios app on 16/6/3.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPTagButton.h"

@implementation JPTagButton

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=JPTagColor;
        self.titleLabel.font=JPTagFont;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
    }
    return self;
}

-(void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    [self sizeToFit];
    
    self.width+=3*JPAddTagViewMargin;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    //设置文字在头，图片在尾
    self.titleLabel.x=JPAddTagViewMargin;
    self.imageView.x=CGRectGetMaxX(self.titleLabel.frame)+JPAddTagViewMargin;
}

////使按钮只有图片区域才响应
//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    if (CGRectContainsPoint(self.imageView.frame, point)) {
//        return [super hitTest:point withEvent:event];
//    }else{
//        return nil;
//    }
//}

@end
