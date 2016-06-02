//
//  JPMeFooterView.m
//  健平不得姐
//
//  Created by ios app on 16/6/1.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPMeFooterView.h"
#import "JPMeSquare.h"
#import "JPMeSquareButton.h"
#import "JPWebViewController.h"

@interface JPMeFooterView ()

@end

@implementation JPMeFooterView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor clearColor];
        [self request];
    }
    return self;
}

-(void)request{
    //发送请求
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"a"]=@"square";
    params[@"c"]=@"topic";
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        NSArray *meSquares=[JPMeSquare mj_objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
        [self createSquares:meSquares];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        JPLog(@"失败");
        [SVProgressHUD showErrorWithStatus:@"加载数据失败"];
    }];
}

-(void)createSquares:(NSArray *)squares{
    
    //一行最多4列
    int maxCols=4;
    
    CGFloat btnW=self.width/maxCols;
    CGFloat btnH=btnW;
    
    for (int i=0; i<squares.count; i++) {
        
        JPMeSquareButton *btn=[JPMeSquareButton buttonWithType:UIButtonTypeCustom];
        
        //传递模型
        JPMeSquare *meSquare=squares[i];
        btn.meSquare=meSquare;
        
        //设置frame
        btn.width=btnW;
        btn.height=btnH;
        btn.x=btnW*(i%maxCols);
        btn.y=btnH*(i/maxCols);
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
        
    }
    
    //设置总高度
    self.height=btnH*((squares.count+maxCols-1)/maxCols)+35;
    
    //刷新tableView的contentSize
    [self.delegate requestSuccess];
    
//    //重绘背景图
//    [self setNeedsDisplay];
    
}

//-(void)drawRect:(CGRect)rect{
//    [[UIImage imageNamed:@"mainCellBackground"] drawInRect:rect]; //将图片画到view上，当作背景图片
//}

-(void)btnClick:(JPMeSquareButton *)btn{
    
    //如果不是http为前缀的url，就不执行了
    if (![btn.meSquare.url hasPrefix:@"http"]) return;
    
    JPWebViewController *webVC=[[JPWebViewController alloc] init];
    webVC.url=btn.meSquare.url;
    webVC.title=btn.meSquare.name;
    
    UITabBarController *tabBarController=(UITabBarController *)KeyWindow.rootViewController;
    UINavigationController *navi=(UINavigationController *)tabBarController.selectedViewController;
    
    [navi pushViewController:webVC animated:YES];
    
}

@end
