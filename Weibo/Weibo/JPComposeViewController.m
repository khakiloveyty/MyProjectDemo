//
//  JPComposeViewController.m
//  Weibo
//
//  Created by apple on 15/7/18.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPComposeViewController.h"
#import "UIView+Extension.h"
#import "JPAccountTool.h"
#import "UIView+Extension.h"
#import "JPEmotionTextView.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "JPComposeToolbar.h"
#import "JPComposePhotosView.h"
#import "JPEmotionKeyboard.h"
#import "JPEmotion.h"

@interface JPComposeViewController ()<UITextViewDelegate,JPComposeToolbarDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
//输入控件
@property(nonatomic,weak)JPEmotionTextView *textView;
//键盘顶部的工具条
@property(nonatomic,weak)JPComposeToolbar *toolbar;
//要发布的图片的相册（存放拍照或者相册中选择的图片）
@property(nonatomic,weak)JPComposePhotosView *photosView;
//表情键盘
@property(nonatomic,strong)JPEmotionKeyboard *emotionKeyboard;

//判断是否正在切换键盘
@property(nonatomic,assign)BOOL switchingKeyboard;
@end

@implementation JPComposeViewController

//使用懒加载：保证表情键盘只会创建一次，不需要每次弹出表情键盘都需要重新创建
-(JPEmotionKeyboard *)emotionKeyboard{
    if (!_emotionKeyboard) {
        _emotionKeyboard=[[JPEmotionKeyboard alloc]init];
        //如果键盘本来就有非0的宽度，那么系统就会强制让键盘的宽度等于屏幕的宽度
        _emotionKeyboard.width=self.view.width;
        _emotionKeyboard.height=216;
    }
    return _emotionKeyboard;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    //设置导航栏内容
    [self setupNav];
    
    //添加编辑微博textView控件
    [self setupTextView];
    
    //可设置不自动调整内容间距（默认YES：当UIScrollView检测到有UINavigationBar、UITabBar等控件会自动调整scrollView的内容间距contentInset）
    //self.automaticallyAdjustsScrollViewInsets=NO;//设置为NO就不会自动调整
    //automaticallyAdjustsScrollViewInsets是UIScrollView的属性
    
    //添加工具条
    [self setupToolbar];
    
    //添加要发布的图片的相册（1~9张）
    [self setupPhotosView];
    
}

//当视图即将显示时调用：先让渲染主题颜色的代码就绪好
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置“发送”按钮不可用（因为没有微博内容）
    //如果在viewDidLoad设置的话，当执行完这句代码时渲染主题颜色（不可用状态和普通状态的字体颜色）的那部分代码还没就绪好，所以要放到这里，让渲染主题颜色的代码就绪好
    self.navigationItem.rightBarButtonItem.enabled=NO;
}

//当视图完全显示时调用：弹出键盘
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //弹出键盘（让textView成为第一响应者：能输入文本的控件一旦成为第一响应者就会弹出键盘）
    [self.textView becomeFirstResponder];
}

//设置导航栏内容
-(void)setupNav{
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(send)];
    
    //设置“发送”按钮不可用（因为没有微博内容）
    //self.navigationItem.rightBarButtonItem.enabled=NO;
    
    NSString *prefix=@"发微博";
    NSString *userName=[JPAccountTool account].name;
    
    if (userName) {
        //如果有用户名（用户名已经加载好）
        
        //创建标题的label
        UILabel *titleView=[[UILabel alloc]init];
        titleView.width=200;
        titleView.height=44;
        titleView.textAlignment=NSTextAlignmentCenter;//设置内容居中
        titleView.numberOfLines=0;//设置自动换行，0能换无限行
        
        //拼接标题内容
        NSString *titleText=[NSString stringWithFormat:@"%@\n%@",prefix,userName];
        
        //创建一个带有属性的标题内容字符串（比如颜色属性、字体属性等文字属性）
        NSMutableAttributedString *attrStr=[[NSMutableAttributedString alloc]initWithString:titleText];
        //添加属性
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:[titleText rangeOfString:prefix]];//boldSystemFontOfSize：设置为粗体
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[titleText rangeOfString:userName]];
        //参数1：属性类型
        //参数2：属性值
        //参数3：属性作用在字符串的范围
        
        //将设置好属性的标题字符串添加到label中
        titleView.attributedText=attrStr;
        
        //将标题label添加到标题视图上
        self.navigationItem.titleView=titleView;
        
    }else{
        //没有用户名（用户名还没加载好）
        
        self.title=prefix;//直接让标题显示为“发微博”
    }
}

/**
 UITextField:
    1.文字永远是一行，不能显示多行文字
    2.有placeholder属性设置占位文字
    3.继承自UIControl
    4.监听行为：
        1>设置代理（.delegate）
        2>addTarget: action: forControlEvents:
        3>通知：UITextFieldTextDidChangeNotification
 
 UITextView:
    1.能显示任意行文字
    2.不能设置占位文字
    3.继承自UIScrollView
    4.监听行为：
        1>设置代理（.delegate）
        2>通知：UITextViewTextDidChangeNotification
 
 推荐：自定义一个UITextView控件，添加placeholder属性设置占位文字
 */

//添加编辑微博textView控件
-(void)setupTextView{
    //因为UITextView继承UIScrollView，知道有UINavigationBar控件的存在，textView的contentInset会调整为(64,0,0,0)，距离顶部64点
    JPEmotionTextView *textView=[[JPEmotionTextView alloc]init];
    textView.frame=self.view.bounds;
    textView.font=[UIFont systemFontOfSize:15];
    textView.placeholder=@"分享新鲜事...";
    //设置垂直方向上永远可以拖拽（有弹簧效果）：以实现监听视图是否拖拽收回键盘
    textView.alwaysBounceVertical=YES;
    //设置自己为代理方实现监听拖拽方法
    textView.delegate=self;
    [self.view addSubview:textView];
    self.textView=textView;
    
    
    //添加通知观察者
    
    //1.文字改变的通知：监听是否开始编辑微博，判断发送按钮能否可用
    //当UITextView的文字发生改变时，UITextView自己会发出一个UITextViewTextDidChangeNotification通知（触发通知的时机）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];
    //object:textView 声明是textView发出的通知（若不设置为textView且有两个textView，当另一个textView也发出这个通知，就会触发这个textView设定的响应方法）
    
    //2.监听键盘的frame发生改变时发出的通知：让工具条跟着键盘挪动
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //object:nil 是系统键盘发出的通知
    
    /*
     键盘通知：
        *键盘的frame发生改变时发出的通知*
        UIKeyboardWillChangeFrameNotification
        UIKeyboardDidChangeFrameNotification
     
        *键盘的显示时发出的通知*
        UIKeyboardWillShowNotification
        UIKeyboardDidShowNotification
     
        *键盘的隐藏时发出的通知*
        UIKeyboardWillHideNotification
        UIKeyboardDidHideNotification
     */
    
    
    //3.监听表情键盘上的哪个表情被点击了
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelect:) name:@"EmotionDidSelectNotification" object:nil];
    
    //4.监听表情键盘上的删除按钮被点击了
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidDelete) name:@"EmotionDidDeleteNotification" object:nil];
}

//添加工具条
-(void)setupToolbar{
    JPComposeToolbar *toolbar=[[JPComposeToolbar alloc]init];
    toolbar.width=self.view.width;
    toolbar.height=44;
    
    toolbar.delegate=self;//设置自己为toolbar的代理方
    
    //让工具条显示在视图下方
    toolbar.x=0;
    toolbar.y=self.view.height-toolbar.height;
    [self.view addSubview:toolbar];
    self.toolbar=toolbar;
    
    //inputView：使用其他控件代替键盘弹出
    //self.textView.inputView=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    //inputAccessoryView：在键盘上方添加控件
    //self.textView.inputAccessoryView=toolbar;
}

//添加要发布的图片的相册（1~9张）
-(void)setupPhotosView{
    JPComposePhotosView *photosView=[[JPComposePhotosView alloc]init];
    photosView.width=self.view.width-10;
    photosView.height=self.view.height-100;
    photosView.x=5;
    photosView.y=100;
    [self.textView addSubview:photosView];
    self.photosView=photosView;
}

//取消按钮的响应方法
-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//发送按钮的响应方法
-(void)send{
    //因为 发布纯文字的微博 和 发布带有图片的微博 的api接口不同，所以要进行判断
    if (self.photosView.photos.count) {
        //如果有图片，则发布带有图片的微博
        [self sendWithImage];
    }else{
        //否则发布纯文字的微博
        [self sendWithoutImage];
    }
    
    //退出发微博界面
    [self dismissViewControllerAnimated:YES completion:nil];
}

//发送按钮的响应方法：发布纯文字的微博
-(void)sendWithoutImage{
    
    //发布纯文字的微博的url：https://api.weibo.com/2/statuses/update.json
    /*
     请求方式：POST
     请求参数：
     access_token(string)：采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
     status(string)：要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。
     */
    
    //1.请求管理者
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    
    //2.拼接请求参数
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"access_token"]=[JPAccountTool account].access_token;
    params[@"status"]=self.textView.fullText;//已经解析好的含有表情图片的文本内容
    
    //3.发送请求
    [manger POST:@"https://api.weibo.com/2/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        //显示发送成功
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"加载新微博数据失败，%@",error);
        //显示发送失败
        [MBProgressHUD showError:@"发送失败"];
    }];
    
}

//发送按钮的响应方法：发布带有图片的微博
-(void)sendWithImage{
    
    //发布带有图片的微博的url：https://upload.api.weibo.com/2/statuses/upload.json
    /*
     请求方式：POST
     请求参数：
     access_token(string)：采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
     status(string)：要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。
     pic(binary)：要上传的图片，仅支持JPEG、GIF、PNG格式，图片大小小于5M。
     */
    
    //1.请求管理者
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    
    //2.拼接请求参数
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"access_token"]=[JPAccountTool account].access_token;
    params[@"status"]=self.textView.fullText;//已经解析好的含有表情图片的文本内容
    
    //3.发送请求
    //上传文件的方法：文件 --> NSData --> 上传
    //注意：只能用POST请求上传文件，必须选择带有constructingBodyWithBlock的那个方法
    //params不能放文件参数，要上传的文件必须在constructingBody的Block中处理
    [manger POST:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //1.获取上传的图片
        UIImage *image=[self.photosView.photos firstObject];
        //新浪开发者账号只允许上传一张图片。。。
        
        //2.转换格式：image --> NSData
        NSData *data=UIImageJPEGRepresentation(image, 1.0);
        //参数1：要上传的图片    参数2：失真度（1为像素最清晰）
        
        //3.将文件数据拼接到formData中
        //因为文件的类型有多种，所以才要在这里设置上传文件的请求参数名，还有上传给服务器之后，告诉服务器文件原本的类型和文件名字
        [formData appendPartWithFileData:data name:@"pic" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
        //name：请求参数名，服务器给的参数名称接口！要相对应！
        //fileName：想要修改的文件名
        //mimeType：文件的类型
        
    }  success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        //显示发送成功
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"加载新微博数据失败，%@",error);
        //显示发送失败
        [MBProgressHUD showError:@"发送失败"];
    }];
    
}


#pragma mark - 监听是否有内容输入的响应方法
//监听文字改变（开始输入文字）
-(void)textDidChange{
    //当监听到有文字输入，让发送按钮能够响应点击
    //hasText：是否在输入文字
    self.navigationItem.rightBarButtonItem.enabled=self.textView.hasText;
}
-(void)dealloc{ //使用了通知要记得在销毁本程序时移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 监听键盘是否弹出
//监听键盘的frame的改变：让工具条的位置根据键盘的位置进行改动
-(void)keyboardWillChangeFrame:(NSNotification *)notification{
    /*
     notification.userInfo = @{
          *********** key ************     ********** value ***********
         UIKeyboardFrameBeginUserInfoKey = NSRect: {{0, 568}, {320, 216}},  //键盘弹出前的frame
         UIKeyboardCenterEndUserInfoKey = NSPoint: {160, 460},
         UIKeyboardBoundsUserInfoKey = NSRect: {{0, 0}, {320, 216}},
         UIKeyboardFrameEndUserInfoKey = NSRect: {{0, 352}, {320, 216}},    //键盘弹出后的frame
         UIKeyboardAnimationDurationUserInfoKey = 0.25,                     //键盘弹出\隐藏消耗的时间
         UIKeyboardCenterBeginUserInfoKey = NSPoint: {160, 676},
         UIKeyboardAnimationCurveUserInfoKey = 7        //键盘弹出\隐藏的动画的执行节奏（先快后慢、匀速等）
        }
     */
    
    //先判断是否正在切换键盘，如果是，则不需要再执行下面代码（让工具条保持不动）
    if (self.switchingKeyboard) {
        return;
    }
    
    NSDictionary *userInfo=notification.userInfo;
    
    //获取键盘弹出\隐藏消耗的时间
    double duration=[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //NSTimeInterval是double类型
    
    //获取键盘弹出后的frame
    CGRect keboardF=[userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //使用动画
    [UIView animateWithDuration:duration animations:^{
        if (keboardF.origin.y>self.view.height) {
            //如果键盘的Y值超过控制器的view的高度（可能控制器添加了超出自身view的高度的控件）
            //让工具条显示在屏幕下方
            self.toolbar.y=self.view.height-self.toolbar.height;
        }else{
            //否则就跟在键盘的上方（键盘的Y值一般是等于控制器的view的高度）
            self.toolbar.y=keboardF.origin.y-self.toolbar.height;
        }
    }];
}



#pragma mark - UITextViewDelegate
//监听：当开始拖动视图时
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //要先设置textView.alwaysBounceVertical=YES，为了让无论内容多少都能拖拽视图
    
    //结束编辑状态，键盘下去
    [self.view endEditing:YES];
}



#pragma mark - JPComposeToolbarDelegate
-(void)composeToolbar:(JPComposeToolbar *)toolbar didClickButton:(JPComposeToolbarButtonType)buttonType{
    switch (buttonType) {
        case JPComposeToolbarButtonTypeCamera: //拍照
            [self openCamera];//打开照相机
            break;
        case JPComposeToolbarButtonTypePicture: //相册
            [self openPictureAlbum];//打开本地相册
            break;
        case JPComposeToolbarButtonTypeMention: // @
            
            break;
        case JPComposeToolbarButtonTypeTrend: // # 话题
            
            break;
        case JPComposeToolbarButtonTypeEmotion: // 表情
            //切换键盘
            [self switchKeyboard];
            break;
        default:
            break;
    }
}



#pragma mark - 工具条按钮的响应方法
//打开照相机
-(void)openCamera{
    [self getImageWithSourceType:UIImagePickerControllerSourceTypeCamera];
}

//打开本地相册
-(void)openPictureAlbum{
    [self getImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    /*
     UIImagePickerControllerSourceTypePhotoLibrary  用户所有的相册
     UIImagePickerControllerSourceTypeSavedPhotosAlbum  系统自带的相册
     */
}

//获取图片
-(void)getImageWithSourceType:(UIImagePickerControllerSourceType)type{
    //先判断图片的来源可不可用
    if (![UIImagePickerController isSourceTypeAvailable:type]) {
        //若不可用则退出方法
        return;
    }
    
    //1.创建获取图片控制器
    UIImagePickerController *ipc=[[UIImagePickerController alloc]init];
    //2.选择图片获取来源（从本地照相机、本地相册等）
    ipc.sourceType=type;
    //3.设置代理方（选择图片后的处理）
    ipc.delegate=self;
    //4.推出图片的来源页面
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate 选择图片的响应方法
//从UIImagePickerController选择完图片后就调用（即照相完毕、在相册选择图片完毕）
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //NSLog(@"%@",info);
    /*
     UIImagePickerControllerOriginalImage = <UIImage: 0x7f9f79da1200> size {1500, 1001} orientation 0 scale 1.000000,
     UIImagePickerControllerMediaType = public.image,
     UIImagePickerControllerReferenceURL = assets-library://asset/asset.JPG?id=AF7BDDBC-7FB2-4AEF-84F0-65A0E5B9B9B3&ext=JPG
     */
    
    //info包含了选择的图片和相关信息
    
    //获取选择的图片
    UIImage *image=info[UIImagePickerControllerOriginalImage];
    
    //添加图片到photosView中
    [self.photosView addPhoto:image];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//点击表情按钮：切换键盘
-(void)switchKeyboard{
    //self.textView.inputView=其他控件：使用其他控件代替键盘弹出
    //self.textView.inputView=nil 则是系统自带的键盘
    
    if (self.textView.inputView==nil) {
        //如果是系统自带的键盘，则切换成自己创建的表情键盘
        self.textView.inputView=self.emotionKeyboard;
        
        //图标切换成键盘图标
        self.toolbar.showKeyboardButton=YES;
    }else{
        //否则，让inputView=nil，切换为系统自带键盘
        self.textView.inputView=nil;
        
        //图标切换成表情图标
        self.toolbar.showKeyboardButton=NO;
    }
    
    //修改inputView之后需要重新弹出键盘才能实现切换
    
    //1.声明正在切换键盘：让工具条保持不动
    self.switchingKeyboard=YES;
    
    //2.退出键盘
    [self.textView resignFirstResponder];
    
    //3.弹出键盘（因为退出键盘和弹出键盘这两句代码写在一起会使键盘瞬间切换，为能看到切换效果，实施延时弹出）
    //让主线程延时0.1后再执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //1.先声明结束切换键盘：让工具条附在键盘上方
        self.switchingKeyboard=NO;
        
        //2.弹出键盘
        [self.textView becomeFirstResponder];
        
        //如果先弹出键盘再结束切换键盘状态，那么弹出键盘之后工具条就会给预读条遮盖掉
        //因为弹出键盘之后，键盘的frame没有再改变，此时还没有执行到 结束切换键盘 这句代码（因为弹出键盘太快了）
        //也就没有触发相应的响应方法，所以要先执行 结束切换键盘 这句代码，即使出现预读条也能即时让工具条附在键盘的最上方
        
    });
}

#pragma mark - 表情键盘的监听方法
//插入表情图片
-(void)emotionDidSelect:(NSNotification *)notification{
    JPEmotion *emotion=notification.userInfo[@"selectedEmotion"];
    
    //插入表情图片
    [self.textView insertEmotion:emotion];
    
    //当监听到有文字输入，让发送按钮能够响应点击
    //hasText：是否在输入内容
    self.navigationItem.rightBarButtonItem.enabled=self.textView.hasText;
}

//删除文本内容
-(void)emotionDidDelete{
    //删除功能
    [self.textView deleteBackward];
}

@end
