//
//  JPOAuthViewController.m
//  Weibo
//
//  Created by apple on 15/7/9.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPOAuthViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "JPAccountTool.h"
#import "UIWindow+Extension.h"
//#import "MJExtension.h"//使用第三方框架MJExtension将字典转换成模型

@interface JPOAuthViewController ()<UIWebViewDelegate>

@end

/*
 * App Key：1865302726
 * App Secret：1cc959ff21240f01fa65b01c28361a0d
 *
 * access_token=2.00ONMODCq8cOCC9f347d1de7feK9CD
 */

@implementation JPOAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.创建一个webView
    UIWebView *webView=[[UIWebView alloc]init];
    webView.delegate=self;
    webView.frame=self.view.bounds;
    [self.view addSubview:webView];
    
    //2.用webView加载登陆页面（新浪提供）
    //请求地址：https://api.weibo.com/oauth2/authorize
    //请求方式：GET
    //请求参数：
    /*
     client_id(string)：申请应用时分配的AppKey。
     redirect_uri(string)：授权回调地址，站外应用需与设置的回调地址一致，站内应用需填写canvas page的地址。（默认为http://）
     */
    NSURL *url=[NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=1865302726&redirect_uri=http://www.sina.com.cn"];//GET请求（参数写在url后面）
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

#pragma mark - webView代理方法
//webView开始请求
- (void)webViewDidStartLoad:(UIWebView *)webView{
    //当每次开始连接网络，加载网页数据时就执行下面代码，显示“正在加载”
    //相当于加了一层蒙版，防止加载期间点击其他导致程序出错
    [MBProgressHUD showMessage:@"正在加载..."];
}

//webView结束请求
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //当网页加载完毕时就隐藏掉正在加载的页面
    [MBProgressHUD hideHUD];
}

//webView请求失败
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD hideHUD];//网页加载失败，隐藏正在加载的界面
}

//拦截webView的所有请求（BOOL值：请求是否能通过）
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    //例如：点击登录，会拦截请求的url；点击授权，就会拦截账号密码检验成功后的请求的url（里面就包含code）
    
    //1.获取url
    NSString *urlStr=request.URL.absoluteString;
    //NSLog(@"%@",request.URL.absoluteString);
    
    //2.判断是否为回调地址
    //即当**账号密码正确**，点击授权后，会有一段后面写着code=xxxxxxxx的url
    //此时获取含有字符串“code=”的url
    NSRange range=[urlStr rangeOfString:@"code="];//获取“code=”这段字符串在urlStr的范围
    
    //若range的长度不为0，则证明这个url有code参数（在“code=”后面的数据）
    if (range.length!=0) {
        
        //[MBProgressHUD showMessage:@"正在加载..."];
        
        //截取“code=”后面的参数值
        long fromIndex=range.location+range.length;
        //range.location --> range在urlStr的起始位置
        NSString *code=[urlStr substringFromIndex:fromIndex];//获取“code=”之后的字符串
        NSLog(@"code=%@",code);
        
        //利用code（授权成功后的request token）获取一个Access Token
        [self accessTokenWithCode:code];
        
        //禁止加载回调地址（不要跳到我设置的那个新浪手机网）
        return NO;
    }
    return YES;
}

//利用code（授权成功后的request token）换取一个accessToken
-(void)accessTokenWithCode:(NSString *)code{
    /*
     URL：https://api.weibo.com/oauth2/access_token
     请求方式：POST
     请求参数：
     client_id(string)：申请应用时分配的AppKey。
     client_secret(string)：申请应用时分配的AppSecret。
     grant_type(string)：请求的类型，填写authorization_code
     
     code(string)：调用authorize获得的code值。
     redirect_uri(string)：回调地址，需需与注册应用里的回调地址一致。
    */
    
    //1.请求管理者
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    
    //设定服务器返回的数据类型（默认为application/json、text/json、text/javascript，没有text/plain）
    //需手动在AFNetworking代码中添加text/plain类型（因为新浪服务器返回的是text/plain类型）
    manger.responseSerializer=[AFJSONResponseSerializer serializer];
    //上面这句代码是默认的，不写也可以，只要在AFNetworking代码中添加text/plain类型，就不会报错了（因为新浪服务器返回的是text/plain类型）
    
    
    //2.拼接请求参数
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"client_id"]=@"1865302726";
    params[@"client_secret"]=@"1cc959ff21240f01fa65b01c28361a0d";
    params[@"grant_type"]=@"authorization_code";
    params[@"code"]=code;//最主要这个，用来换取accessToken
    params[@"redirect_uri"]=@"http://www.sina.com.cn";
    
    
    //3.发送请求
    [manger POST:@"https://api.weibo.com/oauth2/access_token" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"授权请求成功，%@",responseObject);
        
        //因为设定了点击授权按钮后禁止加载回调地址，从而永远都不会执行webViewDidFinishLoad方法
        //所以在请求成功或失败的这里实现[MBProgressHUD hideHUD]方法，把正在加载页面隐藏
        [MBProgressHUD hideHUD];//成功了，把正在加载的页面隐藏
        
        //将返回的账号字典数据 --> 模型，再存进沙盒的Document
        //获取accessToken、可用时间、uid，创建并保存好授权的时间
        JPAccount *account=[JPAccount accountWithDic:responseObject];
        
        //JPAccount *account=[JPAccount objectWithKeyValues:responseObject];//因为有个自定义的属性（创建时间），所以不能使用第三方框架方法
        
        //存储账号信息
        [JPAccountTool saveAccount:account];
        
        //切换窗口的根控制器
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        [window switchRootViewController];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];//若超时，失败了就隐藏加载中的界面
        NSLog(@"请求失败，%@",error);
    }];
    
    //Error Domain=com.alamofire.error.serialization.response Code=-1016 \"Request failed: unacceptable content-type: text/plain\
    //出现这种错误是因为返回的类型是“text/plain”，AFNetworking不认得
    //AFNetworking只认得application/json、text/json、text/javascript
    //要自己手动在AFNetworking的[AFJSONResponseSerializer serializer]里面的初始化方法中的self.acceptableContentTypes属性中添加@"text/plain"这种类型让AFNetworking认得这种类型
    
    /*
        请求成功，{
        "access_token" = "2.00ONMODCq8cOCC9f347d1de7feK9CD";
        "expires_in" = 157679999; //过期时间：5年
        "remind_in" = 157679999;
        uid = 1879978212;
        }
     */
    
}



@end
