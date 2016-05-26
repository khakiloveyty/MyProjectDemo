//
//  JPDiscoverViewController.m
//  Weibo
//
//  Created by apple on 15/7/4.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPDiscoverViewController.h"
#import "UIView+Extension.h"
#import "JPSearchBar.h"
#import "TestViewController.h"

@interface JPDiscoverViewController ()
@property(nonatomic,weak)JPSearchBar *searchBar;
@end

@implementation JPDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UISearchBar *searchBar=[[UISearchBar alloc]init];
//    searchBar.scopeBarBackgroundImage=[UIImage imageNamed:@"searchbar_textfield_background"];
//    searchBar.height=30;
//    self.navigationItem.titleView=searchBar;
    
    //创建搜索框对象（用文本编辑器代替，苹果自带的搜索框不好用）
    //使用自定义的搜索框控件（继承UITextField）
    JPSearchBar *searchBar=[JPSearchBar searchBar];
    searchBar.width=355;
    searchBar.height=30;
    self.navigationItem.titleView=searchBar;//将搜索框添加到导航栏的标题视图
    self.searchBar=searchBar;
    
}

//监听：当开始拖动视图时
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //放弃第一响应者，退出键盘
    [self.searchBar resignFirstResponder];
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [textField resignFirstResponder];
//    return YES;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 2;
    }else if(section==1){
        return 3;
    }else{
        return 5;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" ];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            cell.imageView.image=[UIImage imageNamed:@"hot_status"];
            cell.textLabel.text=@"热门微博";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.imageView.image=[UIImage imageNamed:@"find_people"];
            cell.textLabel.text=@"找人";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
    }else if(indexPath.section==1){
        if (indexPath.row==0) {
            cell.imageView.image=[UIImage imageNamed:@"game_center"];
            cell.textLabel.text=@"游戏中心";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }else if(indexPath.row==1){
            cell.imageView.image=[UIImage imageNamed:@"near"];
            cell.textLabel.text=@"周边";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.imageView.image=[UIImage imageNamed:@"app"];
            cell.textLabel.text=@"应用";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
    }else{
        if (indexPath.row==0) {
            cell.imageView.image=[UIImage imageNamed:@"video"];
            cell.textLabel.text=@"视频";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }else if(indexPath.row==1){
            cell.imageView.image=[UIImage imageNamed:@"music"];
            cell.textLabel.text=@"音乐";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }else if(indexPath.row==2){
            cell.imageView.image=[UIImage imageNamed:@"movie"];
            cell.textLabel.text=@"电影";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }else if(indexPath.row==3){
            cell.imageView.image=[UIImage imageNamed:@"cast"];
            cell.textLabel.text=@"博客";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.imageView.image=[UIImage imageNamed:@"more"];
            cell.textLabel.text=@"更多";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TestViewController *testVC=[[TestViewController alloc]init];
    [self.navigationController pushViewController:testVC animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
