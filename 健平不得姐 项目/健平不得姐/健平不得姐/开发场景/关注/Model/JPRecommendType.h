//
//  JPRecommendType.h
//  健平不得姐
//
//  Created by ios app on 16/5/13.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPRecommendType : NSObject

//服务器返回的属性
@property(nonatomic,assign)NSInteger ID;//标签id ---> id
@property(nonatomic,copy)NSString *name;//标签名称
@property(nonatomic,assign)NSInteger count;//此标签下的用户数

//自定义额外的辅助属性
@property(nonatomic,strong)NSMutableArray *users;//这个类别对应的用户数据（获取到用户信息时再保存到这个数组里）
//@property(nonatomic,assign)NSInteger total_page;//用户数据的总页数
@property(nonatomic,assign)NSInteger total;//用户数据总数
//@property(nonatomic,assign)NSInteger next_page;//下一页的页数
@property(nonatomic,assign)NSInteger currentPage;//当前页数

@end
