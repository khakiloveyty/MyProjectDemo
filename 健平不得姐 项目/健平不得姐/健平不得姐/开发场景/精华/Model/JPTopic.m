//
//  JPTopic.m
//  健平不得姐
//
//  Created by ios app on 16/5/19.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPTopic.h"
#import "NSDate+Extension.h"

@implementation JPTopic

//自定义成员变量（自己重写了setter方法和getter方法的情况下就要自定义）
{
    CGFloat _cellHeight;    //要重新cellHeight的getter方法，所以要自定义成员变量
}

/*
 
 * 属性声明为@property ----> 编译器会自动生成setter方法和getter方法，和开头带有“_”的成员变量
 * 如果自己重写了setter方法和getter方法（两个都重写的情况），就不会帮你创建开头带有“_”的成员变量（没有这个变量了）
 
 * 属性带有readonly：默认只帮你生成getter方法的实现，若自己也重写了getter方法，相当于没有了编译器帮你生成的setter方法和getter方法，也就是没有了开头带有“_”的成员变量
 * 解决方法：自己声明一个成员变量
 * 注意：成员变量可以在@interface和@implementation里面声明，但@implementation里面只能声明成员变量
 
 */

//MJExtension框架方法：将【服务器返回的属性名】转化为【自定义的属性名】
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    /*
        @key：自定义的属性名
        @value：服务器返回的属性名
     */
    
    return @{
             @"imageWidth":@"width",
             @"imageHeight":@"height",
             @"small_image":@"image0",
             @"big_image":@"image1",
             @"mid_image":@"image2",
             @"topicID":@"id",
             
             @"top_cmt":@"top_cmt[0]"
             //映射：top_cmt[0]拿到这个数组的第一个元素
             //因为这个数组总是只有一个元素，所以只需要拿到它的第一个元素
             
             };
}

//MJExtension框架方法：定义自身某个【数组属性】的【元素类型】
+(NSDictionary *)mj_objectClassInArray{
    
    /*
        @key：数组属性名
        @value：元素类型（若不想导入该类型的头文件可直接使用字符串标明）
     */
    
//    return @{@"top_cmt":[JPComment class]};
    return @{@"top_cmt":@"JPComment"};
    
}

-(NSString *)create_time{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    formatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";//按服务器返回的格式设置
    
    //获取帖子的发布时间NSDate类
    NSDate *createDate=[formatter dateFromString:_create_time]; //NSString ---> NSDate
    
    //判断是否为今年
    if ([createDate isThisYear]) {
        if ([createDate isToday]) {
            //今天
            NSDateComponents *components=[[NSDate date] deltaFromDate:createDate]; //获取差值
            if (components.hour>=1) {
                //今天之内，大于1小时
                return [NSString stringWithFormat:@"%zd小时前",components.hour];
            }else if (components.minute>=1) {
                //大于1分钟且1小时之内（components.hour==0 && components.minute>=1）
                return [NSString stringWithFormat:@"%zd分钟前",components.minute];
            }else{
                //1分钟之内（components.hour==0 && components.minute==0）
                return @"刚刚";
            }
        }else if ([createDate isYesterday]){
            //昨天
            formatter.dateFormat=@"昨天 HH:mm:ss";
            return [formatter stringFromDate:createDate];
        }else{
            //比昨天更早之前，今年之内
            formatter.dateFormat=@"MM-dd HH:mm:ss"; //今年之内的就不用显示年份
            return [formatter stringFromDate:createDate];
        }
    }else{
        //如果不是今年，则按yyyy-MM-dd HH:mm:ss格式显示
        return _create_time;
    }
}

-(CGFloat)cellHeight{
    
    if (!_cellHeight) {
        
        //cell的内容最大尺寸
//        CGSize maxSize=CGSizeMake([UIScreen mainScreen].bounds.size.width-4*JPTopicCellMargin, MAXFLOAT);
        CGSize maxSize=CGSizeMake([UIScreen mainScreen].bounds.size.width-2*JPTopicCellMargin, MAXFLOAT);
        
        //文字label的高度
        
        //CGFloat textH=[topic.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:maxSize].height;
        
        NSMutableParagraphStyle *parag=[[NSMutableParagraphStyle alloc]init];
        parag.lineSpacing=JPTopicTextSpace;
        
        CGFloat textH=[self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:JPTopicTextFont],NSParagraphStyleAttributeName:parag} context:nil].size.height;
        
        //如果只有一行，就不需要加上行高
        if (textH<=JPTopicTextOneLineHeight) {
            _oneLineTopicText=YES;
            textH-=JPTopicTextSpace;
        }
        
        //boundingRectWithSize：根据文字内容算出文字所占的尺寸（sizeWithFont已过期）
        // *参数1：最大尺寸（限宽、限高）
        // *参数2：通常使用...LineFragmentOrigin，如果options参数为...LineFragmentOrigin，那么整个文本将以每行组成的矩形为单位计算整个文本的尺寸
        // *参数3：文字的属性（字体大小、间距）
        // *参数4：context上下文。包括一些信息，例如如何调整字间距以及缩放。最终，该对象包含的信息将用于文本绘制。该参数可为nil
        // 参考：http://blog.csdn.net/zhuzhihai1988/article/details/17387319
        
        
        
        //cell高度 = 文字label的y值 + 文字label高度 + 文字label与下方控件的间距
        _cellHeight=JPTopicCellTextY+textH+JPTopicCellMargin;

        if (self.type==JPPictureTopic) {
            //如果是图片，要加上【图片高度】和【图片与下方控件的间距】
            
            //按【最大宽度】算出【比例缩放后】的高度
            CGFloat pictureWidth=maxSize.width;
            CGFloat scale=self.imageHeight/self.imageWidth;
            CGFloat pictureHeiht=pictureWidth*scale;
            
            //如果图片高度超出最大值，则让它变为指定数值
            if (pictureHeiht>JPTopicCellPictureMaxHeight) {
                pictureHeiht=JPTopicCellPictureOrdinaryHeight;
                _bigPicture=YES;
            }
            
            //计算图片的frame
            CGFloat pictureX=JPTopicCellMargin;
            CGFloat pictureY=JPTopicCellTextY+textH+JPTopicCellMargin;
            _pictureFrame=CGRectMake(pictureX, pictureY, pictureWidth, pictureHeiht);
            
            //cell高度 += 图片高度 + 图片与下方控件的间距
            _cellHeight+=pictureHeiht+JPTopicCellMargin;
            
        }else if (self.type==JPVoiceTopic) {
        
            //计算声音图片的frame
            CGFloat voiceX=JPTopicCellMargin;
            CGFloat voiceY=JPTopicCellTextY+textH+JPTopicCellMargin;
            
            //按【最大宽度】算出【比例缩放后】的高度
            CGFloat voiceWidth=maxSize.width;
            CGFloat scale=self.imageHeight/self.imageWidth;
            CGFloat voiceHeiht=voiceWidth*scale;
            
            _voiceFrame=CGRectMake(voiceX, voiceY, voiceWidth, voiceHeiht);
            
            //cell高度 += 声音图片高度 + 图片与下方控件的间距
            _cellHeight+=voiceHeiht+JPTopicCellMargin;
            
        }else if (self.type==JPVideoTopic) {
            
            //计算声音图片的frame
            CGFloat videoX=JPTopicCellMargin;
            CGFloat videoY=JPTopicCellTextY+textH+JPTopicCellMargin;
            
            //按【最大宽度】算出【比例缩放后】的高度
            CGFloat videoWidth=maxSize.width;
            CGFloat scale=self.imageHeight/self.imageWidth;
            CGFloat videoHeiht=videoWidth*scale;
            
            _voiceFrame=CGRectMake(videoX, videoY, videoWidth, videoHeiht);
            
            //cell高度 += 声音图片高度 + 图片与下方控件的间距
            _cellHeight+=videoHeiht+JPTopicCellMargin;
            
        }
        
        //如果有热门评论，添加热门评论控件的高度
        if (self.top_cmt) {
                
            //cell高度 += 热门评论标题高度 + 热门评论内容上方内边距
            _cellHeight+=JPTopicCellHotCommentTitleHeight+JPTopicCellHotCommentContentMargin;
            
            maxSize=CGSizeMake(maxSize.width-2*JPTopicCellHotCommentContentMargin, MAXFLOAT); //评论内容需要添加左右内边距
            
            //已经不使用数组类型来保存最热评论（因为总是只有一个），不需要遍历叠加了
            CGFloat contentH=[[NSString stringWithFormat:@"%@ : %@",self.top_cmt.user.username,self.top_cmt.content] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height;
            
            //cell高度 += 热门评论内容高度
            _cellHeight+=contentH;
            
            //cell高度 += 热门评论内容下方内边距 + 热门评论与下方控件的间距
            _cellHeight+=JPTopicCellHotCommentContentMargin+JPTopicCellMargin;
        }
        
        //cell高度 += 底部工具条高度 + cell压缩的间距（因为y值压缩了，高度增加了，总体要多增加一个间距）
        _cellHeight+=JPTopicCellBottomBarHeight+JPTopicCellMargin;
        
        
        /**
         * 里面的JPTopicCellMargin：
         *  * 前面的JPTopicCellMargin：控件之间的间距
         *  * 最后的JPTopicCellMargin：是cell自身高度压缩了的间距（一样是JPTopicCellMargin的数值），加上就不会用有挤压
         */
        
    }
    
    return _cellHeight;
    
    /*
     
     * 总的来说，如果全部元素都有，则：
     * cell高度 = 文字label的y值 + 文字label高度 + 控件之间的间距 + 图片高度 + 控件之间的间距 + 热门评论标题高度 + 热门评论内容上方内边距 + 热门评论内容高度 + 热门评论内容下方内边距 + 控件之间的间距 + 底部工具条高度 + cell压缩的间距
     
     */
    
}

@end
