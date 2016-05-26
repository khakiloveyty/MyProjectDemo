//
//  JPRecommendTypeCell.m
//  健平不得姐
//
//  Created by ios app on 16/5/13.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPRecommendTypeCell.h"
#import "JPRecommendType.h"

@interface JPRecommendTypeCell ()
@property (weak, nonatomic) IBOutlet UIView *selectedIndicatorView;
@end

@implementation JPRecommendTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor=JPRGB(244, 244, 244);
    self.textLabel.textColor=JPRGB(78, 78, 78);
    
    self.textLabel.textAlignment=NSTextAlignmentCenter;
    
    self.selectedIndicatorView.hidden=YES;
}

-(void)setRecommmendType:(JPRecommendType *)recommmendType{
    _recommmendType=recommmendType;
    
    self.textLabel.text=recommmendType.name;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    //重新布局内部textLabel的frame
    self.textLabel.y=2;
    self.textLabel.height=self.contentView.height-2*self.textLabel.y;
}

//cell点击响应方法
//设置了cell的selection为none，代表cell不会进入系统自带的高亮效果，所以要在这个方法里面自定义高亮效果
-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    self.selectedIndicatorView.hidden=!selected;
    self.textLabel.textColor=selected ? JPRGB(219, 21, 26) : JPRGB(78, 78, 78);
    self.backgroundColor=selected ? [UIColor whiteColor] : JPRGB(244, 244, 244);
}

@end
