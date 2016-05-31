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

/**
 * < UIMenuController >
 * 让cell有资格成为第一响应者（有些控件是不能成为第一响应者，需要重写该方法）
 */
-(BOOL)canBecomeFirstResponder{
    return YES;
}

/**
 * < UIMenuController >
 * 让cell能执行哪些操作（比如copy、paste等）
 */
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return NO; //自定义操作，不需要系统自带的方法
}

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
    
    [self.profileImageView setCircleHeaderImage:comment.user.profile_image];
    
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
    
//    frame.origin.x=JPTopicCellMargin;
//    frame.size.width-=2*JPTopicCellMargin;
    
    [super setFrame:frame];
}

@end
