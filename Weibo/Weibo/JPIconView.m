//
//  JPIconView.m
//  Weibo
//
//  Created by apple on 15/7/18.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPIconView.h"
#import "JPUser.h"//导入了用户模型，同时把认证类型的枚举也导过来
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"

/*
 typedef enum {
 JPUserVerifiedTypeNone=-1, //没有任何认证
 
 JPUserVerifiedPersonal=0,   //个人认证：明星
 
 JPUserVerifiedOrgEnterprice=2,  //企业官方：搜狐新闻客户端、CSDN等
 JPUserVerifiedOrgMedia=3,   //媒体官方：南方日报
 JPUserVerifiedOrgWebsite=5, //网站官方：天猫
 
 JPUserVerifiedDaren=220 //微博达人
 
 } JPUserVerifiedType;
 */

@interface JPIconView()
@property(nonatomic,weak)UIImageView *verifiedView;
@end

@implementation JPIconView

//verifiedView懒加载：需要用到时调用
-(UIImageView *)verifiedView{
    if (!_verifiedView) {
        UIImageView *verifiedView=[[UIImageView alloc]init];
        [self addSubview:verifiedView];
        _verifiedView=verifiedView;
    }
    return _verifiedView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


//重写user属性的setter方法：加载头像图片和加V图片
//在JPStatusCell的setStatusFrame方法中调用
-(void)setUser:(JPUser *)user{
    _user=user;
    
    //1.下载图片
    [self sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    
    //2.设置加V图片（认证类型）
    switch (user.verified_type) {
        case JPUserVerifiedTypeNone:    //没有任何认证
            //根据tableViewCell的重用机制，必须设定好是否隐藏
            self.verifiedView.hidden=YES;
            break;
            
        case JPUserVerifiedPersonal:    //个人认证：明星
            self.verifiedView.hidden=NO;
            self.verifiedView.image=[UIImage imageNamed:@"avatar_vip"];
            break;
            
        //官方认证（共用同一个图标）：
        case JPUserVerifiedOrgEnterprice:   //企业官方：搜狐新闻客户端、CSDN等
        case JPUserVerifiedOrgMedia:        //媒体官方：南方日报
        case JPUserVerifiedOrgWebsite:      //网站官方：天猫
            self.verifiedView.hidden=NO;
            self.verifiedView.image=[UIImage imageNamed:@"avatar_enterprise_vip"];
            break;
            
        case JPUserVerifiedDaren:
            self.verifiedView.hidden=NO;
            self.verifiedView.image=[UIImage imageNamed:@"avatar_grassroot"];
            break;
            
        default:
            self.verifiedView.hidden=YES;
            break;
    }
}

/* 设置子控件的frame要写在layoutSubviews方法中 */
//自定义verifiedView的位置（设置为在头像的右下角突出一点）
-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.verifiedView.size=self.verifiedView.image.size;
    CGFloat scale=0.6;
    self.verifiedView.x=self.width-self.verifiedView.width*scale;
    self.verifiedView.y=self.height-self.verifiedView.height*scale;
}


@end
