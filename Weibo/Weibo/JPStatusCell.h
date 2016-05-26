//
//  JPStatusCell.h
//  Weibo
//
//  Created by apple on 15/7/13.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

//添加子控件，给子控件添加的内容

#import <UIKit/UIKit.h>
#import "JPStatusFrame.h"

@interface JPStatusCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong)JPStatusFrame *statusFrame;
@end
