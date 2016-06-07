//
//  JPSettingViewController.m
//  健平不得姐
//
//  Created by ios app on 16/6/4.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPSettingViewController.h"
#import <SDImageCache.h>

@interface JPSettingViewController ()

@end

@implementation JPSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"设置";
    
    
}

-(void)getSize{
    //    [SDImageCache sharedImageCache].getSize;
    
    NSFileManager *manager=[NSFileManager defaultManager];
    
//    //获取文件夹内部的所有内容（当前文件夹，文件夹的文件夹的文件就获取不了）
//    NSArray *contents=[manager contentsOfDirectoryAtPath:cachePath error:nil];
//    //获取文件夹内的所有路径和子路径
//    NSArray *subpaths=[manager subpathsAtPath:cachePath];
    
    NSString *caches=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *cachePath=[caches stringByAppendingPathComponent:@"default/com.hackemist.SDWebImageCache.default"]; //SDWebImage缓存的路径
    
    //创建文件遍历器（遍历该文件夹里面的所有文件名）
    NSDirectoryEnumerator *fileEnumerator = [manager enumeratorAtPath:cachePath];
    
    NSUInteger size=0;
    for (NSString *fileName in fileEnumerator) {
        //拼接路径
        NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
        
        //判断文件是不是文件夹
        
        //方法一：
//        BOOL dir=NO;
//        // &dir：传这个布尔值指针，调用这个方法时就会赋值给这个布尔值
//        [manager fileExistsAtPath:filePath isDirectory:&dir];
//        if (dir) {
//            //如果是个文件夹，则跳过，进入下个循环
//            continue;
//        }
        
        //获取文件属性（文件大小、创建日期等，但不能获取整个文件夹所有属性(不准确)，只能获取单个）
        NSDictionary *attrs = [manager attributesOfItemAtPath:filePath error:nil];
        
        //方法二：
        //根据NSDictionary的文件类型属性判断
        if ([attrs.fileType isEqualToString:NSFileTypeDirectory]) {
            continue;
        }
        
        size += [attrs fileSize];
    }
//    JPLog(@"%lf",size*1.0/1024/1024);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    CGFloat size=1.0*[SDImageCache sharedImageCache].getSize/1000/1000;
    if (size==0.0) {
        cell.textLabel.text=@"清除缓存（已使用0MB）";
    }else{
        cell.textLabel.text=[NSString stringWithFormat:@"清除缓存（已使用%.2fMB）",size];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self clearCache:indexPath];
}

-(void)clearCache:(NSIndexPath *)indexPath{
    
    //获取目标行的cell
    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
    
    //创建菊花控件
    UIActivityIndicatorView *circle=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [circle startAnimating];
    
    //添加到cell的附件视图上
    cell.accessoryView=circle;
    
    //1.队列
    dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //2.提交任务
    dispatch_async(queue, ^{
        //清除缓存
        [[SDImageCache sharedImageCache] clearDisk];//清除所有缓存图片
        
        //3.在主线程中执行：
        dispatch_sync(dispatch_get_main_queue(), ^{ //同步比较安全，排队运行（看日志看对比）
            [SVProgressHUD showSuccessWithStatus:@"清除成功！"];
            cell.textLabel.text=@"清除缓存（已使用0MB）";
            cell.accessoryView=nil;
        });
    });
    
}

@end
