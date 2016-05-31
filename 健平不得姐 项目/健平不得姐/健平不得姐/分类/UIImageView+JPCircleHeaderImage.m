//
//  UIImageView+JPCircleHeaderImage.m
//  健平不得姐
//
//  Created by ios app on 16/5/31.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "UIImageView+JPCircleHeaderImage.h"

@implementation UIImageView (JPCircleHeaderImage)

-(void)setCircleHeaderImage:(NSString *)urlStr{
    [self sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[[UIImage imageNamed:JPDefaultUserIcon] circleImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) self.image=[image circleImage];
    }];
}

@end
