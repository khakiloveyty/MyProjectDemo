//
//  JPCommentHeaderView.h
//  健平不得姐
//
//  Created by ios app on 16/5/28.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPCommentHeaderView : UITableViewHeaderFooterView
@property(nonatomic,copy)NSString *title;
+(instancetype)headerViewWithTableView:(UITableView *)tableView;
@end
