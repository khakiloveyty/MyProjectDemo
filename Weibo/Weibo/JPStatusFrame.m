//
//  JPStatusFrame.m
//  Weibo
//
//  Created by apple on 15/7/13.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPStatusFrame.h"
#import "NSString+Extension.h"
#import "JPStatusPhotosView.h"

#define StatusCellBorderW 10 //cell的边框宽度
#define StatusCellMargin 15 //cell与cell之间的间距

@implementation JPStatusFrame

//重写status属性的setter方法：获取status的同时计算出微博上的每个控件的frame
-(void)setStatus:(JPStatus *)status{
    
    _status=status;
    JPUser *user=status.user;
    
    //获取cell的宽度
    CGFloat cellWidth=[UIScreen mainScreen].bounds.size.width;
    
    /* 原创微博的frame */
    //原创微博--头像
    CGFloat iconWH=40;
    CGFloat iconX=StatusCellBorderW;
    CGFloat iconY=StatusCellBorderW;
    self.iconViewF=CGRectMake(iconX, iconY, iconWH, iconWH);
    
    //原创微博--昵称
    CGFloat nameX=CGRectGetMaxX(self.iconViewF)+StatusCellBorderW;
    CGFloat nameY=iconY;
    CGSize nameSize=[user.name sizeWithFont:StatusCellNameFont];
    self.nameLabelF=(CGRect){{nameX,nameY},nameSize};
    
    //原创微博--会员图标
    if (status.user.isVip) {
        CGFloat vipX=CGRectGetMaxX(self.nameLabelF)+StatusCellBorderW;
        CGFloat vipY=nameY;
        CGFloat vipH=nameSize.height;
        CGFloat vipW=14;
        self.vipViewF=CGRectMake(vipX, vipY, vipW, vipH);
    }
    
    //原创微博--发布时间
    CGFloat timeX=nameX;
    CGFloat timeY=CGRectGetMaxY(self.nameLabelF)+StatusCellBorderW;
    CGSize timeSize=[status.created_at sizeWithFont:StatusCellTimeFont];
    self.timeLabelF=(CGRect){{timeX,timeY},timeSize};
    
    //原创微博--来源
    CGFloat sourceX=CGRectGetMaxX(self.timeLabelF)+StatusCellBorderW;
    CGFloat sourceY=timeY;
    CGSize sourceSize=[status.source sizeWithFont:StatusCellSourceFont];
    self.sourceLabelF=(CGRect){{sourceX,sourceY},sourceSize};

    //原创微博--微博正文
    CGFloat contentX=iconX;
    CGFloat contentY=MAX(CGRectGetMaxY(self.iconViewF), CGRectGetMaxY(self.timeLabelF))+StatusCellBorderW;
    //获取最大宽度
    CGFloat maxW=cellWidth-2*contentX;
    //CGSize contentSize=[status.text sizeWithFont:StatusCellContentFont andMaxWidth:maxW];
    //根据attributedText设置*微博正文*的尺寸
    CGSize contentSize=[status.attributedText boundingRectWithSize:CGSizeMake(maxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.contentLabelF=(CGRect){{contentX,contentY},contentSize};
    
    //原创微博--配图
    CGFloat originalH=0;//先初始化原创微博的整体高度（因为要根据有无配图才能设置整体的高度）
    if (status.pic_urls.count) {
        //如果有配图，才配置配图的frame
        CGFloat photosViewX=contentX;
        CGFloat photosViewY=CGRectGetMaxY(self.contentLabelF)+StatusCellBorderW;
        CGSize photosViewSize=[JPStatusPhotosView sizeWithPhotosCount:status.pic_urls.count];
        self.photosViewF=(CGRect){{photosViewX,photosViewY},photosViewSize};
        //整体高度则算上配图的高度
        originalH=CGRectGetMaxY(self.photosViewF)+StatusCellBorderW;
    }else{
        //没有配图
        //整个高度不用算上配图的高度
        originalH=CGRectGetMaxY(self.contentLabelF)+StatusCellBorderW;
    }
    
    //原创微博--整体view
    CGFloat originalX=0;
    CGFloat originalY=/*0*/StatusCellMargin; //为了让第一个cell和导航栏之间、cell与cell之间保持一小段间距
    CGFloat originalW=cellWidth;
    self.originalViewF=CGRectMake(originalX, originalY, originalW, originalH);
    
    CGFloat toolbarY=0;//在这初始化底部工具条的Y值（因为要根据有无转发微博才能设置底部工具条的Y值）
    
    /* 被转发的微博的frame */
    //先判断有没有转发微博
    if (status.retweeted_status) {
        JPStatus *retweeted_status=status.retweeted_status;
        //JPUser *retweeted_status_user=retweeted_status.user;
        
        //被转法的微博--正文+昵称
        CGFloat retweetContentX=StatusCellBorderW;
        CGFloat retweetContentY=StatusCellBorderW;
        //获取最大宽度
        CGFloat maxW=cellWidth-2*StatusCellBorderW;
        //NSString *retweetContent=[NSString stringWithFormat:@"@%@ : %@",retweeted_status_user.name,retweeted_status.text];
        //CGSize retweetContentSize=[retweetContent sizeWithFont:StatusCellRetweetContentFont andMaxWidth:maxW];
        //根据retweetedAttributedText设置*被转法的微博--正文+昵称*的尺寸
        CGSize retweetContentSize=[status.retweetedAttributedText boundingRectWithSize:CGSizeMake(maxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        self.retweetContentLabelF=(CGRect){{retweetContentX,retweetContentY},retweetContentSize};
        
        //被转法的微博--配图
        CGFloat retweetViewH=0;//先初始化原创微博的整体高度（因为要根据有无配图才能设置整体的高度）
        if (retweeted_status.pic_urls.count) {
            //如果有配图，才配置配图的frame
            CGFloat retweetPhotosViewX=StatusCellBorderW;
            CGFloat retweetPhotosViewY=CGRectGetMaxY(self.retweetContentLabelF)+StatusCellBorderW;
            CGSize retweetPhotosViewSize=[JPStatusPhotosView sizeWithPhotosCount:retweeted_status.pic_urls.count];
            self.retweetPhotosViewF=(CGRect){{retweetPhotosViewX,retweetPhotosViewY},retweetPhotosViewSize};
            //整体高度则算上配图的高度
            retweetViewH=CGRectGetMaxY(self.retweetPhotosViewF)+StatusCellBorderW;
        }else{
            //没有配图
            //整个高度不用算上配图的高度
            retweetViewH=CGRectGetMaxY(self.retweetContentLabelF)+StatusCellBorderW;
        }
        
        //被转法的微博--整体view
        CGFloat retweetViewX=0;
        CGFloat retweetViewY=CGRectGetMaxY(self.originalViewF);
        CGFloat retweetViewW=cellWidth;
        self.retweetViewF=CGRectMake(retweetViewX, retweetViewY, retweetViewW, retweetViewH);

        toolbarY=CGRectGetMaxY(self.retweetViewF);//有转发微博，则按*转发微博*的整体算其Y值
    }else{
        toolbarY=CGRectGetMaxY(self.originalViewF);//没有转发微博，则按*原创微博*的整体算其Y值
    }
    
    
    
    /* 底部工具条的frame */
    CGFloat toolbarX=0;
    CGFloat toolbarW=cellWidth;
    CGFloat toolbarH=35;
    self.toolbarF=CGRectMake(toolbarX, toolbarY, toolbarW, toolbarH);

    
    
    /* cell的高度 */
    self.cellHeight=CGRectGetMaxY(self.toolbarF)/*+StatusCellMargin*/;
    
}

@end
