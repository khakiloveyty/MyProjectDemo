//
//  JPShowPictureViewController.m
//  健平不得姐
//
//  Created by ios app on 16/5/23.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPShowPictureViewController.h"
#import "JPTopic.h"
#import "JPProgressView.h"

@interface JPShowPictureViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property(nonatomic,weak)UIImageView *imageView;
@property (weak, nonatomic) IBOutlet JPProgressView *progressView;
@end

@implementation JPShowPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //判断是否为gif图片
    NSString *extension=self.topic.big_image.pathExtension;//取出图片URL的扩展名
    BOOL isgif=[extension.lowercaseString isEqualToString:@"gif"];
    
    if (self.topic.type==JPPictureTopic && isgif==NO) {
#warning 图片浏览处理
        self.scrollView.minimumZoomScale = 1.0;
        self.scrollView.maximumZoomScale = 2.0;
    }
    
    //设置下间距
    self.textLabel.text=self.topic.text;
    CGFloat textH=[self.topic.text boundingRectWithSize:CGSizeMake(Screen_Width-15-15, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
    CGFloat bottomMargin=20+35+15+textH+10;
    self.scrollView.contentInset=UIEdgeInsetsMake(0, 0, bottomMargin, 0);
    
    //添加图片
    UIImageView *imageView=[[UIImageView alloc] init];
    imageView.userInteractionEnabled=YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close:)]];
    [self.scrollView addSubview:imageView];
    self.imageView=imageView;
    
    //设置尺寸
    CGFloat pictureWidth=Screen_Width;
    CGFloat pictureHeight=pictureWidth*(self.topic.imageHeight/self.topic.imageWidth);
    
    //设置位置
    CGFloat pictureX=0;
    CGFloat pictureY=(Screen_Height-pictureHeight)/2;//居中显示
    
    //如果图片高度超出屏幕高度
    if (pictureHeight>Screen_Height) {
        //置顶显示
        pictureY=0;
    }
    
    //让scrollView内容尺寸跟图片一致
    self.scrollView.contentSize=CGSizeMake(0, pictureY+pictureHeight);
    
    imageView.frame=CGRectMake(pictureX, pictureY, pictureWidth, pictureHeight);
    
    //马上显示当前图片的下载进度（如果还没下载完毕）
    [self.progressView setProgress:self.topic.pictureProgress animated:YES];

    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.big_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        [self.progressView setProgress:(1.0*receivedSize)/expectedSize];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error && image) {
            self.progressView.hidden=YES;
            [self.delegate updateTopic];
        }
    }];
 
}

////让当前控制器对应的状态栏为白色
//-(UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent; //修改状态栏为轻色系
}

- (IBAction)close:(id)sender {
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault; //返回时恢复状态栏原来样式
    [self dismissViewControllerAnimated:YES completion:nil];
}

//保存图片
- (IBAction)savePicture:(id)sender {
    if (self.topic.pictureProgress<1.0) {
        [SVProgressHUD showErrorWithStatus:@"图片还没下载完毕"];
        return;
    }
    
    //将图片写入相册
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

//image:didFinishSavingWithError:contextInfo: ----- 是UIImageWriteToSavedPhotosAlbum方法建议的回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
}

@end
