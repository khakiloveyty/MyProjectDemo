//
//  JPEssenceTitleCell.m
//  健平不得姐
//
//  Created by ios app on 16/5/18.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPEssenceTitleCell.h"

@interface JPEssenceTitleCell ()
@property(nonatomic,weak)UILabel *titleLabel;
@end

@implementation JPEssenceTitleCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        self.backgroundColor=[UIColor clearColor];
        
        UILabel *titleLabel=[[UILabel alloc] init];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.textColor=[UIColor grayColor];
        
        [self addSubview:titleLabel];
        self.titleLabel=titleLabel;
    }
    return self;
}

-(void)setTitle:(NSString *)title{
    _title=title;
    
    self.titleLabel.text=title;
    
    [self.titleLabel sizeToFit];
    
    self.titleLabel.center=CGPointMake(self.width/2, self.height/2);
    
    _titleLabelWidth=self.titleLabel.width;
    
}

//当手指点中cell时和collectionView调用selectItemAtIndexPath方法时会调用这方法
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.titleLabel.textColor = selected ? [UIColor redColor]:[UIColor grayColor];
}

@end
