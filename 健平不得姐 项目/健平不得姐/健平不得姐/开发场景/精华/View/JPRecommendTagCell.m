//
//  JPRecommendTagCell.m
//  健平不得姐
//
//  Created by ios app on 16/5/16.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPRecommendTagCell.h"
#import "JPRecommendTag.h"

@interface JPRecommendTagCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageListImageView;
@property (weak, nonatomic) IBOutlet UILabel *themeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subsCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *subscribeBtn;
@end

@implementation JPRecommendTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setRecommendTag:(JPRecommendTag *)recommendTag{
    _recommendTag=recommendTag;
    
    [self.imageListImageView sd_setImageWithURL:[NSURL URLWithString:recommendTag.image_list] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.themeNameLabel.text=recommendTag.theme_name;
    
    NSString *subsCount=nil;
    if (recommendTag.sub_number<10000) {
        subsCount=[NSString stringWithFormat:@"%zd人订阅",recommendTag.sub_number];
    }else{
        subsCount=[NSString stringWithFormat:@"%.1f万人订阅",recommendTag.sub_number/10000.0];
    }
    self.subsCountLabel.text=subsCount;
}

//在外面修改了cell的frame属性却没有效果（貌似是被覆盖了）
//只要重写setFrame方法，就可以修改cell的frame
-(void)setFrame:(CGRect)frame{
    
    //拦截frame，修改（不管外面怎么修改，都会来到这里，可以在这里写死frame，最终使用这里所修改的frame）
    frame.origin.x=5;
    frame.size.width-=2*5;
    frame.size.height-=1;
    
    [super setFrame:frame];//让父类使用修改过的frame并保存起来
}

@end
