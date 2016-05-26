//
//  JPEmotionTextView.m
//  Weibo
//
//  Created by apple on 15/7/23.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPEmotionTextView.h"
#import "JPEmotion.h"
#import "NSString+Emoji.h"//十六进制转码emoji字符
#import "UITextView+Extension.h"//插入带有属性和附件的字符串在光标处
#import "JPEmotionAttachment.h"


@implementation JPEmotionTextView

//插入表情图片
-(void)insertEmotion:(JPEmotion *)emotion{
    //判断点击的表情是 emoji 还是 默认或浪小花
    if (emotion.code) {
        //insertText：将文字插入到光标所在的位置
        [self insertText:emotion.code.emoji];
    }else if (emotion.png){
        
        //1.加载表情图片（将图片放入附件）
        
        //创建文本附件（JPEmotionAttachment：继承NSTextAttachment附件类，可以放文件，可以放数据，新增可以放JPEmotion模型）
        JPEmotionAttachment *attach=[[JPEmotionAttachment alloc]init];
        attach.emotion=emotion;//传递JPEmotion模型：将表情图片设置为附件的图片
        
        //设置附件（表情图片）的尺寸和位置（表情图片的size）
        CGFloat attachWH=self.font.lineHeight;//按字体的行高规定图片宽高
        attach.bounds=CGRectMake(0, -4, attachWH, attachWH);//设置表情图片的宽高，而且要往下挪一点点
        
        //创建带有附件的字符串（即单个表情）
        NSAttributedString *imageStr=[NSAttributedString attributedStringWithAttachment:attach];
        
        
        
        //2.插入表情图片（imageStr只是附件，不能给attributedText添加属性，所以把添加属性的操作写入block中）
        [self insertAttributedString:imageStr settingBlock:^(NSMutableAttributedString *attributedText) {
            //attributedText：是block内部的参数
            
            //设置字体大小（按照之前设定好的字体大小设置，因为attributedText的字体是不受按照之前设定好的字体大小所影响的，是按照自己设定的属性所决定）
            [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];//设置范围为整段字符串
            
        }];//将插入过程写到textView的分类中
        
    }

}

//不能将图片作为上传参数，解析发布微博的内容：将表情转为字符串
-(NSString *)fullText{
    NSMutableString *fullText=[NSMutableString string];
    
    //遍历属性文字
    //遍历范围：整段内容
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        //NSLog(@"%@,%@",attrs,NSStringFromRange(range));
        
        //这方法会遍历指定范围的文本内容，并自动将*有属性的文字*和*没属性的文字*各自分开一段一段
        //attrs：这一段的内容信息（有没附件、属性）
        //rang：这一段内容的范围
        
        //获取文字段的附件
        JPEmotionAttachment *attach=attrs[@"NSAttachment"];
        if (attach) {
            //如果有附件（就是表情）
            //拼接表情图片的文字描述
            [fullText appendString:attach.emotion.chs];
        }else{
            //否则就是普通文字或emoji
            //获取这个范围内的文字
            NSAttributedString *AttributedStr=[self.attributedText attributedSubstringFromRange:range];
            
            //拼接普通文字或emoji
            [fullText appendString:AttributedStr.string];
            //AttributedStr.string：获取属性文字的普通文字部分
        }
    }];
    
    return fullText;
}

@end
