//
//  JPMeCell.m
//  健平不得姐
//
//  Created by ios app on 16/6/1.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPMeCell.h"

@implementation JPMeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator; //设置右边有箭头
        
        self.backgroundColor=[UIColor clearColor];
        self.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
        
        self.textLabel.textColor=[UIColor darkGrayColor];
        self.textLabel.font=[UIFont systemFontOfSize:16];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.imageView.image) {
        self.imageView.width=30;
        self.imageView.height=self.imageView.width;
        self.imageView.centerY=self.contentView.centerY;
        
        self.textLabel.x=CGRectGetMaxX(self.imageView.frame)+JPTopicCellMargin;
    }
    
}

@end
