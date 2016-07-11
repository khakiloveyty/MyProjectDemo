//
//  JPCommentHeaderView.m
//  健平不得姐
//
//  Created by ios app on 16/5/28.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPCommentHeaderView.h"

@interface JPCommentHeaderView ()
@property(nonatomic,weak)UILabel *titleLabel;
@end

@implementation JPCommentHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor=JPGlobalColor;
        
        //创建label（UITableViewHeaderFooterView跟UITableViewCell一样不能设置它的frame，只能设置子视图）
        UILabel *titleLabel=[[UILabel alloc] init];
        titleLabel.textColor=JPRGB(67, 67, 67);
        titleLabel.width=200;
        titleLabel.x=JPTopicCellMargin;
        
        //设置label高度
        titleLabel.autoresizingMask=UIViewAutoresizingFlexibleHeight;
        //autoresizingMask：自动设置尺寸
        //UIViewAutoresizingFlexibleHeight：自动跟随着父控件的高度进行拉伸（就是跟父控件的高度一致）
        
        //添加label
        [self.contentView addSubview:titleLabel];
        self.titleLabel=titleLabel;
        
        /*
         
         headerView.view已经不能使用了，只能用headerView.contentView来代替（背景颜色、添加子视图）
         
         */
    }
    
    return self;
}

-(void)setTitle:(NSString *)title{
    _title=[title copy];
    self.titleLabel.text=title;
}

+(instancetype)headerViewWithTableView:(UITableView *)tableView{
    JPCommentHeaderView *headerView=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"JPCommentHeaderView"];
    if (!headerView) {
        headerView=[[JPCommentHeaderView alloc] initWithReuseIdentifier:@"JPCommentHeaderView"];
    }
    return headerView;
}

@end
