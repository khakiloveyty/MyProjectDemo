//
//  JPTopicVideoView.m
//  健平不得姐
//
//  Created by ios app on 16/5/27.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPTopicVideoView.h"
#import "JPTopic.h"
#import "JPShowPictureViewController.h"

@interface JPTopicVideoView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *videotimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@end

@implementation JPTopicVideoView

-(void)awakeFromNib{
    self.autoresizingMask=UIViewAutoresizingNone;//不会随父视图的改变而改变（xib文件有可能会拉伸）
    //参考：http://www.cocoachina.com/ios/20141216/10652.html

    //给图片添加监听器
    self.imageView.userInteractionEnabled=YES;//开启用户交互
    //添加点击事件：浏览图片
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture:)]];
}

//展示图片
-(void)showPicture:(UITapGestureRecognizer *)tap{
    
    //UIButton会拦截点击事件，点击seeBigBtn不会响应该方法，所以先将seeBigBtn的userInteractionEnabled关闭，这样就会将点击事件传递到self.imageView上
    
    //创建CATransition对象
    CATransition *animation=[CATransition animation];
    animation.duration=0.5;
    animation.type=kCATransitionFade;
    [KeyWindow.layer addAnimation:animation forKey:nil];
    
    JPShowPictureViewController *showPictureVC=[[JPShowPictureViewController alloc] init];
    showPictureVC.topic=self.topic;
    [KeyWindow.rootViewController presentViewController:showPictureVC animated:NO completion:nil];//使用根控制器就可以在任意地方弹出别的控制器了~
    
    //[UIApplication sharedApplication].keyWindow.rootViewController：根控制器
    
}

-(void)setTopic:(JPTopic *)topic{
    _topic=topic;
    
    //图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.big_image]];
    
    //播放次数
    self.playcountLabel.text=[NSString stringWithFormat:@"%zd播放",topic.playcount];
    
    //播放时长
    NSInteger minute=topic.videotime/60;
    NSInteger second=topic.videotime%60;
    self.videotimeLabel.text=[NSString stringWithFormat:@"%02zd:%02zd",minute,second];
}

- (IBAction)playVideo:(UIButton *)sender {
    AVPlayerItem *item=[AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.topic.videouri]];
    JPTabBarController *tabBarController=(JPTabBarController *)KeyWindow.rootViewController;
    [tabBarController playWithPlayItem:item withTopicType:self.topic.type];
}
@end
