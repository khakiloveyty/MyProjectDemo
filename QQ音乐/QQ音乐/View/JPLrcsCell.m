//
//  JPLrcsCell.m
//  QQ音乐
//
//  Created by ios app on 16/6/12.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPLrcsCell.h"

@implementation JPLrcsCell

+(instancetype)lrcsCellWithTableView:(UITableView *)tableView{
    JPLrcsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"JPLrcsCell"];
    if (!cell) {
        cell=[[JPLrcsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JPLrcsCell"];
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.textColor=[UIColor whiteColor];
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
}

@end
