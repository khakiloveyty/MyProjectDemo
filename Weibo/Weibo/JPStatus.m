//
//  JPStatus.m
//  Weibo
//
//  Created by apple on 15/7/10.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPStatus.h"
#import "MJExtension.h"
#import "JPPhoto.h"
#import "NSDate+Extension.h"
#import "RegexKitLite.h"//使用第三方库找出微博正文中的特殊文字
#import <UIKit/UIKit.h>//有关字体的设置
#import "JPTextPart.h"
#import "JPEmotion.h"
#import "JPEmotionTool.h"
#import "JPSpecial.h"

#define StatusCellContentFont [UIFont systemFontOfSize:14] //原创微博的正文的字体大小

#define StatusCellRetweetContentFont [UIFont systemFontOfSize:13] //被转发的微博的正文的字体大小

//RGB颜色
#define Color(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@implementation JPStatus

//使用MJExtension第三方框架，告诉MJExtension字典转模型时，这个pic_urls数组保存的元素类型是JPPhoto类型
-(NSDictionary *)objectClassInArray{
    return @{@"pic_urls":[JPPhoto class]};
}


/*
 ·今年：
   1.今天
    * 1分钟内：刚刚
    * 1分~59分钟内：xx分钟前
    * 大于60分钟：xx小时前
   2.昨天
    * 昨天 xx:xx
   3.其他
    * xx-xx xx:xx
 
 ·不是今年：
    * xxxx-xx-xx xx:xx
 */
//重写*发布时间*属性的getter方法（每次引用都调用，动态更新）：修改发布时间的表现形式
//在cell的创建和重用时调用（获取发布时间）
-(NSString *)created_at{
   
    //_created_at == Sat Jun 05 09:27:26 +0800 2010
    //NSString --> NSDate
   
        
    //1.创建日期格式化类
    NSDateFormatter *fmt=[[NSDateFormatter alloc]init];
    
    /* 如果是真机调试，转换这种欧美时间，需要设置locale */
    //fmt.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    //@"zh_CN"：天朝，@"en_US"：美国
    
    //2.设置日期格式（声明字符串里面每个数值和单词的含义）
    // 将： Sat Jun 05 09:27:26 +0800 2010   （+0800：东八区，-则是西）
    // --> EEE MMM dd HH:mm:ss Z yyyy
    fmt.dateFormat=@"EEE MMM dd HH:mm:ss Z yyyy";//按要解析的时间字符串编排格式
    
    //3.得出微博发布时间
    NSDate *createDate=[fmt dateFromString:_created_at];
    //按要解析的时间字符串编排格式

    //获取当前时间
    NSDate *nowDate=[NSDate date];
    
    
    //1.创建日历对象（比较两个日期之间的差距，可比较年或月或日或其他等等）
    NSCalendar *calendar=[NSCalendar currentCalendar];
    
    //2.创建要比较的时间类型的枚举（年、月、日、时、分、秒）
    NSCalendarUnit unit=NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    //NSCalendarUnit：枚举 代表想获得哪些差值
    
    //3.计算两个日期之间的差值（微博发布时间和当前时间的差值）
    NSDateComponents *cmps=[calendar components:unit fromDate:createDate toDate:nowDate options:0];
    //components：要比较的时间类型
    //自动算出这两个时间的差值，可以为年、月、日、时、分、秒等类型输出
    
    if ([createDate isThisYear]) { //如果是今年
        
        if ([createDate isYesterday]) {    //如果是昨天
            //设置好时间格式
            fmt.dateFormat=@"昨天 HH:mm:ss";
            return [fmt stringFromDate:createDate];
        }else if ([createDate isToday]) {  //否则，如果是今天
            if (cmps.hour>=1) { //一天之内，一小时之外
                return [NSString stringWithFormat:@"%ld小时前",cmps.hour];
            }else if (cmps.minute>=1){  //一小时之内，一分钟之外
                return [NSString stringWithFormat:@"%ld分钟前",cmps.minute];
            }else{  //一分钟之内
                return @"刚刚";
            }
        }else{  //否则，就是今年之内除了今天和昨天的其他日子
            //设置好时间格式
            fmt.dateFormat=@"MM-dd HH:mm:ss";
            return [fmt stringFromDate:createDate];
        }
        
    }else{  //否则，就不是今年
        
        //设置好时间格式
        fmt.dateFormat=@"yyyy-MM-dd HH:mm:ss";
        return [fmt stringFromDate:createDate];
    }
    
    //[fmt stringFromDate:createDate]：createDate根据fmt规定的格式返回一个字符串
    
}

//重写*来源*属性的setter方法（只需修改一次）：将来源的其他字符去掉
//在字典转模型时调用
-(void)setSource:(NSString *)source{

    //将：<a href="http://app.weibo.com/t/feed/7nlRf" rel="nofollow">我的微播炉</a>
    //--> 我的微播炉  截取这段字符串
    
//    //设置截取的范围
//    //NSRange range={range.location,range.length};截取字符串的第n位之后的m位字符
//    NSRange range;
//    //设置截取的起始位置（从目标字符串的第一个“>”字符的下一个字符开始，这里即是“我”）
//    range.location=[source rangeOfString:@">"].location+1;
//    //设置截取的长度（将目标字符串的第一个“</”字符的位置 - 起始位置，得出截取的长度）
//    range.length=[source rangeOfString:@"</"].location-range.location;
//    
//    //设置*来源*的显示样式
//    _source=[NSString stringWithFormat:@"来自 %@",[source substringWithRange:range]];
    
    if (source.length) {
        //获取@">"在source字符串中的range（下标位置，长度为1）
        NSRange range=[source rangeOfString:@">"];
        //截取source字符串中的@">"字符的后面部分
        source=[source substringFromIndex:range.location+range.length];
        
        //获取@"<"在source字符串中的下标位置，长度为1
        range=[source rangeOfString:@"<"];
        //截取source字符串中的@"<"字符的前面部分
        source=[source substringToIndex:range.location];
        
        source=[NSString stringWithFormat:@"来自 %@",source];
        
    }else{
        source=@"来自 新浪微博";
    }
    
    _source=source;

}


//重写*微博内容*text属性的setter方法：转换成attributedText
-(void)setText:(NSString *)text{
    _text=[text copy];
    
    //获取属性文字
    self.attributedText=[self attributedTextWithText:text andFont:StatusCellContentFont];
    
}

//重写*转发微博*retweeted_status属性的setter方法：将转发微博的正文text转换成attributedText
-(void)setRetweeted_status:(JPStatus *)retweeted_status{
    _retweeted_status=retweeted_status;
    
    NSString *retweetContent=[NSString stringWithFormat:@"@%@ : %@",retweeted_status.user.name,retweeted_status.text];
    
    //获取属性文字
    self.retweetedAttributedText=[self attributedTextWithText:retweetContent andFont:StatusCellRetweetContentFont];
}

/**
 * 方法：普通文字 --> 属性文字
 * 参数：text 普通文字
 * 返回值：属性文字
 */
-(NSAttributedString *)attributedTextWithText:(NSString *)text andFont:(UIFont *)font{
    
    //1.创建一个可变的有属性的字符串对象（用于拼接所有经过排序和修整之后的属性文字）
    NSMutableAttributedString *attributedText=[[NSMutableAttributedString alloc]init];
    
    //正则表达式：检索字符串
    /*
     //表情规则
     NSString *pattern=@"\\[[a-zA-Z\\u4e00-\\u9fa5]+\\]";//[任意大小写英文或任意中文]
     //用户名规则
     NSString *pattern=@"@[0-9a-zA-Z\\u4e00-\\u9fa5-_]+";//还有包括“-”、“_”符号
     //话题规则
     NSString *pattern=@"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";
     //链接规则
     NSString *pattern=@"((http|ftp|https)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?";
     */
    
    //1.1 定义规则
    // | ：相当于或
    NSString *pattern=@"\\[[a-zA-Z\\u4e00-\\u9fa5]+\\]|@[0-9a-zA-Z\\u4e00-\\u9fa5-_]+|#[0-9a-zA-Z\\u4e00-\\u9fa5]+#|((http|ftp|https)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?";
    
    //保存打碎的字符串片段（有属性的和普通的）
    NSMutableArray *parts=[NSMutableArray array];
    
    //1.2 使用RegexKitLite遍历字符串捕捉所有符合规则的特殊字符串
    [text enumerateStringsMatchedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        JPTextPart *part=[[JPTextPart alloc]init];
        part.text=*capturedStrings;
        //若使以“[”开头，以“]”结尾，即是表情
        part.emotion=[part.text hasPrefix:@"["]&&[part.text hasSuffix:@"]"];
        part.range=*capturedRanges;
        part.special=YES;//是特殊文字
        //保存碎片
        [parts addObject:part];
    }];
    //NSInteger captureCount：捕捉数（不确定）
    //NSString *const __unsafe_unretained *capturedStrings：捕捉到的字符串的指针（指向内容）
    //const NSRange *capturedRanges：捕捉到的字符串的在原本字符串的范围的指针（指向字符串的范围）
    //volatile BOOL *const stop：是否停止遍历
    
    //1.3 使用RegexKitLite遍历字符串捕捉所有不符合规则的非特殊字符串（普通字符串）
    [text enumerateStringsSeparatedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        JPTextPart *part=[[JPTextPart alloc]init];
        part.text=*capturedStrings;
        part.range=*capturedRanges;
        part.special=NO;//是普通文字
        part.emotion=NO;//不是表情
        //保存碎片
        [parts addObject:part];
    }];
    
    //因为经过打碎而得来的字符串，所以顺序是乱的
    //1.4 要排序：使用block，自定义排序规则 --> 根据打碎的初始位置进行排序（从小到大）
    [parts sortUsingComparator:^NSComparisonResult(JPTextPart *part1, JPTextPart *part2) {
        //NSOrderedAscending： 升序    part1 < part2
        //NSOrderedSame：      相等    part1 = part2
        //NSOrderedDescending：降序    part2 < part1
        
        /* 系统是按照从 小 --> 大 的顺序排列对象 */
        
        if (part1.range.location>part2.range.location) {
            //part1>part2
            //告诉系统part1放后面，part2放前面
            return NSOrderedDescending;
        }
        //part1<part2
        //告诉系统part1放前面，part2放后面
        return NSOrderedAscending;
    }];
    //NSLog(@"%@",parts);
    
    //*1.创建一个专门保存JPSpecial对象（专门保存特殊文字的内容和范围）的可变数组
    NSMutableArray *specials=[NSMutableArray array];
    
    //1.5 将所有碎片修整后再拼接在一起
    for (JPTextPart *part in parts) {
        //拼接的字符串碎片（转换成NSAttributedString类型才能拼接）
        NSAttributedString *partStr=nil;
        if (part.isEmotion) {   //这个字符串碎片是*表情*
            //创建附件
            NSTextAttachment *attch=[[NSTextAttachment alloc]init];
            NSString *emotionPng=[JPEmotionTool emotionWithChs:part.text].png;
            //可能plist中没有可以显示的表情，没有的话就按原来的文字显示
            if (emotionPng==nil) {
                partStr=[[NSAttributedString alloc]initWithString:part.text];
            }else{
                attch.image=[UIImage imageNamed:emotionPng];
                attch.bounds=CGRectMake(0, -3, 15, 15);
                //绑定附件
                partStr=[NSAttributedString attributedStringWithAttachment:attch];
            }
        }else if (part.special){    //这个字符串碎片是*特殊文字*
            //添加字体颜色
            partStr=[[NSAttributedString alloc]initWithString:part.text attributes:@{NSForegroundColorAttributeName:Color(50, 150, 255)}];
            
            
            //*2.获取特殊文字的内容和在textView中的范围
            //使用JPSpecial模型保存
            JPSpecial *special=[[JPSpecial alloc]init];
            NSUInteger location=attributedText.length;
            NSUInteger length=part.text.length;
            special.text=part.text;
            special.range=NSMakeRange(location, length);
            
            //*3.保存模型到数组中
            [specials addObject:special];
            
        }else{  //这个字符串碎片是*普通文字*
            partStr=[[NSAttributedString alloc]initWithString:part.text];
        }
        
        [attributedText appendAttributedString:partStr];
    }
    
    //*4.将保存着所有JPSpecial模型的数组*添加*到整段微博内容的*第一个字符的属性*中
    //为了在JPStatusTextView文件中的touchBegin方法中，通过查询attributedText的第一个字符的属性，就能获取到这段微博正文中所有特殊文字的内容和位置
    [attributedText addAttribute:@"specials" value:specials range:NSMakeRange(0, 1)];
    
    //2.添加字体尺寸属性
    //一定要设置字体尺寸，保证计算出来的内容label的size是正确的
    [attributedText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedText.length)];
    
    //3.返回属性文字
    return attributedText;
}

@end
