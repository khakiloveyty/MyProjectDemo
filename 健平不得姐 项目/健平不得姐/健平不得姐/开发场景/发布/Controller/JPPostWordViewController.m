//
//  JPPostWordViewController.m
//  健平不得姐
//
//  Created by ios app on 16/6/2.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPPostWordViewController.h"
#import "JPPlaceholderTextView.h"
#import "JPAddTagToolbar.h"

@interface JPPostWordViewController () <UITextViewDelegate>
@property(nonatomic,weak)JPAddTagToolbar *toolbar;
@property(nonatomic,weak)JPPlaceholderTextView *textView;
@end

@implementation JPPostWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"发表文字";
    self.view.backgroundColor=[UIColor whiteColor];

    [self setupNavigation];
    
    [self setupTextView];
    
    [self setupToolbar];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.view endEditing:YES];//以防键盘没收回
    [self.textView becomeFirstResponder];
}

-(void)setupNavigation{
    
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
    self.textView=textView;
}

-(void)setupToolbar{
    
    JPAddTagToolbar *toolbar=[JPAddTagToolbar viewLoadFromNib];
    
    //PS：在viewDidLoad中拿到的self.view的尺寸，如果是由xib文件创建出来的拿到的是【xib文件的尺寸】，而代码创建的出来的拿到的是【屏幕的尺寸】。
    toolbar.width=self.view.width;
    toolbar.y=self.view.height-toolbar.height;
    
    [self.view addSubview:toolbar];
    self.toolbar=toolbar;
    
    //监听键盘的弹出/收回（UIKeyboardWillChangeFrameNotification：键盘弹出/收回都会发送这个通知）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

//键盘弹出/收回响应方法
-(void)keyboardWillChangeFrame:(NSNotification *)noti{
    
    //获取键盘弹出/收起后的Frame（UIKeyboardFrameEndUserInfoKey：键盘弹出/收起最终的frame）
    CGRect keyboardFrame=[noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //获取键盘弹出/收起的动画时间
    CGFloat duration=[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
//        self.toolbar.y=keyboardFrame.origin.y-self.toolbar.height;
        self.toolbar.transform=CGAffineTransformMakeTranslation(0, -(self.view.height-keyboardFrame.origin.y));
    }];
    
}

//退出页面时的处理
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
