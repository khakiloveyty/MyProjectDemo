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

@interface JPTopicCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sinaVImageView;
@property (weak, nonatomic) IBOutlet UILabel *topicTextLabel;

@property (weak, nonatomic) IBOutlet UIButton *dingBtn;
@property (weak, nonatomic) IBOutlet UIButton *caiBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

//图片帖子中间的内容
@property(nonatomic,weak)JPTopicPictureView *pictureView;
//声音帖子中间的内容
@property(nonatomic,weak)JPTopicVoiceView *voiceView;
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

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor=[UIColor clearColor];

    self.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

-(void)setTopic:(JPTopic *)topic{
    _topic=topic;
    
    //设置头像
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:topic.profile_image] placeholderImage:[UIImage imageNamed:JPDefaultUserIcon]];
    
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
    
    //设置文本
    self.topicTextLabel.text=topic.text;
    
    self.pictureView.hidden=YES;
    self.voiceView.hidden=YES;
    
    //根据模型类型（帖子类型）添加对应的内容到cell的中间（图片、视频）
    if (topic.type==JPPictureTopic) {
        self.pictureView.topic=topic;
        self.pictureView.frame=topic.pictureFrame;
        self.pictureView.hidden=NO;
    }else if (topic.type==JPVoiceTopic){
        self.voiceView.topic=topic;
        self.voiceView.frame=topic.voiceFrame;
        self.voiceView.hidden=NO;
    }else if (topic.type==JPVideoTopic){
    
    }else{
        
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
    
    frame.origin.x=JPTopicCellMargin;
    frame.size.width-=2*JPTopicCellMargin;
    frame.origin.y+=JPTopicCellMargin;
    frame.size.height-=JPTopicCellMargin;
    
    [super setFrame:frame];
}

@end
