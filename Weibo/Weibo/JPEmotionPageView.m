//
//  JPEmotionPageView.m
//  Weibo
//
//  Created by apple on 15/7/23.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPEmotionPageView.h"
#import "UIView+Extension.h"
#import "JPEmotion.h"
#import "JPEmotionPopView.h"
#import "JPEmotionButton.h"
#import "JPEmotionTool.h"

@interface JPEmotionPageView()
//选择按钮时弹出的放大镜视图
@property(nonatomic,strong)JPEmotionPopView *popView;
//删除按钮
@property(nonatomic,weak)UIButton *deleteButton;
@end

@implementation JPEmotionPageView

-(JPEmotionPopView *)popView{
    if (!_popView) {
        _popView=[JPEmotionPopView popView];
    }
    return _popView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        //1.创建删除按钮
        UIButton *deleteButton=[[UIButton alloc]init];
        //2.设置删除按钮图片
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        //3.监听删除按钮
        [deleteButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteButton];
        self.deleteButton=deleteButton;
        
        
        //添加长按手势（长按表情能一直有放大器显示）
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressPageView:)]];
    }
    return self;
}


//获取手指位置所在的表情按钮
-(JPEmotionButton *)emotionButtonWithLocation:(CGPoint)location{
    //遍历按钮：判断手指位置是否在表情按钮的区域内
    for (int i=0; i<self.emotions.count; i++) {
        //从第2个按钮开始遍历，第1个是删除按钮没必要管
        JPEmotionButton *button=self.subviews[i+1];
        
        //CGRectContainsPoint：判断参数2是否在参数1的范围之内
        if (CGRectContainsPoint(button.frame, location)) {
            //触发点击响应事件
            [self.popView showFrom:button];
            
            //已经找到手指已经在某个表情按钮上了，就没必要再往下遍历
            return button;
        }
    }
    return nil;
}

//长按手势的响应方法
-(void)longPressPageView:(UILongPressGestureRecognizer*)longGR{
    
    //获取手指所在的位置（参数：添加手势的view）
    CGPoint location=[longGR locationInView:longGR.view];
    //获取手指位置所在的表情按钮
    JPEmotionButton *button=[self emotionButtonWithLocation:location];
    
    //判断手势的状态
    switch (longGR.state) {
        case UIGestureRecognizerStateCancelled:  //手势被取消（例如电话打来时会被强制停止）
        case UIGestureRecognizerStateEnded:      //手势停止（手指离开屏幕）
            //1.移除放大镜
            [self.popView removeFromSuperview];
            //2.如果手势离开的前一刻是停留在表情按钮上，就发出通知：这个表情被点了，插入到文本内容
            if (button) {
                //发出通知：这个表情被点了，插入到文本内容
               [self selectEmotion:button.emotion];
            }
            break;
            
        case UIGestureRecognizerStateBegan:      //手势开始（刚检测到长按：触屏一小段时间后）
        case UIGestureRecognizerStateChanged:{    //手势改变（手指挪动屏幕）
            //显示放大镜
            [self.popView showFrom:button];
            break;
        }
            
        default:
            break;
    }
}



//重写数组emotions属性的setter方法：
//在JPEmotionListView的setEmotions方法中截取的一部分表情中调用
-(void)setEmotions:(NSArray *)emotions{
    _emotions=emotions;
    
    for (int i=0; i<emotions.count; i++) {
        
        JPEmotionButton *btn=[[JPEmotionButton alloc]init];
        [self addSubview:btn];
        
        //取出表情模型，赋值给btn的emotion属性
        btn.emotion=emotions[i];
        
        //监听按钮
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

//表情按钮的响应方法
-(void)buttonClick:(JPEmotionButton *)button{
    
    //1.显示popView放大镜
    [self.popView showFrom:button];
    
    //2.过会就让popView消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.popView removeFromSuperview];
    });
    
    //3.发出通知：这个表情被点了，插入到文本内容
    [self selectEmotion:button.emotion];
    
}

#pragma mark - 发出通知：这个表情被点了，插入到文本内容
//发送通知：这个表情被点了，插入到文本内容
-(void)selectEmotion:(JPEmotion *)emotion{
    
    //这个表情被点了，将这个表情存进沙盒中的最近表情数组中
    [JPEmotionTool saveRecentEmotion:emotion];
    
    //（由于层级关系太复杂，所以不使用协议，使用通知）
    NSMutableDictionary *useInfo=[NSMutableDictionary dictionary];//通知参数
    useInfo[@"selectedEmotion"]=emotion;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EmotionDidSelectNotification" object:nil userInfo:useInfo];
}

/* 设置子控件的frame要写在layoutSubviews方法中 */
//自定义 每个表情按钮 的位置和尺寸
-(void)layoutSubviews{
    [super layoutSubviews];
    
    //内边距（四周）
    CGFloat inset=10;
    
    //按钮的宽高
    CGFloat btnW=(self.width-2*inset)/EmotionMaxCols;
    CGFloat btnH=(self.height-inset)/EmotionMaxRows;//底部没有间距
    
    //布局表情按钮
    for (int i=0; i<self.emotions.count; i++) {
        //要从数组下标1开始遍历，因为第0个按钮是删除按钮（最早添加，因为是在init方法中添加）
        JPEmotionButton *btn=self.subviews[i+1];
        
        //设置frame
        
        //获取所在列数
        int col=i%EmotionMaxCols;
        btn.x=col*(btnW)+inset;
        
        //获取所在行数
        int row=i/EmotionMaxCols;
        btn.y=row*(btnH)+inset;
        
        btn.width=btnW;
        btn.height=btnH;
    }

    
    //布局删除按钮
    self.deleteButton.width=btnW;
    self.deleteButton.height=btnH;
    self.deleteButton.x=self.width-inset-self.deleteButton.width;
    self.deleteButton.y=self.height-self.deleteButton.height;//底部没有间距
    
}


#pragma mark - 监听删除按钮的方法
-(void)deleteClick{
    //发出通知（层级关系太复杂，所以不使用协议，使用通知）
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EmotionDidDeleteNotification" object:nil];
    
}


@end
