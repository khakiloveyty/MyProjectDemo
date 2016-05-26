//
//  JPStatusTextView.m
//  Weibo
//
//  Created by apple on 15/7/30.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPStatusTextView.h"
#import "RegexKitLite.h"//使用第三方库找出微博正文中的特殊文字
#import "JPSpecial.h"
#import "TestViewController.h"

//RGB颜色
#define Color(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define JPStatusTextViewCoverTag 999

@implementation JPStatusTextView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        
        //1.设置为不可编辑（textView默认是可以编辑的）
        self.editable=NO;
        
        //2.设置间距
        //textView默认文字间距是(8, 0, 8, 0)
        //左右间距虽然值为0，但还是会有间距的，因为textView左右间距是从那点间距开始算起
        self.textContainerInset=UIEdgeInsetsMake(0, -5, 0, -5);
        
        //3.设置禁止滚动（修改了间距，禁止滚动才可以让文字自动完全显示出来）
        self.scrollEnabled=NO;
    }
    return self;
}


//初始化特殊文字的区域：算出每段特殊文字*各*有几块rect
-(void)setupSpecialRects{
    
    //从attributedText的第一个字符的属性中，获取微博正文中所有特殊文字的内容和范围
    NSArray *specials=[self.attributedText attribute:@"specials" atIndex:0 effectiveRange:NULL];
    //在JPStatus模型文件的attributedTextWithText方法中，将所有的特殊文字的内容和范围保存在一个数组中，再将这个数组添加在attributedText的第一个字符的属性中
    
    for (JPSpecial *special in specials) {
        
        /* self.selectedRange文本视图的选中范围，设置其值就是选中文本视图中范围 */
        
        //*2.但可以设置self.selectedRange的值，从而影响self.selectedTextRange的值
        //self.selectedRange --影响--> self.selectedTextRange
        self.selectedRange=special.range;
        
        //获取*这段*特殊文字的在textView中的区域(x,y,width,height)
        NSArray *textRects=[self selectionRectsForRange:self.selectedTextRange];
        //*1.参数：self.selectedTextRange是UITextRange类型，是不可修改的
        //返回值：特殊文字区域的数组，因为选择的字符串区域有可能出现分行的情况，前部分在行末端，后部分在下一行的前端，或者多行等，分成好几块区域，所以是数组类型
        
        //使用完self.selectedRange之后要设置回0值，清空选中范围，不然一直处于选中状态
        self.selectedRange=NSMakeRange(0, 0);
        
        //创建一个数组专门寸放这段特殊文字完整的区域（有可能出现分行的情况，会有几块的区域）
        NSMutableArray *rects=[NSMutableArray array];
        
        //遍历这段特殊文字*一块或多块*区域(x,y,width,height)
        //textRects数组的元素是UITextSelectionRect类型
        for (UITextSelectionRect *selectionRect in textRects) {
            CGRect rect=selectionRect.rect;
            //忽略空格区域
            if (rect.size.width==0 || rect.size.height==0) {
                continue;
            }
            //将特殊文字的某块区域拼接到数组中存储得出完整的特殊文字区域
            [rects addObject:[NSValue valueWithCGRect:rect]];//需要转换类型
        }
        //将保存特殊文字区域的数组赋值给模型
        special.rects=rects;
    }
    
}

//根据触摸点获取被触摸的特殊文字：判断点击的是否特殊文字，且是哪段特殊文字
-(JPSpecial *)touchingSpecialWithPoint:(CGPoint)point{
    
    //1.从attributedText的第一个字符的属性中，获取微博正文中所有特殊文字的内容和范围
    NSArray *specials=[self.attributedText attribute:@"specials" atIndex:0 effectiveRange:NULL];
    //在JPStatus模型文件的attributedTextWithText方法中，将所有的特殊文字的内容和范围保存在一个数组中，再将这个数组添加在attributedText的第一个字符的属性中
    
    
    //2.遍历每段特殊文字，如果点中了其中一段特殊文字，则给这段特殊文字添加高亮效果
    for (JPSpecial *special in specials) {
        
        for (NSValue *rectValue in special.rects) {
            
            //如果触摸点在某段特殊文字的区域内（即点中了这段特殊文字的某处）
            if (CGRectContainsPoint(rectValue.CGRectValue, point)) {
                //返回这段特殊文字
                return special;
            }
        }
    }
    
    //否则，就是点击的不是特殊文字的区域，返回空值
    return nil;
}


//触摸开始（手指一点击屏幕）的响应方法
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //1.创建触摸对象
    UITouch *touch=[touches anyObject];
    
    //2.获取触摸点
    CGPoint point=[touch locationInView:self];
    
    //3.初始化特殊文字的区域：算出每段特殊文字*各*有几块rect（给special.rects赋值）
    [self setupSpecialRects];
    
    //4.根据触摸点获取被触摸的特殊文字
    //根据触摸点判断是否点击了某段特殊文字的区域（若不是，则返回空值）
    JPSpecial *special=[self touchingSpecialWithPoint:point];
    
        //让这段特殊文字添加背景
        for (NSValue *rectValue in special.rects) {
            
            //添加背景
            UIView *cover=[[UIView alloc]initWithFrame:rectValue.CGRectValue];
            cover.tag=JPStatusTextViewCoverTag;
            cover.backgroundColor=Color(150, 200, 255);
            cover.layer.cornerRadius=5;//设置为圆角
            //插入到特殊文字下面
            [self insertSubview:cover atIndex:0];
            
        }
            
    
    
    //找出触摸点在哪个特殊字符串上面（用户名称、网站链接）
    //在被触摸的特殊字符串后面显示一段高亮的背景（相当于按钮被点击的效果）
}

//触摸结束（手指离开屏幕）的响应方法
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //延迟一点时间再去除背景（类似高亮状态效果）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self touchesCancelled:touches withEvent:event];
    });
}

//触摸事件被打断时的响应方法：在textView上长按会出现放大镜，就会触发触摸打断事件；或者有电话打来时也会打断
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    //去掉特殊文字后面的高亮背景
    for (UIView *child in self.subviews) {
        if (child.tag==JPStatusTextViewCoverTag) {
            [child removeFromSuperview];
        }
    }
}

//由于textView会拦截cell的点击处理，所以要区分特殊文字与其他内容，点击特殊文字交给textView处理（高亮效果），点击其他内容则让cell响应
/*
 * 触摸事件的处理：
 *  1.判断触摸点在谁身上：调用所有UI控件的-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
 *  2.pointInside返回YES的控件就是触摸点所在的UI控件
 *  3.由触摸点所在的UI控件选出处理事件的UI控件：再调用-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
 */

/**
 告诉系统：触摸点point是否在这个UI控件身上
 */
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    //1.初始化特殊文字的区域：算出每段特殊文字*各*有几块rect（给special.rects赋值）
    [self setupSpecialRects];
    
    //2.根据触摸点获取被触摸的特殊文字
    //根据触摸点判断是否点击了某段特殊文字的区域（若不是，则返回空值）
    JPSpecial *special=[self touchingSpecialWithPoint:point];
    
    //3.如果是特殊文字，就是textView，不是则交给上一个控件（这里上一个是cell）
    if (special) {
        return YES;
    }else{
        return NO;
    }
}

//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    return [super hitTest:point withEvent:event];
//}

@end
