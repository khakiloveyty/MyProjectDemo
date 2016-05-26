//
//  JPSetupViewController.m
//  Weibo
//
//  Created by Mac on 15/8/17.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPSetupViewController.h"
#import "SDWebImageManager.h"

@interface JPSetupViewController ()

@end

@implementation JPSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"设置";
}

//删除缓存数据
-(void)fileOperation{
    
    //1.缓存路径（缓存的数据都会保存在Caches文件夹里面）
    NSString *caches=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    //2.创建文件管理者
    NSFileManager *manager=[NSFileManager defaultManager];
    
    //删除缓存数据
    [manager removeItemAtPath:caches error:nil];
    
    //把计算文件\文件夹大小的过程放入NSString的分类中完成
    /*
    //2.创建文件管理者
    NSFileManager *manager=[NSFileManager defaultManager];
    
    //3.遍历caches里面的所有内容
    
    //直接内容（文件夹里面的所有内容，不包括子文件夹里面的内容）
    //NSArray *contents=[manager contentsOfDirectoryAtPath:caches error:nil];
    
    //直接和间接内容（文件夹里面的所有内容，包括子文件夹里面的所有文件和文件夹及其里面的所有内容）
    NSArray *subpaths=[manager subpathsAtPath:caches];
    
    //遍历
    NSInteger totalByteSize=0; //用来记录caches文件夹里面所有内容的总大小
    for (NSString *subpath in subpaths) {
        //获取（拼接）该文件的全路径
        NSString *fullSubpath=[caches stringByAppendingPathComponent:subpath];
        
        //判断是否为文件夹
        BOOL dir=NO;
        [manager fileExistsAtPath:fullSubpath isDirectory:&dir];
        //参数2：通过外部的变量地址来修改这个变量的值（布尔值，用于判断是否为文件夹）
        
        if (dir==NO) {  //不是文件夹，是文件
            
            //算入这个文件的大小
            totalByteSize+=[[manager attributesOfItemAtPath:fullSubpath error:nil][NSFileSize] integerValue];//将对象类型转为数据类型
            
            //[manager attributesOfItemAtPath:fullSubpath error:nil]：获取该文件的属性，是一个字典类型，其中一个键为NSFileSize，它的值是这个文件的大小
        }
    }
    
    //得出caches文件夹的总大小
    //NSLog(@"%ld",totalByteSize);
     */
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    //取消选中状态
    cell.selectionStyle=UITableViewCellSelectionStyleNone;//使单元格没有点击的视图效果
    
    if (indexPath.section==0) {
        cell.textLabel.text=@"切换账号";
    }else{
        cell.textLabel.text=@"清除缓存";
        
        //缓存的图片字节大小（单位：B）
        long byteSize=[SDImageCache sharedImageCache].getSize;
        //转换单位：B --> KB --> M
        double size=byteSize/1000.0/1000.0;
        //NSLog(@"%lf",size);
        
        if (size==0.0) {
            cell.detailTextLabel.text=@"缓存大小(0M)";
        }else{
            cell.detailTextLabel.text=[NSString stringWithFormat:@"缓存大小(%.2fM)",size];
        }
    }
    
    return cell;
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        NSLog(@"切换账号");
    }else{
        [self clearCache:indexPath];
    }
}

-(void)clearCache:(NSIndexPath *)indexPath{
    NSLog(@"清除缓存");
    
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
        //[[SDImageCache sharedImageCache] clearDisk];//清除所有缓存图片
        [self fileOperation];//清除所有缓存数据
        
        //3.在主线程中执行：
        dispatch_sync(dispatch_get_main_queue(), ^{ //同步比较安全，排队运行（看日志看对比）
            cell.detailTextLabel.text=@"缓存大小(0M)";
            cell.accessoryView=nil;
            
//            //缓存的图片字节大小（单位：B）
//            long byteSize=[SDImageCache sharedImageCache].getSize;
//            //转换单位：B --> KB --> M
//            double size=byteSize/1000.0/1000.0;
//            cell.detailTextLabel.text=[NSString stringWithFormat:@"缓存大小(%.2fM)",size];
        });
    });

}



@end
