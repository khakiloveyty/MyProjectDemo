//
//  JPTopicCell.m
//  健平不得姐
//
//  Created by ios app on 16/5/19.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPTopicCell.h"
#import "JPTopic.h"
#import "NSDate+Extension.h"
#import "JPTopicPictureView.h"
#import "JPTopicVoiceView.h"
#import "JPTopicVideoView.h"

@interface JPTopicCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView; //头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel; //名称控件
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel; //创建时间控件
@property (weak, nonatomic) IBOutlet UIImageView *sinaVImageView; //新浪vip图标
@property (weak, nonatomic) IBOutlet UILabel *topicTextLabel; //帖子文本内容控件
@property (weak, nonatomic) IBOutlet UIView *hotCommentView; //热门评论整体控件
@property (weak, nonatomic) IBOutlet UILabel *hotCommentContentLabel; //热门评论内容控件

@property (weak, nonatomic) IBOutlet UIButton *dingBtn; //赞按钮
@property (weak, nonatomic) IBOutlet UIButton *caiBtn; //踩按钮
@property (weak, nonatomic) IBOutlet UIButton *shareBtn; //转发按钮
@property (weak, nonatomic) IBOutlet UIButton *commentBtn; //评论按钮

//图片帖子中间的内容
@property(nonatomic,weak)JPTopicPictureView *pictureView;
//声音帖子中间的内容
@property(nonatomic,weak)JPTopicVoiceView *voiceView;
//视频帖子中间的内容
@property(nonatomic,weak)JPTopicVideoView *videoView;
@end

@implementation JPTopicCell

/**
 * 注意：弱指针属性不能直接赋值，要先有个强引用指向这个对象（保住它的命），再赋值给这个弱指针
        （直接赋值它立马就挂了）
 */
-(JPTopicPictureView *)pictureView {
    if (!_pictureView) {
        JPTopicPictureView *pictureView=[JPTopicPictureView pictureView];
        
        //先添加到contentView上，这样pictureView就不会死了
        [self.contentView addSubview:pictureView];
        
        //再赋值
        _pictureView=pictureView;
    }
    return _pictureView;
}

-(JPTopicVoiceView *)voiceView {
    if (!_voiceView) {
        JPTopicVoiceView *voiceView=[JPTopicVoiceView voiceView];
        
        //先添加到contentView上，这样voiceView就不会死了
        [self.contentView addSubview:voiceView];
        
        //再赋值
        _voiceView=voiceView;
    }
    return _voiceView;
}

-(JPTopicVideoView *)videoView {
    if (!_videoView) {
        JPTopicVideoView *videoView=[JPTopicVideoView videoView];
        
        //先添加到contentView上，这样videoView就不会死了
        [self.contentView addSubview:videoView];
        
        //再赋值
        _videoView=videoView;
    }
    return _videoView;
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

+(instancetype)cell{
    return [[[NSBundle mainBundle] loadNibNamed:@"JPTopicCell" owner:nil options:nil] firstObject];
}

-(void)setTopic:(JPTopic *)topic{
    _topic=topic;
    
    //设置头像
    [self.profileImageView setCircleHeaderImage:topic.profile_image];
    
    //设置新浪加V标记是否显示
    self.sinaVImageView.hidden=!topic.isSina_v;
    
    //设置名称
    self.nameLabel.text=topic.name;
    
    //设置帖子的创建时间
    self.createTimeLabel.text=topic.create_time;//在该属性的getter方法中已经处理好（每次cell重用时都会重新调用getter方法，保证了时间的实时更新）
    
    //设置下方工具条按钮
    [self setButtonTitle:self.dingBtn count:topic.ding placeholder:@"顶"];
    [self setButtonTitle:self.caiBtn count:topic.cai placeholder:@"踩"];
    [self setButtonTitle:self.shareBtn count:topic.repost placeholder:@"转发"];
    [self setButtonTitle:self.commentBtn count:topic.comment placeholder:@"评论"];
    
    //设置文本内容
    NSMutableParagraphStyle *parag=[[NSMutableParagraphStyle alloc]init];
    if (topic.isOneLineTopicText==NO) {
        parag.lineSpacing=JPTopicTextSpace; //如果超过一行，则加上行高
    }
    NSMutableAttributedString *attrStr=[[NSMutableAttributedString alloc] initWithString:topic.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:JPTopicTextFont],NSParagraphStyleAttributeName:parag}];
    self.topicTextLabel.attributedText=attrStr;
    
    //根据模型类型（帖子类型）添加对应的内容到cell的中间（图片、视频）
    if (topic.type==JPPictureTopic) {       // -------------------- 图片
        
        self.pictureView.hidden=NO;
        self.pictureView.topic=topic;
        self.pictureView.frame=topic.pictureFrame;
        
        self.voiceView.hidden=YES;
        self.videoView.hidden=YES;
        
    }else if (topic.type==JPVoiceTopic){    // -------------------- 音频
        
        self.voiceView.hidden=NO;
        self.voiceView.topic=topic;
        self.voiceView.frame=topic.voiceFrame;
        
        self.pictureView.hidden=YES;
        self.videoView.hidden=YES;
        
    }else if (topic.type==JPVideoTopic){    // -------------------- 视频
        
        self.videoView.hidden=NO;
        self.videoView.topic=topic;
        self.videoView.frame=topic.voiceFrame;
        
        self.voiceView.hidden=YES;
        self.pictureView.hidden=YES;
        
    }else{                                  // -------------------- 段子
        self.pictureView.hidden=YES;
        self.voiceView.hidden=YES;
        self.videoView.hidden=YES;
    }
    
    //设置热门评论
    if (topic.top_cmt) {
    
        self.hotCommentView.hidden=NO;
        
        //已经不使用数组类型来保存最热评论（因为总是只有一个），不需要遍历叠加了
        self.hotCommentContentLabel.text=[NSString stringWithFormat:@"%@ : %@",topic.top_cmt.user.username,topic.top_cmt.content];
        
    }else{
        self.hotCommentView.hidden=YES;
    }
    
}

//修改显示的帖子发布时间（将该方法的逻辑放到JPTopic类的create_time属性的getter方法中）
//-(NSString *)topicCreateTimeWithTimeString:(NSString *)timeString{
//    
//    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
//    formatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";//按服务器返回的格式设置
//    
//    //获取帖子的发布时间NSDate类
//    NSDate *createDate=[formatter dateFromString:timeString]; //NSString ---> NSDate
//    
//    //判断是否为今年
//    if ([createDate isThisYear]) {
//        if ([createDate isToday]) {
//            //今天
//            NSDateComponents *components=[[NSDate date] deltaFromDate:createDate]; //获取差值
//            if (components.hour>=1) {
//                //今天之内，大于1小时
//                return [NSString stringWithFormat:@"%zd小时前",components.hour];
//            }else if (components.minute>=1) {
//                //大于1分钟且1小时之内（components.hour==0 && components.minute>=1）
//                return [NSString stringWithFormat:@"%zd分钟前",components.minute];
//            }else{
//                //1分钟之内（components.hour==0 && components.minute==0）
//                return @"刚刚";
//            }
//        }else if ([createDate isYesterday]){
//            //昨天
//            formatter.dateFormat=@"昨天 HH:mm:ss";
//            return [formatter stringFromDate:createDate];
//        }else{
//            //比昨天更早之前，今年之内
//            formatter.dateFormat=@"MM-dd HH:mm:ss"; //今年之内的就不用显示年份
//            return [formatter stringFromDate:createDate];
//        }
//    }else{
//        //如果不是今年，则按yyyy-MM-dd HH:mm:ss格式显示
//        return timeString;
//    }
//}

//设置按钮文字
-(void)setButtonTitle:(UIButton *)button count:(NSInteger)count placeholder:(NSString *)placeholder{
    
    if (count>=10000) {
        placeholder=[NSString stringWithFormat:@"%.1f万",count/10000.0];
    }else if (count>0) {
        placeholder=[NSString stringWithFormat:@"%zd",count];
    }
    
    [button setTitle:placeholder forState:UIControlStateNormal];
}

//设置cell内间距
-(void)setFrame:(CGRect)frame{
    
//    frame.origin.x=JPTopicCellMargin;
//    frame.size.width-=2*JPTopicCellMargin;
    frame.origin.y+=JPTopicCellMargin;
    frame.size.height-=JPTopicCellMargin;
    
    [super setFrame:frame];
}

- (IBAction)more:(id)sender {
    
    UIAlertController *alertC=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *collectAction=[UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        JPLog(@"收藏");
    }];
    
    UIAlertAction *reportAction=[UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        JPLog(@"举报");
    }];
    
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertC addAction:collectAction];
    [alertC addAction:reportAction];
    [alertC addAction:cancelAction];
    
    [KeyWindow.rootViewController presentViewController:alertC animated:YES completion:nil];
}

@end
