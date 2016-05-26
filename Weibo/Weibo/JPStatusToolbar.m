//
//  JPStatusToolbar.m
//  Weibo
//
//  Created by apple on 15/7/15.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPStatusToolbar.h"
#import "UIView+Extension.h"
#import "JPStatus.h"

@interface JPStatusToolbar()
/** 里面存放所有的按钮 */
@property(nonatomic,strong)NSMutableArray *buttons;
/** 里面存放所有的分割线 */
@property(nonatomic,strong)NSMutableArray *dividers;

@property(nonatomic,weak)UIButton *repostBtn;//转发按钮
@property(nonatomic,weak)UIButton *commenBtn;//评论按钮
@property(nonatomic,weak)UIButton *attitudeBtn;//点赞按钮
@end

@implementation JPStatusToolbar

-(NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons=[NSMutableArray array];
    }
    return _buttons;
}

-(NSMutableArray *)dividers{
    if (!_dividers) {
        _dividers=[NSMutableArray array];
    }
    return _dividers;
}

+(instancetype)toolbar{
    return [[self alloc]init];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        //设置底部工具条的背景图
        self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_card_bottom_background"]];
        //colorWithPatternImage：以图片作为视图背景，图片尺寸不够则以平铺形式填充
        
        //添加按钮（按顺序添加，因为要按顺序布局）
        self.repostBtn=[self setupButtonWithIcon:@"timeline_icon_retweet" andTitle:@"转发"];
        self.commenBtn=[self setupButtonWithIcon:@"timeline_icon_comment" andTitle:@"评论"];
        self.attitudeBtn=[self setupButtonWithIcon:@"timeline_icon_unlike" andTitle:@"赞"];
        
        //添加分割线
        [self setupDivider];
        [self setupDivider];
    }
    return self;
}

/**
 * 初始化（添加）按钮
 * @param icon:按钮图标
 * @param title:按钮文字
 */
-(UIButton *)setupButtonWithIcon:(NSString *)icon andTitle:(NSString *)title{
    UIButton *button=[[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    button.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);//设置文字与图片有小段间距
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //设置按钮点中时的高亮背景图
    [button setBackgroundImage:[UIImage imageNamed:@"timeline_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
    button.titleLabel.font=[UIFont systemFontOfSize:13];
    
    //将按钮放入数组中保存
    [self.buttons addObject:button];
    
    [self addSubview:button];//这句代码之后会触发layoutSubviews方法进行布局
    
    return button;
}

/** 初始化（添加）分割线 */
-(void)setupDivider{
    UIImageView *divider=[[UIImageView alloc]init];
    divider.image=[UIImage imageNamed:@"timeline_card_bottom_line"];
    
    //将分割线放入数组中保存
    [self.dividers addObject:divider];
    
    [self addSubview:divider];//这句代码之后会触发layoutSubviews方法进行布局
}


//在此设置子控件（按钮、分割线）的frame
-(void)layoutSubviews{
    [super layoutSubviews];
    
    //不使用self.subviews，因为里面包括按钮和分割线，区分麻烦
    
    //设置按钮的frame
    NSUInteger count=self.buttons.count;
    CGFloat btnW=self.width/count;
    CGFloat btnH=self.height;
    for (int i=0; i<count; i++) {
        UIButton *btn=self.buttons[i];
        btn.y=0;
        btn.width=btnW;
        btn.height=btnH;
        btn.x=i*btnW;
    }
    
    //设置分割线的frame
    NSUInteger dividerCount=self.dividers.count;
    for (int i=0; i<dividerCount; i++) {
        UIImageView *divider=self.dividers[i];
        divider.width=1;
        divider.height=self.height;
        divider.x=(i+1)*btnW;
        divider.y=0;
    }
}


//重写status的setter方法：在JPStatusCell中给toolbar添加内容时调用
-(void)setStatus:(JPStatus *)status{
    _status=status;
    
    //设置转发按钮
    [self setupButtonTitleWithButton:self.repostBtn andTitle:@"转发" andCount:status.reposts_count];
    //设置评论按钮
    [self setupButtonTitleWithButton:self.commenBtn andTitle:@"评论" andCount:status.comments_count];
    //设置点赞按钮
    [self setupButtonTitleWithButton:self.attitudeBtn andTitle:@"赞" andCount:status.attitudes_count];
}

//设置按钮文字
-(void)setupButtonTitleWithButton:(UIButton *)button andTitle:(NSString *)title andCount:(int)count{
    if (count) {
        //如果有转发数、评论数或点赞数，则显示相应的数字
        
        /*
         不足10000：直接显示数字，不如159、8477
         达到或超过10000：显示xx.x万（不能有x.0万的情况，也不需要四舍五入）
         
         12324  1.2万
         24343  2.4万
         10345  1万（不能是1.0万）
         */
        if (count<10000) {
            //不足10000：直接显示数字
            title=[NSString stringWithFormat:@"%d",count];
        }else{
            //达到或超过10000：显示xx.x万（不能有x.0万的情况）
            double wan=count/10000.0;//整型-->浮点型
            title=[NSString stringWithFormat:@"%.1f万",wan];
            
            //若出现x.0，将@".0"替换成@""，去掉“.0”
            title=[title stringByReplacingOccurrencesOfString:@".0" withString:@""];
            //stringByReplacingOccurrencesOfString：要替换的字符串
            //withString：替换后的字符串
        }
        [button setTitle:title forState:UIControlStateNormal];
    }else{
        //没有则显示转发、评论或赞
        [button setTitle:title forState:UIControlStateNormal];
    }}
@end
