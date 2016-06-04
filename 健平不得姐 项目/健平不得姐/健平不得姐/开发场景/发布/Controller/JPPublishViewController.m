//
//  JPPublishViewController.m
//  健平不得姐
//
//  Created by ios app on 16/6/2.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPPublishViewController.h"
#import "JPVerticalButton.h"
#import <POP.h>
#import "JPPostWordViewController.h"

static CGFloat const JPAnimationDelay=0.1;
static CGFloat const JPSpringFactor=9;

@interface JPPublishViewController ()
@property (strong, nonatomic)NSArray *titles;
@end

@implementation JPPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIVisualEffectView *effectView=[[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    effectView.frame=[UIScreen mainScreen].bounds;
    [self.view insertSubview:effectView atIndex:0];
    
    //动画过程要拦截点击响应事件
    self.view.userInteractionEnabled=NO;
    
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
        
        [self.view addSubview:btn];
        
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
    
    [self.view addSubview:sloganImageView];
    
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
        self.view.userInteractionEnabled=YES;
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
                
                UITabBarController *tabBarController=(UITabBarController *)KeyWindow.rootViewController;
                UINavigationController *navi=(UINavigationController *)tabBarController.selectedViewController;
                
                JPPostWordViewController *postWordVC=[[JPPostWordViewController alloc] init];
                [navi pushViewController:postWordVC animated:YES];
                
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
    self.view.userInteractionEnabled=NO;
    
    int beginIndex=1;
    
    for (int i=beginIndex; i<self.view.subviews.count; i++) {
        UIView *subview=self.view.subviews[i];
        
        POPBasicAnimation *anim=[POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        
        anim.toValue=[NSValue valueWithCGPoint:CGPointMake(subview.centerX, subview.centerY+Screen_Height)];
        
        CGFloat delay=(i-beginIndex)*JPAnimationDelay;
        
        if (i>beginIndex && i<(self.view.subviews.count-1)) {
            delay=(self.view.subviews.count-1-i)*JPAnimationDelay;
        }else if (i==(self.view.subviews.count-1)){
            
            anim.completionBlock=^(POPAnimation *anim, BOOL finished){
                
                [self dismissViewControllerAnimated:NO completion:nil];
                
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

@end
