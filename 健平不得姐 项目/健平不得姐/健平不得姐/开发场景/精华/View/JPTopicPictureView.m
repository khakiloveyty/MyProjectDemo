//
//  JPTopicPictureView.m
//  健平不得姐
//
//  Created by ios app on 16/5/23.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPTopicPictureView.h"
#import "JPTopic.h"
#import "JPProgressView.h"
#import "JPShowPictureViewController.h"

@interface JPTopicPictureView () <JPShowPictureViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;//图片
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;//gif标识
@property (weak, nonatomic) IBOutlet UIButton *seeBigBtn;//放大按钮
@property (weak, nonatomic) IBOutlet JPProgressView *progressView;//进度条控件
@end

@implementation JPTopicPictureView

-(void)awakeFromNib{
    self.autoresizingMask=UIViewAutoresizingNone;//不会随父视图的改变而改变（xib文件有可能会拉伸）
    //参考：http://www.cocoachina.com/ios/20141216/10652.html
    
    //给图片添加监听器
    self.imageView.userInteractionEnabled=YES;//开启用户交互
    //添加点击事件：浏览图片
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture:)]];
}

//展示图片
-(void)showPicture:(UITapGestureRecognizer *)tap{
    
    //UIButton会拦截点击事件，点击seeBigBtn不会响应该方法，所以先将seeBigBtn的userInteractionEnabled关闭，这样就会将点击事件传递到self.imageView上
    
    //创建CATransition对象
    CATransition *animation=[CATransition animation];
    animation.duration=0.5;
    animation.type=kCATransitionFade;
    [KeyWindow.layer addAnimation:animation forKey:nil];
    
    JPShowPictureViewController *showPictureVC=[[JPShowPictureViewController alloc] init];
    showPictureVC.topic=self.topic;
    showPictureVC.delegate=self;
    [KeyWindow.rootViewController presentViewController:showPictureVC animated:NO completion:nil];//使用根控制器就可以在任意地方弹出别的控制器了~
    
    //[UIApplication sharedApplication].keyWindow.rootViewController：根控制器
    
}

-(void)updateTopic{
    if (self.topic.pictureProgress<1.0) {
        [self setTopic:self.topic];
    }
}

-(void)setTopic:(JPTopic *)topic{
    
    _topic=topic;
    
//    JPLog(@"下载完？%lf %@ %@",topic.pictureProgress,topic.name,self.imageView.image);
  
    self.progressView.hidden=YES;
    
    //立马显示最新的进度值（防止因为网速慢，导致显示的是其他cell的进度值）
    [self.progressView setProgress:topic.pictureProgress animated:NO];

    //判断是否为gif图片
    NSString *extension=topic.big_image.pathExtension;//取出图片URL的扩展名
    self.gifImageView.hidden=![extension.lowercaseString isEqualToString:@"gif"];
    //lowercaseString：转化为小写字母
    
    //判断是否为大图
    if (topic.isBigPicture) {
        //大图
        self.seeBigBtn.hidden=NO;//显示放大按钮
    }else{
        //小图
        self.seeBigBtn.hidden=YES;//隐藏放大按钮
    }
    
    //设置图片
    self.imageView.image=nil;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.big_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        //receivedSize：已下载的大小
        //expectedSize：总大小
        
        //计算并保存进度值
        topic.pictureProgress=1.0*receivedSize/expectedSize;
        
#warning 如果还没下载完毕，当前cell划出屏幕，sd会继续下载图片，但再划回来时，sd会重新下载图片，求解
        
        //显示进度值
        [self.progressView setProgress:topic.pictureProgress animated:NO];

        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error && image) {
            
            self.progressView.hidden=YES;
            topic.pictureProgress=1.0;
            
            //如果是大图，就需要绘制（只需要大图片顶部的部分）
            if (topic.isBigPicture) {
                //开启图形上下文
                //参数1：绘制区域
                //参数2：是否为不透明
                //参数3：适用于位图的比例因子。如果你指定一个值为0.0时,比例因子设置为设备的主屏幕的比例因子
                UIGraphicsBeginImageContextWithOptions(topic.pictureFrame.size, YES, 0.0);
                
                //设定图片尺寸（按原来尺寸按比例缩放）
                CGFloat width=topic.pictureFrame.size.width;
                CGFloat height=image.size.height*(width/image.size.width);
                
                //将下载完的image对象绘制到图形上下文
                [image drawInRect:CGRectMake(0, 0, width, height)];
                
                /*
                 image会自动拉伸填充上面设定好的尺寸，且已经放到(0,0)位置，由于self.imageView开启了clip subviews功能，会将多余的部分就裁剪掉，这样就能显示大图片的顶部部分
                 */
                
                //获得图片
                self.imageView.image=UIGraphicsGetImageFromCurrentImageContext();
                
                //结束图形上下文
                UIGraphicsEndImageContext();
            }
            
        }
    }];
    
}

/**
 * 苹果默认不会自动播放GIF图片
 * SDWebImage会自动播放gif图片，原理：SDWebImage会通过ImageIO将GIF图片解析成N个UIImage，再利用imageView.animationImages进行播放
 
 * SDWebImage如何识别图片的类型（jpeg、png、gif）：
 *  取出图片数据的第一个字节，就可以判断出图片的真是类型（gif为0x47）
 *  打开NSData+ImageContentType.m文件可查看
 */

@end
