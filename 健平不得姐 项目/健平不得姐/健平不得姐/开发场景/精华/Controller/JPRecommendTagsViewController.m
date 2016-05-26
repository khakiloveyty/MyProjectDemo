//
//  JPRecommendTagsViewController.m
//  健平不得姐
//
//  Created by ios app on 16/5/16.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPRecommendTagsViewController.h"
#import "JPRecommendTag.h"
#import "JPRecommendTagCell.h"

@interface JPRecommendTagsViewController ()
@property(nonatomic,strong)AFHTTPSessionManager *manager;
@property(nonatomic,strong)NSArray *recommendTags;
@end

@implementation JPRecommendTagsViewController

-(AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager=[AFHTTPSessionManager manager];
    }
    return _manager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    
    [self loadRecommendTags];
    
}

-(void)setupTableView{
    self.title=@"推荐标签";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JPRecommendTagCell" bundle:nil] forCellReuseIdentifier:@"JPRecommendTagCell"];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.backgroundColor=JPGlobalColor;
    self.tableView.rowHeight=80;
}

-(void)loadRecommendTags{
    [SVProgressHUD show];
    
    //向服务器发送请求
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"a"]=@"tag_recommend";
    params[@"c"]=@"topic";
    params[@"action"]=@"sub";
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        [SVProgressHUD dismiss];
        
        self.recommendTags=[JPRecommendTag mj_objectArrayWithKeyValuesArray:responseObject];
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        JPLog(@"失败");
        [SVProgressHUD showErrorWithStatus:@"加载数据失败"];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recommendTags.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JPRecommendTagCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JPRecommendTagCell"];
    cell.recommendTag=self.recommendTags[indexPath.row];
    
    return cell;
}

@end
