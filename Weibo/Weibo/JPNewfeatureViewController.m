//
//  JPNewfeatureViewController.m
//  Weibo
//
//  Created by apple on 15/7/7.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPNewfeatureViewController.h"
#import "UIView+Extension.h"
#import "JPTabBarController.h"

//RGB颜色
#define Color(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
//新特性的页面数
#define NewfeatureCount 4

@interface JPNewfeatureViewController ()<UIScrollViewDelegate>
@property(nonatomic,weak)UIPageControl *pageControl;
@end

@implementation JPNewfeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.创建一个scrollView：显示所有的新特性图片
    UIScrollView *scrollView=[[UIScrollView alloc]init];
    scrollView.delegate=self;
    scrollView.frame=self.view.bounds;
    [self.view addSubview:scrollView];
    
    //2.添加图片到scrollView中
    for (int i=0; i<NewfeatureCount; i++) {
        UIImageView *imageView=[[UIImageView alloc]init];
        imageView.size=scrollView.size;
        imageView.y=0;
        imageView.x=i*imageView.width;
        imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"new_feature_%d",i+1]];
        [scrollView addSubview:imageView];
        
        //如果是最后一个imageView，就往里面添加其他内容
        if (i==NewfeatureCount-1) {
            [self setupLastImageView:imageView];
        }
    }
    
    //3.设置scrollView的其他属性
    scrollView.contentSize=CGSizeMake(scrollView.width*NewfeatureCount, 0);//设置滚动范围
    scrollView.pagingEnabled=YES;//设置为整页翻滚
    scrollView.bounces=NO;//去除弹簧效果
    scrollView.showsHorizontalScrollIndicator=NO;//不显示水平方向的滚动条（是属于scrollView其中的一个子控件）
    
    //4.添加pageControl：分页，展示目前看的是第几页
    UIPageControl *pageControl=[[UIPageControl alloc]init];
    pageControl.numberOfPages=NewfeatureCount;
    //设置位置、尺寸
    pageControl.centerX=scrollView.centerX;
    pageControl.centerY=scrollView.height-50;
    
    //UIPageControl就算没有设置尺寸，里面的内容还是照常显示
    //pageControl.width=100;
    //pageControl.height=50;
    //取消用户交互（如果pageControl没有设置尺寸，那么就没有让用户点击的面积，但它的“点点”是它的子视图，还是会显示出来，只是父视图没有了尺寸）
    //pageControl.userInteractionEnabled=NO;
    
    //设置颜色
    pageControl.currentPageIndicatorTintColor=Color(253, 98, 42);//当前页的颜色
    pageControl.pageIndicatorTintColor=Color(189, 189, 189);//其他页的颜色
    
    self.pageControl=pageControl;
    
    [self.view addSubview:pageControl];
}
//监听滚动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    double page=scrollView.contentOffset.x/scrollView.width;
    //scrollView.contentOffset.x：scrollView沿x轴滚动的距离
    
    //使用四舍五入计算出页码（当滚动视图滚动到下一页差不多一半时，页面点数变成下一点）
    self.pageControl.currentPage=(int)(page+0.5);
    
    /*
     * 四舍五入：
     * 1.3+0.5=1.8=1
     * 1.5+0.5=2.0=2
     * 1.6+0.5=2.1=2
     * --> (int)(page+0.5)
     */

}

//往最后一页imageView添加控件
-(void)setupLastImageView:(UIImageView *)imageView{
    
    //1.开启最后一页的用户交互功能
    imageView.userInteractionEnabled=YES;
    
    //2.添加“分享给大家”按钮
    UIButton *shareBtn=[[UIButton alloc]init];
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
    [shareBtn setTitle:@"分享给大家" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    shareBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.width=150;
    shareBtn.height=30;
    shareBtn.centerX=imageView.width*0.5;
    shareBtn.centerY=imageView.height*0.7;
    shareBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
    [imageView addSubview:shareBtn];
    
    //shareBtn.titleEdgeInsets 切文字的边距
    //shareBtn.imageEdgeInsets 切图片的边距
    //shareBtn.contentEdgeInsets 切全部的边距（文字和图片）
    
    //3.添加“开始微博”按钮
    UIButton *startBtn=[[UIButton alloc]init];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    [startBtn setTitle:@"开始微博" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    startBtn.size=startBtn.currentBackgroundImage.size;
    startBtn.centerX=imageView.width*0.5;
    startBtn.centerY=CGRectGetMaxY(shareBtn.frame)+20;
    [imageView addSubview:startBtn];
}

-(void)shareClick:(UIButton *)shareBtn{
    shareBtn.selected=!shareBtn.selected;
}

-(void)startClick{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    window.rootViewController=[[JPTabBarController alloc]init];
    //使用这种方法可以使新特性界面销毁（因为只使用一次）
}

@end


























