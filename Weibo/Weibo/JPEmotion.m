//
//  JPEmotion.m
//  Weibo
//
//  Created by apple on 15/7/22.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPEmotion.h"
#import "MJExtension.h"

@implementation JPEmotion

#pragma mark - NSCoding协议的代理方法

MJCodingImplementation //NSCoding协议的代理方法的宏（相当于下面所有的代码）

//在JPEmotionPageView的selectEmotion（发送通知）方法中归档
//在JPEmotionKeyboard的recentListView懒加载方法中解档

////当一个对象要归档进沙盒中时，就会调用这个方法
////目的：在这个方法中说明这个对象的哪些属性要存进沙盒
//-(void)encodeWithCoder:(NSCoder *)aCoder{
//    
////    [aCoder encodeObject:self.chs forKey:@"chs"];
////    [aCoder encodeObject:self.png forKey:@"png"];
////    [aCoder encodeObject:self.code forKey:@"code"];
//    
//    //遍历所有的成员变量（MJExtension的方法）
//    [self enumerateIvarsWithBlock:^(MJIvar *ivar, BOOL *stop) {
//        //每遍历一个成员变量都调用一次这个block
//        
//        [aCoder encodeObject:ivar.value forKey:ivar.name];
//        //ivar.value：成员变量的值（属性值）
//        //ivar.name：成员变量的名字（属性名）
//    }];
//}
//
//
////当从沙盒中解档一个对象时（从沙盒中加载一个对象时），就会调用这个方法
////目的：在这个方法中说明沙盒中的属性改怎么解析（需要取出哪些属性）
//- (id)initWithCoder:(NSCoder *)aDecoder{
//    self=[super init];
//    if (self) {
//        
////        self.chs=[aDecoder decodeObjectForKey:@"chs"];
////        self.png=[aDecoder decodeObjectForKey:@"png"];
////        self.code=[aDecoder decodeObjectForKey:@"code"];
//        
//        //遍历所有的成员变量（MJExtension的方法）
//        [self enumerateIvarsWithBlock:^(MJIvar *ivar, BOOL *stop) {
//            //每遍历一个成员变量都调用一次这个block
//            
//            ivar.value=[aDecoder decodeObjectForKey:ivar.name];
//            //ivar.value：成员变量的值（属性值）
//            //ivar.name：成员变量的名字（属性名）
//        }];
//        
//    }
//    return self;
//}


/**
 * 重写isEqual方法：用于删除沙盒中最近表情数组的重复表情元素
 * 作用：常用来判断两个JPEmotion对象是否一样（当删除数组中指定的某个元素时，会调用这方法遍历数组中所有元素）
 * 参数：另外一个JPEmotion对象
 * 返回值：YES -- 代表2个对象一样，NO -- 代表2个对象不一样
 */
-(BOOL)isEqual:(JPEmotion *)other{
    //原本方法内容是：
    //return [self isEqual:other];
    
    /*
     * isEqual：判断的是两个对象的地址是否一样
     * [aa isEqual:bb] 相当于 aa==bb
     * isEqualToString：判断的是两个字符串是否一样
     */
    
    //默认是判断地址是否一样
    
    //重写成：
    return [self.chs isEqualToString:other.chs] || [self.code isEqualToString:other.code];
    //不需要判断地址是否一样，只判断此表情的文字描述和code是否一样，如果一样就删除
}

@end
