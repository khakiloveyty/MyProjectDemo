//
//  JPTopicPictureView.h
//  健平不得姐
//
//  Created by ios app on 16/5/23.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JPTopic;

@interface JPTopicPictureView : UIView
+(instancetype)pictureView;
@property(nonatomic,strong)JPTopic *topic;
@end
