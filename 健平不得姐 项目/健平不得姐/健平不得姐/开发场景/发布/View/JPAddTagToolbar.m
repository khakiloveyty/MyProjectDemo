//
//  JPAddTagToolbar.m
//  健平不得姐
//
//  Created by ios app on 16/6/3.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPAddTagToolbar.h"
#import "JPAddTagViewController.h"

@interface JPAddTagToolbar ()
@property (weak, nonatomic) IBOutlet UIView *tagView;
@property(nonatomic,weak)UIButton *addBtn;
/** 所有标签Label */
@property(nonatomic,strong)NSMutableArray *tagLabels;
@end

@implementation JPAddTagToolbar

-(NSMutableArray *)tagLabels{
    if (!_tagLabels) {
        _tagLabels=[NSMutableArray array];
    }
    return _tagLabels;
}

-(void)awakeFromNib{
    
    //添加 添加标签 按钮
    UIButton *addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
    
    //设置按钮尺寸与图片尺寸一致
//    addBtn.size=[UIImage imageNamed:@"tag_add_icon"].size; //方法1
//    addBtn.size=[addBtn imageForState:UIControlStateNormal].size; //方法2
    addBtn.size=addBtn.currentImage.size; //方法3
    
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tagView addSubview:addBtn];
    self.addBtn=addBtn;
    
    [self createTags:@[@"吐槽",@"糗事"]];
}

-(void)addBtnClick{
    JPAddTagViewController *addTagVC=[[JPAddTagViewController alloc] init];
    
    //设置block（在pop回来的时候会调用该block的方法）
    //建议：避免造成循环引用，自定义block最好设置弱引用
    __weak typeof(self) weakSelf=self;
    addTagVC.tagsBlock= ^(NSArray *tags){
        [weakSelf createTags:tags]; //在添加标签页面点击完成时回调
    };
    
    //使用KVC将self.tagLabels里面所有的text属性放到一个数组中
    addTagVC.tags=[self.tagLabels valueForKeyPath:@"text"];
    
    
    UITabBarController *tabBarController=(UITabBarController *)KeyWindow.rootViewController;
    UINavigationController *navi=(UINavigationController *)tabBarController.selectedViewController;
    
    //UINavigationController *navi=(UINavigationController *)tabBarController.presentedViewController;
    //获取tabBarController presented出来的控制器

    /*
     
     PS：我的发段子控制器是push过来的，所以直接获取tabBarController.selectedViewController来push就行了。
     
         如果发段子控制器是tabBarController presented出来的，那就要用tabBarController.presentedViewController获取发段子控制器。
     
     
     扩展：  a --presented-> b
     
            a.presentedViewController=b;
            b.presentingViewController=a;
     
     */
    
    [navi pushViewController:addTagVC animated:YES];
}

//创建标签
-(void)createTags:(NSArray *)tags{
    
    //如果已经有标签了
    if (self.tagLabels.count) {
        //先移除标签
        [self.tagLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
        //清空数组
        [self.tagLabels removeAllObjects];
    }
    
    for (int i=0;i<tags.count;i++) {
        UILabel *tagLabel=[[UILabel alloc] init];
        tagLabel.backgroundColor=JPTagColor;
        tagLabel.textColor=[UIColor whiteColor];
        tagLabel.textAlignment=NSTextAlignmentCenter;
        
        tagLabel.font=JPTagFont;
        tagLabel.text=tags[i];
        [tagLabel sizeToFit];
        
        tagLabel.width+=2*JPAddTagViewMargin;
        tagLabel.height=JPTagHeight;
        
        [self.tagLabels addObject:tagLabel];
        [self.tagView addSubview:tagLabel];
    }
    
    //重新布局
    [self setNeedsLayout];
}

/**
 * xib创建出来的，awakeFromNib中自身的尺寸是xib文件中的尺寸，不是设置好的尺寸，自身的真实的尺寸要在layoutSubviews方法中获取
 * PS：子控件的位置排布要在layoutSubviews里面设置
 */

-(void)layoutSubviews{
    [super layoutSubviews];
    
    //计算所有标签的位置
    for (int i=0;i<self.tagLabels.count;i++) {
        
        UILabel *tagLabel=self.tagLabels[i];
        
        if (i==0) {
            tagLabel.x=0;
            tagLabel.y=0;
        }else{
            //取出上一个标签按钮
            UILabel *lastTagLabel=self.tagLabels[i-1];
            //根据上个标签按钮获取这个按钮的x值
            CGFloat x=CGRectGetMaxX(lastTagLabel.frame)+JPAddTagViewMargin;
            
            if ((x+tagLabel.width)<=self.tagView.width) {
                //如果加上按钮宽度比contentView的宽度小，则证明不会超出这一行，让按钮紧跟在上一个标签按钮后面
                tagLabel.x=x;
                tagLabel.y=lastTagLabel.y;
            }else{
                //否则就排在下一行
                tagLabel.x=0;
                tagLabel.y=CGRectGetMaxY(lastTagLabel.frame)+JPAddTagViewMargin;
            }
        }
    }
    
    
    //根据最后一个标签调整添加按钮的位置
    UILabel *lastTagLabel=[self.tagLabels lastObject];
    
    CGFloat addBtnX=0;
    CGFloat addBtnY=0;
    CGFloat addBtnW=self.addBtn.width;
    
    if (lastTagLabel) {   //如果有标签
        
        //根据上一个标签获取textField的x值
        addBtnX=CGRectGetMaxX(lastTagLabel.frame)+JPAddTagViewMargin;
        
        if ((addBtnX+addBtnW)<=self.tagView.width) {
            
            //如果不超过contentView的宽度，则证明不超过这一行，就让textField留在这一行
            addBtnY=lastTagLabel.y;
            
        }else{
            
            //否则放到下一行
            addBtnX=0;
            addBtnY=CGRectGetMaxY(lastTagLabel.frame)+JPAddTagViewMargin;
            
        }
        
    }
    
    self.addBtn.x=addBtnX;
    self.addBtn.y=addBtnY;
    
    
    //由于是xib创建出来的，整体高度不会跟随着子控件的高度改变而改变，只好修改整体高度
    
    //1.先获取原来的高度
    CGFloat oldHeight=self.height;
    //2.修改整体高度（45=工具条高度35+间距10）
    self.height=CGRectGetMaxY(self.addBtn.frame)+45;
    //3.修改整体的y值（高度改变了，要修改在父视图的y值，要减去两个高度的差值，保持整体贴紧父视图的底部）
    self.y-=self.height-oldHeight;
}

@end
