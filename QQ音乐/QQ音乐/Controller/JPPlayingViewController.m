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
#import "NSString+JPTimeExtension.h"

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

// 定时器
@property(nonatomic,strong)NSTimer *progressTimer;

// 当前播放器
@property(nonatomic,weak)AVAudioPlayer *currentPlayer;

@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;
@property (weak, nonatomic) IBOutlet UIButton *lastBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
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
//        make.top.equalTo(self.albumView.mas_top);
//        make.bottom.equalTo(self.albumView.mas_bottom);
//        make.leading.equalTo(self.albumView.mas_leading);
//        make.trailing.equalTo(self.albumView.mas_trailing);
        make.edges.equalTo(self.albumView);
    }];
}

#pragma mark - 基本配置

-(void)setupBasic{
    //设置滑块进度的图片
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb"] forState:UIControlStateNormal];
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
    self.currentPlayer=currentPlayer;
    
    //设置播放/暂停按钮样式
    self.playOrPauseBtn.selected=self.currentPlayer.isPlaying;
    
    //duration：歌曲总时长
    //currentTime：当前播放时长
    self.totalTimeLabel.text=[NSString stringWithTime:currentPlayer.duration];
    self.currentTimeLabel.text=[NSString stringWithTime:currentPlayer.currentTime];
    
    //开始旋转动画
    [self startIconViewRotation];

    //添加定时器 ---- 更新播放进度
    [self removeProgressTimer]; //先移除已有的定时器
    [self addProgressTimer];
    
}

//添加旋转动画
-(void)startIconViewRotation{
    //设置中间图片旋转
    CABasicAnimation *anim=[CABasicAnimation animation];
    anim.keyPath=@"transform.rotation.z";
    anim.fromValue=@0;
    anim.toValue=@(M_PI*2);
    anim.duration=20.0;
    anim.repeatCount=MAXFLOAT;
    [self.iconView.layer addAnimation:anim forKey:nil];
}

#pragma mark - 定时器操作

//添加定时器
-(void)addProgressTimer{
    //先刷新播放进度
    [self updateProgressInfo];
    
    self.progressTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

//刷新播放进度
-(void)updateProgressInfo{
    self.currentTimeLabel.text=[NSString stringWithTime:self.currentPlayer.currentTime];
    self.progressSlider.value=self.currentPlayer.currentTime/self.currentPlayer.duration;
}

//移除定时器
-(void)removeProgressTimer{
    if (self.progressTimer) {
        [self.progressTimer invalidate];
        self.progressTimer=nil;
    }
}

#pragma mark - 监听progressSlider的事件处理（监听的是中间滑块）

//开始点击（touch down）
- (IBAction)startSlide {
    //移除定时器
    [self removeProgressTimer];
}

//进度值改变（Value Changed）
- (IBAction)slideValueChange {
    //刷新进度
    self.currentTimeLabel.text=[NSString stringWithTime:self.progressSlider.value*self.currentPlayer.duration];
}

//结束点击（touch up inside、touch up outside）
- (IBAction)endSlide {
    
    //播放拖拽的进度位置
    self.currentPlayer.currentTime=self.progressSlider.value*self.currentPlayer.duration;
    
    //添加定时器
   [self addProgressTimer];
}

//给progressSlider添加点击手势，监听点击
- (IBAction)sliderClick:(UITapGestureRecognizer *)sender {
    //获取点击的点
    CGPoint point=[sender locationInView:sender.view];
    
    //获取点击的点在progressSlider宽度的比例
    CGFloat sliderValue=point.x/self.progressSlider.bounds.size.width;
    
    //更改播放进度
    self.currentPlayer.currentTime=sliderValue*self.currentPlayer.duration;
    
    //更新滑块位置
    [self updateProgressInfo];
}

@end
