//
//  JPPlayingViewController.m
//  QQ音乐
//
//  Created by ios app on 16/6/7.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPPlayingViewController.h"
#import <Masonry.h>
#import "JPMusicTool.h"
#import "JPMusic.h"
#import "JPAudioTool.h"

#define JPRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface JPPlayingViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *albumView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

// 滑块
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;


@property(nonatomic,strong)CADisplayLink *link;
@end

@implementation JPPlayingViewController

//设置状态栏为轻色系
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBlurView];
    
    [self setupBasic];
    
    [self startPlayingMusic];
   
}

#pragma mark - 添加毛玻璃效果

-(void)setupBlurView{
    UIToolbar *toolbar=[[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlack];
    [self.albumView addSubview:toolbar];
    
    toolbar.translatesAutoresizingMaskIntoConstraints=NO; //如果是从代码层面开始使用Autolayout,需要对使用的View的translatesAutoresizingMaskIntoConstraints的属性设置为NO.
    
    //Masonry框架：添加约束
    [toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.albumView.mas_top);
        make.bottom.equalTo(self.albumView.mas_bottom);
        make.leading.equalTo(self.albumView.mas_leading);
        make.trailing.equalTo(self.albumView.mas_trailing);
    }];
}

#pragma mark - 基本配置

-(void)setupBasic{
    //设置滑块进度的图片
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb"] forState:UIControlStateNormal];
    
    CABasicAnimation *anim=[CABasicAnimation animation];
    anim.keyPath=@"transform.rotation";
    anim.toValue=@(M_PI*2);
    anim.duration=10.0;
    anim.repeatCount=MAXFLOAT;
    [self.iconView.layer addAnimation:anim forKey:nil];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    //设置图标边线
    self.iconView.layer.masksToBounds=YES;
    self.iconView.layer.borderColor=JPRGB(36, 36, 36).CGColor;
    self.iconView.layer.borderWidth=8;
    
    //在这里才能获取准确的iconView的真实尺寸（如果在viewDidLoad里设置，获取的尺寸是故事版里面的尺寸，重新布局之后尺寸则会因约束而改变）
    self.iconView.layer.cornerRadius=self.iconView.bounds.size.height*0.5;
    
}

#pragma mark - 开始播放音乐

-(void)startPlayingMusic{
    
    //取出当前播放歌曲
    JPMusic *playingMusic=[JPMusicTool playingMusic];
    
    //配置页面
    self.albumView.image=[UIImage imageNamed:playingMusic.icon];
    self.iconView.image=[UIImage imageNamed:playingMusic.icon];
    self.songLabel.text=playingMusic.name;
    self.singerLabel.text=playingMusic.singer;
    
    //开始播放歌曲
    AVAudioPlayer *currentPlayer=[JPAudioTool playMusicWithSoundName:playingMusic.filename];
    
    //duration：歌曲总时长
    //currentTime：当前播放时长
    
    self.totalTimeLabel.text=[self stringWithTime:currentPlayer.duration];
    self.currentTimeLabel.text=[self stringWithTime:currentPlayer.currentTime];
    
    self.progressSlider.value=currentPlayer.currentTime/currentPlayer.duration;
    
    _link=[CADisplayLink displayLinkWithTarget:self selector:@selector(playMusic)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

//设置时间显示格式
-(NSString *)stringWithTime:(NSTimeInterval)time{
//    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
//    formatter.dateFormat=@"mm:ss";
//    
//    return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
    
    NSInteger min=time/60;
    NSInteger second=(NSInteger)time%60;
    
    return [NSString stringWithFormat:@"%02zd:%02zd",min,second];
}

-(void)playMusic{
    JPMusic *playingMusic=[JPMusicTool playingMusic];
    AVAudioPlayer *currentPlayer=[JPAudioTool playMusicWithSoundName:playingMusic.filename];
    
    self.currentTimeLabel.text=[self stringWithTime:currentPlayer.currentTime];
    self.progressSlider.value=currentPlayer.currentTime/currentPlayer.duration;
}

@end
