//
//  JPLrcsCell.m
//  QQ音乐
//
//  Created by ios app on 16/6/12.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPLrcsCell.h"
#import <Masonry.h>
#import "JPLrcsLabel.h"

@implementation JPLrcsCell

+(instancetype)lrcsCellWithTableView:(UITableView *)tableView{
    JPLrcsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"JPLrcsCell"];
    if (!cell) {
        cell=[[JPLrcsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JPLrcsCell"];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        JPLrcsLabel *lrcsLabel=[[JPLrcsLabel alloc] init];
        lrcsLabel.textColor=[UIColor whiteColor];
        lrcsLabel.font=[UIFont systemFontOfSize:14];
        lrcsLabel.textAlignment=NSTextAlignmentCenter;
        
        [self.contentView addSubview:lrcsLabel];
        _lrcsLabel=lrcsLabel;
        
        lrcsLabel.translatesAutoresizingMaskIntoConstraints=NO;
        
        [lrcsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.contentView);
        }];
        
    }
    return self;
}

@end
