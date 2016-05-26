//
//  JPSubViewController.h
//  Weibo
//
//  Created by apple on 15/7/29.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JPSubViewController;

//规定协议
@protocol JPSubViewControllerDelegate <NSObject>
@optional
-(void)didDismiss:(JPSubViewController *)svc;
@end

@interface JPSubViewController : UIViewController
@property(nonatomic,weak)id<JPSubViewControllerDelegate> delegate;
@end
