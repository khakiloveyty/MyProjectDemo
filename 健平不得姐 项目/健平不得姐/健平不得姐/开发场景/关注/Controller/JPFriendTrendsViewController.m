//
//  JPFriendTrendsViewController.m
//  健平不得姐
//
//  Created by ios app on 16/5/12.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPFriendTrendsViewController.h"
#import "JPRecommendViewController.h"
#import "JPLoginRegisterViewController.h"

@interface JPFriendTrendsViewController ()

@end

@implementation JPFriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=@"我的关注";

    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self andAction:@selector(leftBtnClick) andImageName:@"friendsRecommentIcon" andHighImageName:@"friendsRecommentIcon-click"];
    
    self.view.backgroundColor=JPGlobalColor;
}

-(void)leftBtnClick{
    JPRecommendViewController *recommendVC=[[JPRecommendViewController alloc] init];
    [self.navigationController pushViewController:recommendVC animated:YES];
}

- (IBAction)loginRegister:(id)sender {
    JPLoginRegisterViewController *lrVC=[[JPLoginRegisterViewController alloc] init];
    [self presentViewController:lrVC animated:YES completion:nil];
}

@end
