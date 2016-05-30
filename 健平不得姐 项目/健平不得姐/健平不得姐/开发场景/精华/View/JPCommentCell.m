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
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;

@end

@implementation JPCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.autoresizingMask=UIViewAutoresizingNone;//不会随父视图的改变而改变（xib文件有可能会拉伸）
    //参考：http://www.cocoachina.com/ios/20141216/10652.html
    
    self.backgroundColor=[UIColor clearColor];
    
    self.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    
    //设置没有点击高亮效果
    self.selectionStyle=UITableViewCellSelectionStyleNone;
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
    
    if (comment.voiceuri.length) {
        self.voiceBtn.hidden=NO;
        [self.voiceBtn setTitle:[NSString stringWithFormat:@"%zd''",comment.voicetime] forState:UIControlStateNormal];
    }else{
        self.voiceBtn.hidden=YES;
    }
}

//设置cell内间距
-(void)setFrame:(CGRect)frame{
    
    frame.origin.x=JPTopicCellMargin;
    frame.size.width-=2*JPTopicCellMargin;
    
    [super setFrame:frame];
}

@end
