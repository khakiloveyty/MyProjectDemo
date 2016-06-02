//
//  JPTextField.m
//  健平不得姐
//
//  Created by ios app on 16/5/17.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPTextField.h"
#import <objc/runtime.h>

static NSString *const JPPlaceholderColorKeyPath=@"_placeholderLabel.textColor";

@implementation JPTextField

/*
 
 运行时（Runtime）：
 * 苹果官方的一套C语言库
 * 能做很多底层操作（比如访问隐藏的一些成员变量/成员方法...）
 
 */

//initialize 整个程序只会运行一次

//+(void)initialize{
//  
//    [self getProperties];
//
//}

//获取属性
+(void)getProperties{
    
    unsigned int count=0;
    
    //拷贝出某个类的所有属性
    objc_property_t *properties=class_copyPropertyList([UITextView class], &count);
    
    for (int i=0;i<count;i++) {
        //取出属性
        objc_property_t property=properties[i];
        
        //打印属性名字
        JPLog(@"%s ----- %s",property_getName(property),property_getAttributes(property)); //_getAttributes 获取属性类型
    }
    
    free(properties);
    
}

//获取成员变量
+(void)getIvars{
    /*
     
     成员变量：这个类里面所有开头带“_”的变量
     
     //拷贝出某个类的所有成员变量
     Ivar *ivars=class_copyIvarList(__unsafe_unretained Class cls, unsigned int *outCount);
     
     * 参数1：类 ---> 要拷贝成员变量的那个类
     * 参数2：unsigned int类型数据的地址 ---> 函数执行完后会把*成员变量数组的个数*赋值给这个变量
     
     * 返回值：Ivar（指针）类型，指向的是参数1这个类里面拷贝的成员变量数组（指向第一个）（成员变量都是Ivar类型）
     
     */
    
    unsigned int count=0;
    
    Ivar *ivars=class_copyIvarList([UITextView class], &count);
    //把count这个变量的地址传进去，当这个函数执行完，要访问这个变量的地址进行赋值
    
    for (int i=0;i<count;i++) {
        //取出成员变量
        //        Ivar ivar=*(ivars+i);
        Ivar ivar=ivars[i]; // ivars[i] 等价于 *(ivars+i)，指针挪位
        
        //ivars：指向成员变量数组首位的指针，可当作数组来用
        
        //打印成员变量名字
        JPLog(@"%s ----- %s",ivar_getName(ivar),ivar_getTypeEncoding(ivar)); //_getTypeEncoding 获取成员变量类型
    }
    
    //class_copyIvarList 是把所有成员变量拷贝出来，需要释放
    
    //释放
    free(ivars);
    
}

-(void)awakeFromNib{
    
    //设置光标颜色和文字颜色一致
    self.tintColor=self.textColor;
    
    //不成为第一响应者 ---> 设置占位文字颜色为灰色
    [self resignFirstResponder];
    
}

//聚焦时就会调用
//重写成为第一响应者：就是弹出键盘时
-(BOOL)becomeFirstResponder{
    
    //设置占位文字颜色和文字颜色一致
    //使用KVC修改隐藏的placeholderLabel属性
    [self setValue:self.textColor forKeyPath:JPPlaceholderColorKeyPath];
    
    return [super becomeFirstResponder];//需调用父类方法
}

//失去焦点时就会调用
//重写放弃第一响应者：收回键盘时或切换到别的文本输入框时
-(BOOL)resignFirstResponder{
    
    //设置占位文字颜色为灰色
    //使用KVC修改隐藏的placeholderLabel属性
    [self setValue:[UIColor grayColor] forKeyPath:JPPlaceholderColorKeyPath];
    
    return [super resignFirstResponder];//需调用父类方法
}

@end
