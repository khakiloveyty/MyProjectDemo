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
    tableView.rowHeight=35;
    
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
    if (self.tableView.contentInset.top!=self.bounds.size.height*0.5) {
        self.tableView.contentInset=UIEdgeInsetsMake(self.bounds.size.height*0.5, 0, self.bounds.size.height*0.5, 0);
        //设置完内边距及时滚到顶部
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lrcs.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JPLrcsCell *cell=[JPLrcsCell lrcsCellWithTableView:tableView];
    
    if (self.currentLrcLineIndex==indexPath.row) {
        cell.textLabel.font=[UIFont systemFontOfSize:20];
    }else{
        cell.textLabel.font=[UIFont systemFontOfSize:14];
    }
    
    JPLrcLine *lrcLine=self.lrcs[indexPath.row];
    
    cell.textLabel.text=lrcLine.text;
    
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
    
    [self.tableView reloadData];
}

#pragma mark - 根据当前播放时间滚动歌词

-(void)setCurrentTime:(NSTimeInterval)currentTime{
    _currentTime=currentTime;
    
    //一切歌就滚到顶部
    if (currentTime==0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        return;
    }
    
    for (NSInteger i=0; i<self.lrcs.count; i++) {
        
        //获取当前歌词
        JPLrcLine *lrcLine=self.lrcs[i];
        
        //获取下一句歌词
        NSInteger nextIndex=i+1;
        JPLrcLine *nextLrcLine=nil;
        if (nextIndex<self.lrcs.count) {
            nextLrcLine=self.lrcs[nextIndex];
        }
        
        BOOL shouldUpdate=NO;
        if (nextLrcLine) {
            shouldUpdate=(self.currentLrcLineIndex!=i) && currentTime>=lrcLine.time && currentTime<nextLrcLine.time;
        }else{
            shouldUpdate=(self.currentLrcLineIndex!=i) && currentTime>=lrcLine.time;
        }
        
        //如果当前播放的歌词不是【记录】的歌词，且【当前播放时间】大于等于【当前歌词时间】且小于【下一句歌词时间】
        if (shouldUpdate) {
            
            //则是当前播放的歌词
            NSLog(@"%zd:%zd",(NSInteger)lrcLine.time/60,(NSInteger)lrcLine.time%60);
            
            //获取当前歌词行
            NSIndexPath *currentIndexPath=[NSIndexPath indexPathForRow:i inSection:0];
            
            //获取上一句歌词行
            NSIndexPath *lastIndexPath=[NSIndexPath indexPathForRow:self.currentLrcLineIndex inSection:0];
            
            //【记录】当前播放歌词的下标，用于判断：如果还是同一句歌词，则不要让tableView滚动，不让CADisplayLink一秒刷新60次会卡死tableView
            self.currentLrcLineIndex=i;
            
            //刷新当前行和上一句歌词行（修改字体）
            [self.tableView reloadRowsAtIndexPaths:@[lastIndexPath,currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            //让当前歌词滚到顶部
            [self.tableView scrollToRowAtIndexPath:currentIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
        }
        

    }
    
    
}

@end
