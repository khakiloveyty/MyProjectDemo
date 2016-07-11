//
//  JPWebViewController.m
//  健平不得姐
//
//  Created by ios app on 16/6/1.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPWebViewController.h"
#import <NJKWebViewProgress.h>

@interface JPWebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBackItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForwardItem;

@property(nonatomic,strong)NJKWebViewProgress *progress; //进度代理对象
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@end

@implementation JPWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.progress=[[NJKWebViewProgress alloc] init];
    
    //把webView的代理给了NJKWebViewProgress对象，self就不会调用webView的代理方法
    self.webView.delegate=self.progress;
    //将self设置为NJKWebViewProgress的代理，它内部会调用webView的代理方法然后回调给self使用
    self.progress.webViewProxyDelegate = self;
    
    self.progressView.progressTintColor=[UIColor redColor];
    self.progressView.trackTintColor=[UIColor clearColor];
    
    //强引用了self.progress.progressBlock，里面又引用了self，造成循环引用，需要标识self为弱引用再在block中使用
    __weak typeof(self) weakSelf=self;
    self.progress.progressBlock=^(float progress){
//        JPLog(@"%f",progress);
        weakSelf.progressView.progress=progress;
        weakSelf.progressView.hidden=(progress==1.0);
    };
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    
}

- (IBAction)goBack:(id)sender {
    [self.webView goBack];
}

- (IBAction)goForward:(id)sender {
    [self.webView goForward];
}

- (IBAction)reload:(id)sender {
    [self.webView reload];
}

#pragma mark - UIWebViewDelegate

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    self.goBackItem.enabled=webView.canGoBack;
    self.goForwardItem.enabled=webView.canGoForward;
}

@end
