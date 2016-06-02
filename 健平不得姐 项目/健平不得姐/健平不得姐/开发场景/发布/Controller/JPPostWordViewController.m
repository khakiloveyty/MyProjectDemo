//
//  JPPostWordViewController.m
//  健平不得姐
//
//  Created by ios app on 16/6/2.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPPostWordViewController.h"
#import "JPPlaceholderTextView.h"

@interface JPPostWordViewController () <UITextViewDelegate>

@end

@implementation JPPostWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor redColor];

    [self setupNavigation];
    
    [self setupTextView];
}

-(void)setupNavigation{
    self.title=@"发表文字";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(postWord)];
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem.enabled=NO;//默认不能点击
    
//    [self.navigationController.navigationBar layoutIfNeeded]; //如果没有渲染成灰色，就强制刷新导航栏
}

-(void)setupTextView{
    JPPlaceholderTextView *textView=[[JPPlaceholderTextView alloc] init];
    textView.frame=self.view.bounds;
    textView.font=[UIFont systemFontOfSize:15];
    textView.delegate=self;
    textView.placeholder=@"把好玩的图片、好笑的段子或糗事发到这里，接受万千网友膜拜吧！发布违反国家法律内容的，我们将依法提交给有关部门处理。";
    [self.view addSubview:textView];
}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    self.navigationItem.rightBarButtonItem.enabled=textView.hasText;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - NavigationItem Handle

//取消
-(void)cancel{
    [self.navigationController popViewControllerAnimated:YES];
}

//发表
-(void)postWord{
    
}

@end
