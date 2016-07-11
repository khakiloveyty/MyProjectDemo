//
//  JPPublishView.m
//  健平不得姐
//
//  Created by ios app on 16/5/24.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPPublishView.h"
#import "JPVerticalButton.h"
#import <POP.h>
#import "JPPostWordViewController.h"

static CGFloat const JPAnimationDelay=0.1;
static CGFloat const JPSpringFactor=9;

@interface JPPublishView ()
@property (strong, nonatomic)NSArray *titles;
@end

@implementation JPPublishView

/*
 命名规范：
    成员变量：_名字
    全局变量：名字_
    带const的常量：前缀+名字
    局部变量和属性：名字      
 */

static UIWindow *window_; //自定义窗口

+(void)show{
    //创建窗口，由于动画过程要设置self.userInteractionEnabled为NO，这样点击事件就会穿透到下一层视图上，为了拦截点击响应，创建一个窗口（栈结构，会在最上层，最底层是keywindow）专门响应传递下来的点击事件
    window_=[[UIWindow alloc] init];
    window_.frame=[UIScreen mainScreen].bounds;
    window_.backgroundColor=[UIColor clearColor];
    window_.hidden=NO;//window不需要添加到任何父控件上，只需要让它显示就自动盖在最上层
    window_.rootViewController=[UIViewController new];
    
    //window_.windowLevel=UIWindowLevelNormal;
    //UIWindowLevel 窗口级别（默认是UIWindowLevelNormal）
    //UIWindowLevelNormal(普通级别) < UIWindowLevelStatusBar(状态栏的级别) < UIWindowLevelAlert(警告框的级别)
    
    JPPublishView *publishView=[self viewLoadFromNib];
    //因为publishView是xib文件创建出来的，所以它的初始尺寸是xib文件里的尺寸，所以要自己设置尺寸
    publishView.frame=window_.bounds;
    [window_ addSubview:publishView];
}



- (void)awakeFromNib {
    
    UIVisualEffectView *effectView=[[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    effectView.frame=[UIScreen mainScreen].bounds;
    [self insertSubview:effectView atIndex:0];
    
    //动画过程要拦截点击响应事件
    self.userInteractionEnabled=NO;
    
    self.titles=@[@"发视频",@"发图片",@"发段子",@"发声音",@"审帖",@"离线下载"];
    NSArray *images=@[@"publish-video",@"publish-picture",@"publish-text",@"publish-audio",@"publish-review",@"publish-offline"];
    
    
    //添加按钮
    
    CGFloat btnW=72;        //按钮宽度
    CGFloat btnH=btnW+35;   //按钮高度（35是留给图片下方label的高度）
    
    int maxCols=3; //最大列数
    
    CGFloat firstBtnX=Screen_Width*0.1;     //第一个按钮的x值
    CGFloat firstBtnY=Screen_Height/2-btnH; //第一个按钮的y值
    CGFloat xMargin=(Screen_Width-2*firstBtnX-maxCols*btnW)/(maxCols-1); //列间距
    
    for (int i=0; i<6; i++) {
        JPVerticalButton *btn=[[JPVerticalButton alloc] init];
        btn.tag=i;
        
        //设置内容
        btn.titleLabel.font=[UIFont systemFontOfSize:14];
        [btn setTitle:self.titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        int row=i/maxCols; //所在行数
        int col=i%maxCols; //所在列数
        
        CGFloat btnX=firstBtnX+col*(xMargin+btnW);
        
        CGFloat btnEndY=firstBtnY+row*btnH;
        CGFloat btnStartY=btnEndY-Screen_Height;
        
        [self addSubview:btn];
        
        //添加动画
        POPSpringAnimation *anim=[POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        
        anim.fromValue=[NSValue valueWithCGRect:CGRectMake(btnX, btnStartY, btnW, btnH)];
        anim.toValue=[NSValue valueWithCGRect:CGRectMake(btnX, btnEndY, btnW, btnH)];
        
        //动画开始时间 = 当前时间（必须要有）+ 需要延迟的时间
        //CACurrentMediaTime()：当前时间
        anim.beginTime=CACurrentMediaTime()+JPAnimationDelay*i;
        
        //弹簧属性
        anim.springBounciness=JPSpringFactor;
        anim.springSpeed=JPSpringFactor;
        
        [btn pop_addAnimation:anim forKey:nil];
    }
    
    
    //添加标题
    UIImageView *sloganImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    
    CGFloat centerX=Screen_Width/2;
    CGFloat centerEndY=Screen_Height*0.25;
    CGFloat centerStartY=centerEndY-Screen_Height;
    
    sloganImageView.center=CGPointMake(centerX, centerStartY);
    
    [self addSubview:sloganImageView];
    
    POPSpringAnimation *anim=[POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    
    anim.toValue=[NSValue valueWithCGPoint:CGPointMake(centerX, centerEndY)];
    
    //动画开始时间 = 当前时间（必须要有）+ 需要延迟的时间
    //CACurrentMediaTime()：当前时间
    anim.beginTime=CACurrentMediaTime()+self.titles.count*JPAnimationDelay;
    
    //弹簧属性
    anim.springBounciness=JPSpringFactor-2;
    anim.springSpeed=JPSpringFactor-2;
    
    anim.completionBlock=^(POPAnimation *anim, BOOL finished){
        //动画结束，开启点击响应
        self.userInteractionEnabled=YES;
    };
    
    [sloganImageView pop_addAnimation:anim forKey:nil];
    
}

-(void)btnClick:(UIButton *)btn{
    [self dismissViewControllerWithCompletionBlock:^{
        switch (btn.tag) {
            case 0:                                     //发视频
                JPLog(@"%@",self.titles[btn.tag]);
                break;
            case 1:                                     //发图片
                JPLog(@"%@",self.titles[btn.tag]);
                break;
            case 2:                                     //发段子
            {
                JPLog(@"%@",self.titles[btn.tag]);
                break;
            }
            case 3:                                     //发声音
                JPLog(@"%@",self.titles[btn.tag]);
                break;
            case 4:                                     //审帖
                JPLog(@"%@",self.titles[btn.tag]);
                break;
            case 5:                                     //离线下载
                JPLog(@"%@",self.titles[btn.tag]);
                break;
                
            default:
                break;
        }
    }];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerWithCompletionBlock:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerWithCompletionBlock:nil];
}

//退出动画
-(void)dismissViewControllerWithCompletionBlock:(void (^ __nullable)(void))completionBlock{
    
    //动画过程不能有点击响应事件
    self.userInteractionEnabled=NO;
    
    int beginIndex=1;
    
    for (int i=beginIndex; i<self.subviews.count; i++) {
        UIView *subview=self.subviews[i];
        
        POPBasicAnimation *anim=[POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        
        anim.toValue=[NSValue valueWithCGPoint:CGPointMake(subview.centerX, subview.centerY+Screen_Height)];
        
        CGFloat delay=(i-beginIndex)*JPAnimationDelay;
        
        if (i>beginIndex && i<(self.subviews.count-1)) {
            delay=(self.subviews.count-1-i)*JPAnimationDelay;
        }else if (i==(self.subviews.count-1)){
            
            anim.completionBlock=^(POPAnimation *anim, BOOL finished){
                
                //移除自己
                [self removeFromSuperview];
                
                //销毁窗口（本来直接销毁窗口那self也会销毁的，但不知道为啥毛玻璃还会存在，只好移除self再销毁）
                window_=nil;
                
                //执行block
//                if (completionBlock) {
//                    completionBlock();
//                }
                !completionBlock? : completionBlock();
                
            };
            
        }
        
        anim.beginTime=CACurrentMediaTime()+delay;
        
        anim.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        
        anim.duration=0.2;
        
        [subview pop_addAnimation:anim forKey:nil];
    }
}

/*
 
 pop和Core Animation的区别：
  1.Core Animation的动画只能添加到layer上
  2.pop的动画能添加到任何对象
  3.pop的底层并非基于Core Animation，是基于CADisplayLink
  4.Core Animation的动画仅仅是表象，并不会真正修改对象的frame\size等值
  5.pop的动画实时修改对象的属性，真正地修改了对象的属性
 
 */

/*
 
 POPSpringAnimation *anim=[POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
 
 anim.fromValue=[NSValue valueWithCGPoint:CGPointMake(self.sloganImageView.centerX, 100)];
 anim.toValue=[NSValue valueWithCGPoint:CGPointMake(self.sloganImageView.centerX, 300)];
 
 //动画开始时间 = 当前时间（必须要有）+ 需要延迟的时间
 //CACurrentMediaTime()：当前时间
 anim.beginTime=CACurrentMediaTime()+1.0;
 
 //弹簧属性
 anim.springBounciness=20;
 anim.springSpeed=20;
 
 //监听动画结束的block（需要调用回传的两个参数：POPAnimation *anim, BOOL finished）
 anim.completionBlock=^(POPAnimation *anim, BOOL finished){
     if (finished) {
         JPLog(@"动画结束");
     }
 };
 
 [self.sloganImageView pop_addAnimation:anim forKey:nil];
 
 */

@end
