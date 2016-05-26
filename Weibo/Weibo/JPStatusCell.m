//
//  JPStatusCell.m
//  Weibo
//
//  Created by apple on 15/7/13.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPStatusCell.h"
#import "JPUser.h"
//#import "UIImageView+WebCache.h"//导入第三方框架SDWebImage
#import "JPPhoto.h"
#import "JPStatusToolbar.h"
#import "NSString+Extension.h"
#import "JPStatusPhotosView.h"
#import "JPIconView.h"
#import "JPStatusTextView.h"

//#import <CoreText/CoreText.h>

//RGB颜色
#define Color(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

//cell与cell之间的间距
#define StatusCellMargin 15
//cell的边框宽度
#define StatusCellBorderW 10

@interface JPStatusCell()
/* 原创微博 */
@property(nonatomic,weak)UIView *originalView;//整体view
@property(nonatomic,weak)JPIconView *iconView;//头像
@property(nonatomic,weak)JPStatusPhotosView *photosView;//配图
@property(nonatomic,weak)UIImageView *vipView;//会员图标
@property(nonatomic,weak)UILabel *nameLabel;//昵称
@property(nonatomic,weak)UILabel *timeLabel;//发布时间
@property(nonatomic,weak)UILabel *sourceLabel;//来源
@property(nonatomic,weak)JPStatusTextView *contentLabel;//微博正文

/* 转发微博 */
@property(nonatomic,weak)UIView *retweetView;//转发微博整体view
@property(nonatomic,weak)JPStatusTextView *retweetContentLabel;//转发微博正文+昵称
@property(nonatomic,weak)JPStatusPhotosView *retweetPhotosView;//转发配图

/* 底部工具条（转发、评论等） */
@property(nonatomic,weak)JPStatusToolbar *toolbar;

@end

@implementation JPStatusCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID=@"status";
    JPStatusCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[JPStatusCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}


/*
 * cell的初始化方法，一个cell只会调用一次
 * 一般在这里添加所有可能显示的子控件，以及子控件的一次性设置（字体样式、字体颜色等）
 */
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        //设置cell背景颜色
        self.backgroundColor=[UIColor clearColor];
        
        //设置cell被点击时不会变色（默认变灰色）
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        //***设置cell被点击时为其他颜色：***
//        UIView *bg=[[UIView alloc]init];
//        //bg.backgroundColor=[UIColor blueColor];//可以先设置颜色再放上去，或者放上去之后再设置
//        //self.selectedBackgroundView.backgroundColor=[UIColor blueColor];//不能直接设置颜色，因为还没有把view放上去，此时的selectedBackgroundView为空
//        self.selectedBackgroundView=bg;
//        self.selectedBackgroundView.backgroundColor=[UIColor blueColor];
        
        //初始化原创微博（创建子控件）
        [self setupOriginal];
        
        //初始化转发微博（创建子控件）
        [self setupRetweet];
        
        //初始化底部工具条（创建子控件）
        [self setupToolbar];

    }
    return self;
}


////重写setFrame方法（每个cell都会执行这方法）：为了使第一个cell与导航栏相隔一小段距离，让每个cell都往下挪一点点
//-(void)setFrame:(CGRect)frame{
//    frame.origin.y+=StatusCellMargin;//这个frame是系统先算好的（每个cell的原本位置），修改其y值
//    [super setFrame:frame];//让系统根据修改过的frame设置好每个cell的frame
//}
//又或者：修改间距在cell的上方（即在JPStatusFrame.m中修改原创微博的整体的y值，cell高度不需要再加间距）


/**
 * 初始化原创微博（创建子控件）
 */
-(void)setupOriginal{
    /* 原创微博 */
    
    //原创微博--整体view
    UIView *originalView=[[UIView alloc]init];
    originalView.backgroundColor=[UIColor whiteColor];//设置原创微博的背景颜色
    [self.contentView addSubview:originalView];
    self.originalView=originalView;
    
    //原创微博--头像
    JPIconView *iconView=[[JPIconView alloc]init];
    [self.originalView addSubview:iconView];
    self.iconView=iconView;
    
    //原创微博--会员图标
    UIImageView *vipView=[[UIImageView alloc]init];
    vipView.contentMode=UIViewContentModeCenter;//设置图片居中
    [self.originalView addSubview:vipView];
    self.vipView=vipView;
    
    //原创微博--昵称
    UILabel *nameLabel=[[UILabel alloc]init];
    //因为这label的内容的frame是按照规定好的字体大小来计算的，但label默认的字体大小为17
    //所有要修改成一致，不然显示不完全
    nameLabel.font=StatusCellNameFont;
    [self.originalView addSubview:nameLabel];
    self.nameLabel=nameLabel;
    
    //原创微博--发布时间
    UILabel *timeLabel=[[UILabel alloc]init];
    //同上
    timeLabel.font=StatusCellTimeFont;
    timeLabel.textColor=[UIColor orangeColor];//设置发布时间的字体颜色为橙色
    [self.originalView addSubview:timeLabel];
    self.timeLabel=timeLabel;
    
    //原创微博--来源
    UILabel *sourceLabel=[[UILabel alloc]init];
    //同上
    sourceLabel.font=StatusCellSourceFont;
    [self.originalView addSubview:sourceLabel];
    self.sourceLabel=sourceLabel;
    
    //原创微博--正文
    JPStatusTextView *contentLabel=[[JPStatusTextView alloc]init];
    //同上
    contentLabel.font=StatusCellContentFont;
    //设置可换无限行
    //contentLabel.numberOfLines=0;
    [self.originalView addSubview:contentLabel];
    self.contentLabel=contentLabel;
    
    //原创微博--配图
    JPStatusPhotosView *photosView=[[JPStatusPhotosView alloc]init];
    [self.originalView addSubview:photosView];
    self.photosView=photosView;
}

/**
 * 初始化被转发微博（创建子控件）
 */
-(void)setupRetweet{
    /* 被转发的微博 */
    
    //被转发的微博--整体view
    UIView *retweetView=[[UIView alloc]init];
    retweetView.backgroundColor=Color(240, 240, 240);//设置被转发的微博的背景颜色
    [self.contentView addSubview:retweetView];
    self.retweetView=retweetView;
    
    //被转发的微博--正文+昵称
    JPStatusTextView *retweetContentLabel=[[JPStatusTextView alloc]init];
    //同上
    retweetContentLabel.font=StatusCellRetweetContentFont;
    //设置可换无限行
    //retweetContentLabel.numberOfLines=0;
    [self.retweetView addSubview:retweetContentLabel];
    self.retweetContentLabel=retweetContentLabel;
    
    //被转发的微博--配图
    JPStatusPhotosView *retweetPhotosView=[[JPStatusPhotosView alloc]init];
    [self.retweetView addSubview:retweetPhotosView];
    self.retweetPhotosView=retweetPhotosView;
}

/**
 * 初始化底部工具条（创建子控件）
 */
-(void)setupToolbar{
    JPStatusToolbar *toolbar=[JPStatusToolbar toolbar];
    [self.contentView addSubview:toolbar];
    self.toolbar=toolbar;
}


//添加所有子控件并添加其内容
-(void)setStatusFrame:(JPStatusFrame *)statusFrame{
    
    _statusFrame=statusFrame;
    
    JPStatus *status=statusFrame.status;
    JPUser *user=status.user;
    
    
    
    /* 原创微博 */
    //原创微博--整体view
    self.originalView.frame=statusFrame.originalViewF;
    
    //原创微博--头像
    self.iconView.frame=statusFrame.iconViewF;
    //调用了重写的user属性的setter方法：加载头像图片并布局和加载加V图片
    self.iconView.user=user;
    
    //原创微博--配图
    if (status.pic_urls) {
        //如果有配图，才给配图添加图片
        self.photosView.frame=statusFrame.photosViewF;
        
        //将配图数组赋值给微博视图类中的图片数组
        //调用photos属性的setter方法：进行布局并加载图片
        self.photosView.photos=status.pic_urls;//调用重写的photos属性的setter方法
        
        //1.且设置好不隐藏
        self.photosView.hidden=NO;
    }else{
        //没有配图
        //2.要设置好隐藏
        self.photosView.hidden=YES;
        
        //1和2缺一不可，因为根据cell的重用机制，若不设置好，如果这条微博没有配图，当重用到有配图的那个cell，明明没有配图，却会有配图的显示
    }
    
    //原创微博--会员图标
    if (user.isVip) {
        self.vipView.hidden=NO;
        self.vipView.frame=statusFrame.vipViewF;
        //获取会员等级
        NSString *vipName=[NSString stringWithFormat:@"common_icon_membership_level%d",user.mbrank];
        //显示相应的会员图标
        self.vipView.image=[UIImage imageNamed:vipName];
        //修改会员名字颜色
        self.nameLabel.textColor=[UIColor orangeColor];
    }else{
        //普通用户名字颜色
        self.nameLabel.textColor=[UIColor blackColor];
        self.vipView.hidden=YES;
    }
    
    //原创微博--昵称
    self.nameLabel.frame=statusFrame.nameLabelF;
    self.nameLabel.text=user.name;
    
    
    /*
     *      因为重写了status.created_at的getter方法，所以每次重用cell时都会获取最新的发布时间和当前时间的时间差，所以发布时间的frame会动态发生变化（会出现显示不完整的情况），间接也使来源的frame也要发送变化，所以在cell.statusFrame的重写setter方法中，每次重用都重新计算一遍发布时间和来源的frame，保证内容能显示完整。
     */
    //原创微博--发布时间
    //self.timeLabel.frame=statusFrame.timeLabelF;//不能这样子赋值了，这只会保持最初的timeLabel的frame，不会动态修整
    /* 计算发布时间的frame */
    NSString *time=status.created_at;//每次调用重写的getter方法，获取最新的时间差
    CGFloat timeX=statusFrame.nameLabelF.origin.x;
    CGFloat timeY=CGRectGetMaxY(statusFrame.nameLabelF)+StatusCellBorderW;
    CGSize timeSize=[time sizeWithFont:StatusCellTimeFont];
    self.timeLabel.frame=(CGRect){{timeX,timeY},timeSize};
    //添加内容
    self.timeLabel.text=time;
    
    //原创微博--来源
    //self.sourceLabel.frame=statusFrame.sourceLabelF;//同上
    /* 计算来源的frame */
    CGFloat sourceX=CGRectGetMaxX(statusFrame.timeLabelF)+StatusCellBorderW;
    CGFloat sourceY=timeY;
    CGSize sourceSize=[status.source sizeWithFont:StatusCellSourceFont];
    self.sourceLabel.frame=(CGRect){{sourceX,sourceY},sourceSize};
    //添加内容
    self.sourceLabel.text=status.source;
    
    
    //原创微博--微博正文
    self.contentLabel.frame=statusFrame.contentLabelF;
    //status.text NSString --> NSAttributedString（在text的setter方法中转换）
    self.contentLabel.attributedText=status.attributedText;

    
    
    
    /* 被转发的微博 */
    //首先判断有没有转发微博
    if (status.retweeted_status) {  //有转发，则显示被转发的微博
        JPStatus *retweeted_status=status.retweeted_status;
        
        //1.设置不隐藏
        self.retweetView.hidden=NO;
        
        //被转发的微博--整体view
        self.retweetView.frame=statusFrame.retweetViewF;
        
        
        //被转发的微博--微博正文+昵称
        self.retweetContentLabel.frame=statusFrame.retweetContentLabelF;
        self.retweetContentLabel.attributedText=status.retweetedAttributedText;
        //不需要再写这句：self.retweetContentLabel.text=retweetContent;会把上面代码设置的内容覆盖；相反如果先写.text=xxx，再写.attributedText=xxx也会覆盖掉.text=xxx的内容

        
        //被转发的微博--配图
        if (retweeted_status.pic_urls) {
            //如果有配图，才给配图添加图片
            self.retweetPhotosView.frame=statusFrame.retweetPhotosViewF;
            
            //将配图数组赋值给微博视图类中的图片数组
            //调用photos属性的setter方法：进行布局并加载图片
            self.retweetPhotosView.photos=retweeted_status.pic_urls;
            
            //1.且设置好不隐藏
            self.retweetPhotosView.hidden=NO;
        }else{
            //没有配图
            //2.要设置好隐藏
            self.retweetPhotosView.hidden=YES;
            
            //1和2缺一不可，因为根据cell的重用机制，若不设置好，如果这条微博没有配图，当重用到有配图的那个cell，明明没有配图，却会有配图的显示
        }
        
    }else{  //没有转发，不显示被转发的微博
        
        //2.设置隐藏
        self.retweetView.hidden=YES;
        
        //1和2缺一不可，因为根据cell的重用机制，若不设置好，如果这条微博没有配图，当重用到有配图的那个cell，明明没有配图，却会有配图的显示
    }
    
    
    
    
    /* 底部工具条 */
    self.toolbar.frame=statusFrame.toolbarF;
    self.toolbar.status=status;
    
}

@end
