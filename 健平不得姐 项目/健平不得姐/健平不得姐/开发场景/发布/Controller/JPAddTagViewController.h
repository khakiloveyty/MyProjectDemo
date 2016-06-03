//
//  JPAddTagViewController.h
//  健平不得姐
//
//  Created by ios app on 16/6/3.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPAddTagViewController : UIViewController
@property(nonatomic,copy)void (^tagsBlock)(NSArray *tags);  //设置一个block在合适的时机再调用
@end
