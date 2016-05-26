//
//  JPRecommendUserCell.m
//  健平不得姐
//
//  Created by ios app on 16/5/13.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPRecommendUserCell.h"
#import "JPRecommendUser.h"

@interface JPRecommendUserCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *focusBtn;

@end

@implementation JPRecommendUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setRecommmendUser:(JPRecommendUser *)recommmendUser{
    _recommmendUser=recommmendUser;
    
    self.screenNameLabel.text=recommmendUser.screen_name;
    
    NSString *fansCount=nil;
    if (recommmendUser.fans_count<10000) {
        fansCount=[NSString stringWithFormat:@"%zd人关注",recommmendUser.fans_count];
    }else{
        fansCount=[NSString stringWithFormat:@"%.1f万人关注",recommmendUser.fans_count/10000.0];
    }
    self.fansCountLabel.text=fansCount;
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:recommmendUser.header] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
}

@end
