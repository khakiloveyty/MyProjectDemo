//
//  JPTagTextField.h
//  健平不得姐
//
//  Created by ios app on 16/6/3.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPTagTextField : UITextField
@property(nonatomic,copy)void(^deleteBlock)(); //textField的删除回调
@end
