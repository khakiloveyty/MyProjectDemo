//
//  JPTopicVoiceView.m
//  健平不得姐
//
//  Created by ios app on 16/5/27.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPTopicVoiceView.h"
#import "JPTopic.h"

@interface JPTopicVoiceView ()

@end

@implementation JPTopicVoiceView

+(instancetype)voiceView{
    return [[[NSBundle mainBundle] loadNibNamed:@"JPTopicVoiceView" owner:nil options:nil] firstObject];
}

-(void)awakeFromNib{
    self.autoresizingMask=UIViewAutoresizingNone;//不会随父视图的改变而改变（xib文件有可能会拉伸）
    //参考：http://www.cocoachina.com/ios/20141216/10652.html
}

-(void)setTopic:(JPTopic *)topic{
    _topic=topic;
    
    
}

@end
