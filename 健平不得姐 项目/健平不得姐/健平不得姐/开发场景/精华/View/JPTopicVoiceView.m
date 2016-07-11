//
//  JPTopicVoiceView.m
//  健平不得姐
//
//  Created by ios app on 16/5/27.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPTopicVoiceView.h"
#import "JPTopic.h"
#import "JPShowPictureViewController.h"

@interface JPTopicVoiceView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *voicetimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@end

@implementation JPTopicVoiceView



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
    
    JPShowPictureViewController *showPictureVC=[[JPShowPictureViewController alloc] init];
    showPictureVC.topic=self.topic;
    [KeyWindow.rootViewController presentViewController:showPictureVC animated:YES completion:nil];//使用根控制器就可以在任意地方弹出别的控制器了~
    
    //[UIApplication sharedApplication].keyWindow.rootViewController：根控制器
    
}

-(void)setTopic:(JPTopic *)topic{
    _topic=topic;
    
    //图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.big_image]];
    
    //播放次数
    self.playcountLabel.text=[NSString stringWithFormat:@"%zd播放",topic.playcount];
    
    //播放时长
    NSInteger minute=topic.voicetime/60;
    NSInteger second=topic.voicetime%60;
    self.voicetimeLabel.text=[NSString stringWithFormat:@"%02zd:%02zd",minute,second];
    
    self.playBtn.selected=self.topic.isPlaying;
}

- (IBAction)playVoice:(UIButton *)sender {
    self.playBtn.selected=!self.playBtn.selected;
    
    JPTabBarController *tabBarController=(JPTabBarController *)KeyWindow.rootViewController;
    
    if (self.playBtn.selected==YES) {
        self.topic.playing=YES;
        AVPlayerItem *item=[AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.topic.voiceuri]];
        [tabBarController playWithPlayItem:item withTopicType:self.topic.type];
    }else{
        self.topic.playing=NO;
        [tabBarController pause];
    }

}
@end
