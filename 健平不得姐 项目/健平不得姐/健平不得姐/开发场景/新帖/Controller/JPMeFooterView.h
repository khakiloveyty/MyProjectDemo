//
//  JPMeFooterView.h
//  健平不得姐
//
//  Created by ios app on 16/6/1.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JPMeFooterView;

@protocol JPMeFooterViewDelegate <NSObject>

-(void)requestSuccess;

@end

@interface JPMeFooterView : UIView
@property(nonatomic,weak)id<JPMeFooterViewDelegate>delegate;
@end
