//
//  JPLrcsScrollView.m
//  QQ音乐
//
//  Created by ios app on 16/6/12.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPLrcsScrollView.h"
#import <Masonry.h>
#import "JPLrcsCell.h"
#import "JPLrcsTool.h"
#import "JPLrcLine.h"
#import "JPLrcsLabel.h"
#import "JPMusicTool.h"
#import "JPMusic.h"
#import <MediaPlayer/MediaPlayer.h>

@interface JPLrcsScrollView () <UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSArray *lrcs;
@property(nonatomic,assign)NSInteger currentLrcLineIndex;
@end

@implementation JPLrcsScrollView

-(void)setupTableView{
    UITableView *tableView=[[UITableView alloc] init];
    tableView.backgroundColor=[UIColor clearColor];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.rowHeight=55;
    
    [self addSubview:tableView];
    self.tableView=tableView;
}

-(void)awakeFromNib{
    [self setupTableView];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        [self setupTableView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
//    self.tableView.frame=CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
    
    self.tableView.translatesAutoresizingMaskIntoConstraints=NO;
    
    //Masonry框架：添加约束
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);             //上方置顶
        make.bottom.equalTo(self.mas_bottom);       //下方置顶
        make.trailing.equalTo(self.mas_trailing);   //右置顶
        
        //左边距离【一个屏幕的宽度】的大小
        make.leading.equalTo(self.mas_leading).offset(self.bounds.size.width);
        
        //要设置宽高（不知道为什么不设置就不能显示）
        make.width.equalTo(self.mas_width);         //宽相等
        make.height.equalTo(self.mas_height);       //高相等
    }];
    
    //设置内边距（让歌词居中显示）
    CGFloat inset=(self.bounds.size.height-self.tableView.rowHeight)*0.5;
    if (self.tableView.contentInset.top!=inset) {
        self.tableView.contentInset=UIEdgeInsetsMake(inset, 0, inset, 0);
        //设置完内边距及时滚到顶部
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lrcs.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JPLrcsCell *cell=[JPLrcsCell lrcsCellWithTableView:tableView];
    
    if (self.currentLrcLineIndex==indexPath.row) {          //正在播放
        cell.lrcsLabel.font=[UIFont systemFontOfSize:20];
    }else{                                                  //不是正在播放
        cell.lrcsLabel.font=[UIFont systemFontOfSize:14];
        cell.lrcsLabel.progress=0; //移除进度
    }
    
    JPLrcLine *lrcLine=self.lrcs[indexPath.row];
    
    cell.lrcsLabel.text=lrcLine.text;
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JPLrcLine *lrcLine=self.lrcs[indexPath.row];
    !self.timeBlock? : self.timeBlock(lrcLine.time);
}

#pragma mark - 解析歌词

-(void)setLrcsName:(NSString *)lrcsName{
    
    _lrcsName=[lrcsName copy];
    
    //解析歌词文件
    self.lrcs=[JPLrcsTool serializationLrcsWithLrcsName:lrcsName];
    
    self.currentLrcLineIndex=-1;    //重置下标
    
    [self.tableView reloadData];
    
    //重置之后滚到顶部
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    //设置锁屏界面的信息
    JPMusic *playingMusic=[JPMusicTool playingMusic];
    UIImage *playingImage=[UIImage imageNamed:playingMusic.icon];
    [self setupLockScreenInfoWithLockImage:playingImage];
    
}

#pragma mark - 根据当前播放时间滚动歌词

-(void)setCurrentTime:(NSTimeInterval)currentTime{
    _currentTime=currentTime;
    
    for (NSInteger i=0; i<self.lrcs.count; i++) {
        
        //获取当前歌词
        JPLrcLine *currentLrcLine=self.lrcs[i];
        
        //获取下一句歌词
        NSInteger nextIndex=i+1;
        JPLrcLine *nextLrcLine=nil;
        if (nextIndex<self.lrcs.count) {
            nextLrcLine=self.lrcs[nextIndex];
        }
        
        //刷新歌词
        //如果当前播放的歌词不是【记录】的歌词，且【当前播放时间】大于等于【当前歌词时间】且小于【下一句歌词时间】
        
        BOOL shouldUpdate=NO;
        if (nextLrcLine) {
            shouldUpdate=(self.currentLrcLineIndex!=i) && currentTime>=currentLrcLine.time && currentTime<nextLrcLine.time;
        }else{
            shouldUpdate=(self.currentLrcLineIndex!=i) && currentTime>=currentLrcLine.time;
        }
        
        if (shouldUpdate) {
            
            //则是当前播放的歌词
//            NSLog(@"%zd:%zd",(NSInteger)currentLrcLine.time/60,(NSInteger)currentLrcLine.time%60);
            
            //1.获取当前歌词行
            NSIndexPath *currentIndexPath=[NSIndexPath indexPathForRow:i inSection:0];
            
            //2.获取上一句歌词行
            NSIndexPath *lastIndexPath=[NSIndexPath indexPathForRow:self.currentLrcLineIndex inSection:0];
            
            //3.【记录】当前播放歌词的下标，用于判断：如果还是同一句歌词，则不要让tableView滚动，不让CADisplayLink一秒刷新60次会卡死tableView
            self.currentLrcLineIndex=i;
            
            //4.刷新当前行和上一句歌词行（修改字体）
            [self.tableView reloadRowsAtIndexPaths:@[lastIndexPath,currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            //5.让当前歌词滚到顶部
            [self.tableView scrollToRowAtIndexPath:currentIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
            //6.刷新封面歌词label内容
            self.lrcsLabel.text=currentLrcLine.text;
            
            //7.生成锁屏界面的图片
            [self generatorLockImage];
            
        }
        
        //设置歌词进度：根据进度显示label要填充多少
        if (self.currentLrcLineIndex==i) {
            //能来到这里就是正在播放的歌词
            
            //1.拿到正在播放的歌词的那个cell
            JPLrcsCell *cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            
            //2.更新label的进度
            CGFloat progress=0;
            if (nextLrcLine) {
                progress=(currentTime-currentLrcLine.time)/(nextLrcLine.time-currentLrcLine.time);
            }else{
                progress=(currentTime-currentLrcLine.time)/(self.duration-currentLrcLine.time);
            }
            
            cell.lrcsLabel.progress=progress;
            
            //3.刷新封面歌词label进度
            self.lrcsLabel.progress=progress;
        }
        
    }
    
}

#pragma mark - 生成锁屏界面的图片
-(void)generatorLockImage{
    
    //1.拿到当前歌曲的图片
    JPMusic *playingMusic=[JPMusicTool playingMusic];
    UIImage *playingImage=[UIImage imageNamed:playingMusic.icon];
    
    //2.获取当前歌词
    JPLrcLine *currentLrcLine=self.lrcs[self.currentLrcLineIndex];
    
    //2.1 获取上一句歌词
    JPLrcLine *lastLrcLine=nil;
    if (self.currentLrcLineIndex>0) {
        lastLrcLine=self.lrcs[self.currentLrcLineIndex-1];
    }
    
    //2.2 获取下一句歌词
    JPLrcLine *nextLrcLine=nil;
    if (self.currentLrcLineIndex<(self.lrcs.count-1)) {
        nextLrcLine=self.lrcs[self.currentLrcLineIndex+1];
    }
    
    //3.生成水印图片
    //3.1 获取上下文
    UIGraphicsBeginImageContext(playingImage.size);
    
    //3.2 将图片画上去
    [playingImage drawInRect:CGRectMake(0, 0, playingImage.size.width, playingImage.size.height)];
    
    //3.3 将歌词画到图片上
    CGFloat lrcsHeight=25;
    
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment=NSTextAlignmentCenter;
    
    [lastLrcLine.text drawInRect:
            CGRectMake(0, playingImage.size.height-3*lrcsHeight, playingImage.size.width, lrcsHeight)
                  withAttributes:
            @{NSForegroundColorAttributeName:[UIColor colorWithWhite:1.0 alpha:0.7],NSFontAttributeName:[UIFont systemFontOfSize:13],NSParagraphStyleAttributeName:paragraphStyle}];
    
    [currentLrcLine.text drawInRect:
            CGRectMake(0, playingImage.size.height-2*lrcsHeight, playingImage.size.width, lrcsHeight)
                     withAttributes:
            @{NSForegroundColorAttributeName:[UIColor colorWithWhite:1.0 alpha:1.0],NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paragraphStyle}];
    
    [nextLrcLine.text drawInRect:
            CGRectMake(0, playingImage.size.height-lrcsHeight, playingImage.size.width, lrcsHeight)
                  withAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithWhite:1.0 alpha:0.7],NSFontAttributeName:[UIFont systemFontOfSize:13],NSParagraphStyleAttributeName:paragraphStyle}];
    
    //3.4 生成图片
    UIImage *lockImage=UIGraphicsGetImageFromCurrentImageContext();
    
    //3.5 结束上下文
    UIGraphicsEndImageContext();
    
    //4.更新锁屏界面中心
    [self setupLockScreenInfoWithLockImage:lockImage];
    
}

#pragma mark - 设置锁屏界面的信息
-(void)setupLockScreenInfoWithLockImage:(UIImage *)lockImage{
    
    //1.获取锁屏界面中心
    MPNowPlayingInfoCenter *playingInfoCenter=[MPNowPlayingInfoCenter defaultCenter];
    
    //2.设置展示的信息
    
    JPMusic *playingMusic=[JPMusicTool playingMusic];
    NSMutableDictionary *playingInfo=[NSMutableDictionary dictionary];
    
    //2.1 歌名
    playingInfo[MPMediaItemPropertyAlbumTitle]=playingMusic.name;
    //2.2 作者名、歌手
    playingInfo[MPMediaItemPropertyArtist]=playingMusic.singer;
    //2.3 封面
    MPMediaItemArtwork *artwork=[[MPMediaItemArtwork alloc] initWithImage:lockImage];
    playingInfo[MPMediaItemPropertyArtwork]=artwork;
    //2.4 总播放时长
    playingInfo[MPMediaItemPropertyPlaybackDuration]=@(self.duration);
    //2.5 当前播放时长
    playingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime]=@(self.currentTime);
    
    playingInfoCenter.nowPlayingInfo=playingInfo;
    
    //3.让应用程序可以接受远程事件（远程事件：不是来自本程序的事件，例如锁屏界面点击的事件）
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
}

/*
 
 // MPMediaItemPropertyAlbumTitle
 // MPMediaItemPropertyAlbumTrackCount
 // MPMediaItemPropertyAlbumTrackNumber
 // MPMediaItemPropertyArtist
 // MPMediaItemPropertyArtwork
 // MPMediaItemPropertyComposer
 // MPMediaItemPropertyDiscCount
 // MPMediaItemPropertyDiscNumber
 // MPMediaItemPropertyGenre
 // MPMediaItemPropertyPersistentID
 // MPMediaItemPropertyPlaybackDuration
 // MPMediaItemPropertyTitle
 
 */

@end
