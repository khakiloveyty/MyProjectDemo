//
//  JPEssenceViewController.m
//  健平不得姐
//
//  Created by ios app on 16/5/12.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPEssenceViewController.h"
#import "JPRecommendTagsViewController.h"
#import "JPEssenceTitleCell.h"
#import "JPTopicesViewController.h"

@interface JPEssenceViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
/** 标签栏 */
@property(nonatomic,weak)UICollectionView *titlesView;
/** 标签栏底部提示图 */
@property(nonatomic,weak)UIView *indicatorView;
/** 标签数组 */
@property(nonatomic,strong)NSArray *titles;
/** 标签栏选中下标 */
@property(nonatomic,strong)NSIndexPath *selectedIndexPath;
/** 底部滚动视图 */
@property(nonatomic,weak)UIScrollView *contentView;
@end

@implementation JPEssenceViewController

-(NSArray *)titles{
    if (!_titles) {
        _titles=@[@"全部",@"视频",@"声音",@"图片",@"段子",@"网红",@"社会",@"美女",@"游戏",@"排行"];
    }
    return _titles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=JPGlobalColor;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    //设置导航栏内容
    [self setupNavigationItem];
    
    //初始化子控制器
    [self setupChildVCes];

    //设置顶部的标签栏
    [self setupTitlesView];
    
    //设置底层scrollView
    [self setupContentView];
    
}

#pragma mark - 设置导航栏内容

-(void)setupNavigationItem{
    self.navigationItem.titleView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self andAction:@selector(leftBtnClick) andImageName:@"MainTagSubIcon" andHighImageName:@"MainTagSubIconClick"];
}

-(void)leftBtnClick{
    JPRecommendTagsViewController *tagsVC=[[JPRecommendTagsViewController alloc] init];
    [self.navigationController pushViewController:tagsVC animated:YES];
}

#pragma mark - 初始化子控制器

-(void)setupChildVCes{
    JPTopicesViewController *allVC=[[JPTopicesViewController alloc] init];
    JPTopicesViewController *videoVC=[[JPTopicesViewController alloc] init];
    JPTopicesViewController *voiceVC=[[JPTopicesViewController alloc] init];
    JPTopicesViewController *pictureVC=[[JPTopicesViewController alloc] init];
    JPTopicesViewController *wordVC=[[JPTopicesViewController alloc] init];
    
    allVC.title=@"全部";
    allVC.type=JPAllTopic;
    
    videoVC.title=@"视频";
    videoVC.type=JPVideoTopic;
    
    voiceVC.title=@"声音";
    voiceVC.type=JPVoiceTopic;
    
    pictureVC.title=@"图片";
    pictureVC.type=JPPictureTopic;
    
    wordVC.title=@"段子";
    wordVC.type=JPWordTopic;
    
    [self addChildViewController:allVC];
    [self addChildViewController:videoVC];
    [self addChildViewController:voiceVC];
    [self addChildViewController:pictureVC];
    [self addChildViewController:wordVC];
}

#pragma mark - 设置顶部的标签栏

-(void)setupTitlesView{
    
    CGFloat itemHeight=JPTitlesViewHeight;
    CGFloat itemWidth=self.view.width/self.childViewControllers.count;
    
    //设置标签栏布局
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.itemSize=CGSizeMake(itemWidth, itemHeight);
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing=0;
    
    //初始化标签栏
    UICollectionView *titlesView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, JPTitlesViewY, self.view.width, itemHeight) collectionViewLayout:layout];
    titlesView.delegate=self;
    titlesView.dataSource=self;
    titlesView.backgroundColor=[UIColor colorWithWhite:1 alpha:0.9];
    titlesView.showsHorizontalScrollIndicator=NO;
    [self.view addSubview:titlesView];
    self.titlesView=titlesView;
    
    //注册cell
    [titlesView registerClass:[JPEssenceTitleCell class] forCellWithReuseIdentifier:@"JPEssenceTitleCell"];
    
    //初始化标签底部红色指示器
    
    //由于cell在这个时候还没创建出来，所以不能根据cell来确定indicatorView的位置和尺寸，只好一开始就放在第一个cell对应的位置那里，并拿出第一个标签算好它的文字长度
    
    //拿到第一个标签的文字长度（label默认字体大小为17）
    CGFloat indicatorViewW=[self.titles[0] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}].width;
    CGFloat indicatorViewH=2;
    
    UIView *indicatorView=[[UIView alloc] init];
    indicatorView.width=indicatorViewW;
    indicatorView.height=indicatorViewH;
    indicatorView.x=(itemWidth-indicatorViewW)/2;
    indicatorView.y=titlesView.height-indicatorViewH;
    indicatorView.backgroundColor=[UIColor redColor];
    [titlesView addSubview:indicatorView];
    self.indicatorView=indicatorView;
    
    //选中第一个
    NSIndexPath *indexPath=[NSIndexPath indexPathForItem:0 inSection:0];
    self.selectedIndexPath=indexPath;
    [titlesView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
}

#pragma mark - 设置底层scrollView

-(void)setupContentView{
    UIScrollView *contentView=[[UIScrollView alloc] init];
    contentView.frame=self.view.bounds;
    contentView.delegate=self;
    contentView.pagingEnabled=YES;//翻页滚动
    [self.view insertSubview:contentView belowSubview:self.titlesView];
    self.contentView=contentView;
    
    //设置内容尺寸（宽度=自身宽度×子控制器的数目）
    contentView.contentSize=CGSizeMake(contentView.width*self.childViewControllers.count, 0);
    
    //初始化添加第一个子控制器view（调用代理方法添加）
    [self scrollViewDidEndScrollingAnimation:contentView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JPEssenceTitleCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"JPEssenceTitleCell" forIndexPath:indexPath];
    
    cell.title=self.titles[indexPath.item];
    cell.tag=indexPath.item;
    
    return cell;
    
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.selectedIndexPath.item==indexPath.item) {
        return;
    }
    
    self.selectedIndexPath=indexPath;
    
    //使用self调用cellForItemAtIndexPath方法才能获取指定的cell，若用collectionView自己调用则只能获取屏幕上所显示到的cell
    JPEssenceTitleCell *cell=(JPEssenceTitleCell *)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    if (cell) {
        //提示图动画
        [UIView animateWithDuration:0.25 animations:^{
            self.indicatorView.width=cell.titleLabelWidth;
            self.indicatorView.centerX=cell.centerX;
        }];
        
        //cell滚动
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
        //底部scrollView滚动
        CGPoint offset=self.contentView.contentOffset;
        offset.x=cell.tag*self.contentView.width;
        [self.contentView setContentOffset:offset animated:YES];
    }
    
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==self.contentView) {
        CGFloat itemWidth=self.view.width/self.childViewControllers.count;
        self.indicatorView.x=(itemWidth-self.indicatorView.width)/2+(itemWidth*(scrollView.contentOffset.x/scrollView.width));
    }
}

//调用代码滚动动画停止时会调用该方法，手指滑动停止不会来到这里
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    //在滚动结束时才添加子控制器的view
    if (scrollView==self.contentView) {
        
        //获取下标
        NSInteger item=scrollView.contentOffset.x/scrollView.width;
        
        if (item>(self.childViewControllers.count-1)) {
            return;
        }
        
        //获取子控制器
        UITableViewController *vc=self.childViewControllers[item];
        
        if (![scrollView.subviews containsObject:vc.view]) {
            //设置子控制器view的位置
            vc.view.x=item*scrollView.width;
            //默认控制器view的y值会有20个点，且高度也会少20个点
            vc.view.y=0;
            vc.view.height=scrollView.height;
            
            //添加子控制器view到底部scrollView上
            [scrollView addSubview:vc.view];
        }
        
    }
}

//手指滑动动画停止时会调用该方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView==self.contentView) {
        //获取下标
        NSInteger item=scrollView.contentOffset.x/scrollView.width;
        NSIndexPath *indexPath=[NSIndexPath indexPathForItem:item inSection:0];
        
        //调用cell的点击方法（标签栏的动画效果）
        [self.titlesView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];//这个可以执行cell重写的setSelected方法，但不会调用didSelectItemAtIndexPath方法 ----> 让文字变色
        [self collectionView:self.titlesView didSelectItemAtIndexPath:indexPath];//这个为了让提示图有动画效果 ----> 执行didSelectItemAtIndexPath的方法
        
        //添加子控制器view（如果没有）
        [self scrollViewDidEndScrollingAnimation:scrollView];
    }
}

@end