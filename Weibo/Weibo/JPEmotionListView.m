//
//  JPEmotionListView.m
//  Weibo
//
//  Created by apple on 15/7/20.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPEmotionListView.h"
#import "UIView+Extension.h"
#import "JPEmotionPageView.h"

@interface JPEmotionListView() <UIScrollViewDelegate>
@property(nonatomic,weak)UIScrollView *scrollView;
@property(nonatomic,weak)UIPageControl *pageControl;
@end

@implementation JPEmotionListView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        
        //1.UIScrollView
        UIScrollView *scrollView=[[UIScrollView alloc]init];
        scrollView.delegate=self;//设置自己为代理方：监听滚动修改页数提示图标
        scrollView.pagingEnabled=YES;//设置翻页滚动
        scrollView.bounces=NO;//去除弹簧效果
        //去除水平和垂直方向的滚动条
        scrollView.showsHorizontalScrollIndicator=NO;
        scrollView.showsVerticalScrollIndicator=NO;
        //相当于从self.scrollView.subviews中去除这两个默认创建的子控件

        [self addSubview:scrollView];
        self.scrollView=scrollView;
        

        
        //2.UIPageControl
        UIPageControl *pageControl=[[UIPageControl alloc]init];
        //使用KVC修改pageControl的图片属性（私有）
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKeyPath:@"pageImage"];
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKeyPath:@"currentPageImage"];
        //设置不让用户点击响应
        pageControl.userInteractionEnabled=NO;
        //设置当只有1页的情况下不显示pageControl（默认是NO）
        pageControl.hidesForSinglePage=YES;
        [self addSubview:pageControl];
        self.pageControl=pageControl;
    }
    return self;
}


//重写emotions属性的setter方法：布局listView的子控件
//在JPEmotionKeyboard的各个listView的懒加载方法中调用
-(void)setEmotions:(NSArray *)emotions{
    _emotions=emotions;
    
    //删除scrollView之前的控件
    //每次点击任意表情都会调用setEmotions方法，如果不先删除之前的控件，执行完第2步之后只会增加更多的pageView
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //makeObjectsPerformSelector：让数组中的每个元素 都调用 removeFromSuperview
    //默认有5页，emoji有4页，浪小花有2页
    
    
    
    //总页数
    NSUInteger pageCount=(emotions.count+EmotionPageCount-1)/EmotionPageCount;
    
    //1.设置页数
    self.pageControl.numberOfPages=pageCount;
    //页数=(表情总数+每页可容纳最多的表情数-1)/每页可容纳最多的表情数
    
    //2.创建滚动视图上每一页的控件（每个控件上面放每一页的表情）
    for (int i=0; i<pageCount; i++) {
        JPEmotionPageView *pageView=[[JPEmotionPageView alloc]init];
        //设置截取范围
        NSRange range;
        range.location=i*EmotionPageCount;
        NSUInteger leftCount=emotions.count-range.location;//剩余的表情个数
        //这一页的表情数
        if (leftCount>=20) {
            range.length=EmotionPageCount;
        }else{
            range.length=leftCount;
        }
        //从所有表情中截取这一页的表情
        pageView.emotions=[emotions subarrayWithRange:range];
        //subarrayWithRange：按规定范围截取数组中的某段元素赋值给新数组
        [self.scrollView addSubview:pageView];
    }
    
    //每次点击任意表情之后都要刷新界面，重新布局
    [self setNeedsLayout];
    
    //NSLog(@"%@",self.scrollView.subviews);
}


/* 设置子控件的frame要写在layoutSubviews方法中 */
//自定义 表情内容控件 和 页面提示控件 的位置和尺寸
-(void)layoutSubviews{
    [super layoutSubviews];
    
    //1.pageControl
    self.pageControl.width=self.width;
    self.pageControl.height=25;
    self.pageControl.x=0;
    self.pageControl.y=self.height-self.pageControl.height;
    
    //2.scrollView
    self.scrollView.width=self.width;
    self.scrollView.height=self.pageControl.y;
    self.scrollView.x=0;
    self.scrollView.y=0;
    
    //3.设置scrollView内部每一页的view的尺寸
    NSUInteger count=self.scrollView.subviews.count;
    for (int i=0; i<count; i++) {
        JPEmotionPageView *pageView=self.scrollView.subviews[i];//已经把多余的两个滚动条控件除去
        pageView.height=self.scrollView.height;
        pageView.width=self.scrollView.width;
        pageView.x=pageView.width*i;
        pageView.y=0;
    }
    
    //4.设置滚动范围
    self.scrollView.contentSize=CGSizeMake(count*self.scrollView.width, 0);//只能水平滚动
    
}

#pragma mark - UIScrollViewDelegate
//监听滚动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    double pageNo=scrollView.contentOffset.x/scrollView.width;
    //使用四舍五入计算出页码（当滚动视图滚动到下一页差不多一半时，页面点数变成下一点）
    self.pageControl.currentPage=(int)(pageNo+0.5);
    
    /*
     * 四舍五入：
     * 1.3+0.5=1.8=1
     * 1.5+0.5=2.0=2
     * 1.6+0.5=2.1=2
     * --> (int)(page+0.5)
     */
}


@end
