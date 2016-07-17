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

@interface JPShowPictureViewController () <UIScrollViewDelegate>
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
    
    //不是gif才让图片能放大
    if (isgif==NO) {
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
    [self.scrollView addSubview:imageView];
    self.imageView=imageView;
    
    //添加手势
    //单击返回
    UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close:)];
    [imageView addGestureRecognizer:tapGR];
    
    //双击放大、还原
    UITapGestureRecognizer *doubleTapGR=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enlargeOrReturn:)];
    doubleTapGR.numberOfTapsRequired=2;
    [self.imageView addGestureRecognizer:doubleTapGR];
    
    //设置双击优先级比单击高
    [tapGR requireGestureRecognizerToFail:doubleTapGR];
    
    
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
    //创建CATransition对象
    CATransition *animation=[CATransition animation];
    animation.duration=0.5;
    animation.type=kCATransitionFade;
    [KeyWindow.layer addAnimation:animation forKey:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
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

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return  self.imageView;
}

//让图片居中（当图片不是在scrollView的顶部，缩放时会在上方留下一截）
- (void)scrollViewDidZoom:(UIScrollView *)aScrollView{
    CGFloat offsetX = (aScrollView.bounds.size.width > aScrollView.contentSize.width)?
    (aScrollView.bounds.size.width - aScrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (aScrollView.bounds.size.height > aScrollView.contentSize.height)?
    (aScrollView.bounds.size.height - aScrollView.contentSize.height) * 0.5 : 0.0;
    self.imageView.center = CGPointMake(aScrollView.contentSize.width * 0.5 + offsetX,aScrollView.contentSize.height * 0.5 + offsetY);
}

//双击放大、还原
-(void)enlargeOrReturn:(UITapGestureRecognizer *)doubleTapGR{
    if (self.scrollView.zoomScale>1) {
        [self.scrollView setZoomScale:1.0 animated:YES];
    }else{
        CGPoint touchPoint = [doubleTapGR locationInView:self.imageView];
        CGFloat newZoomScale = self.scrollView.maximumZoomScale;
        CGFloat xsize = self.scrollView.frame.size.width / newZoomScale;
        CGFloat ysize = self.scrollView.frame.size.height / newZoomScale;
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

@end
