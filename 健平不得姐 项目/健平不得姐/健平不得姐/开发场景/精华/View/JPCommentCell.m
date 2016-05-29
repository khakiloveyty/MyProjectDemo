//
//  JPCommentCell.m
//  健平不得姐
//
//  Created by ios app on 16/5/29.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPCommentCell.h"
#import "JPComment.h"

@interface JPCommentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;

@end

@implementation JPCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setComment:(JPComment *)comment{
    _comment=comment;
    
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:comment.user.profile_image] placeholderImage:[UIImage imageNamed:JPDefaultUserIcon]];
    
    self.sexImageView.image=[comment.user.sex isEqualToString:JPUserSexMan]?[UIImage imageNamed:@"Profile_manIcon"]:[UIImage imageNamed:@"Profile_womanIcon"];
    
    self.usernameLabel.text=comment.user.username;
    
    self.contentLabel.text=comment.content;
    
    NSString *likeCount=nil;
    if (comment.like_count<10000) {
        likeCount=[NSString stringWithFormat:@"%zd",comment.like_count];
    }else{
        likeCount=[NSString stringWithFormat:@"%.1f万",comment.like_count/10000.0];
    }
    self.likeCountLabel.text=likeCount;
    
}

@end
