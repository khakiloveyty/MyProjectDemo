//
//  JPWebViewController.m
//  健平不得姐
//
//  Created by ios app on 16/6/1.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPWebViewController.h"

@interface JPWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBackItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForwardItem;

@end

@implementation JPWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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

@end
