//
//  JPLrcsCell.h
//  QQ音乐
//
//  Created by ios app on 16/6/12.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JPLrcsLabel;

@interface JPLrcsCell : UITableViewCell
+(instancetype)lrcsCellWithTableView:(UITableView *)tableView;
@property(nonatomic,weak,readonly)JPLrcsLabel *lrcsLabel;
@end
