//
//  MJSampleIndexViewController.m
//  快速集成下拉刷新
//
//  Created by mj on 14-1-3.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

/*
 具体用法：查看MJRefresh.h
 */
#import "MJSampleIndexViewController.h"
#import "MJSampleIndex.h"
#import "MJTableViewController.h"
#import "MJCollectionViewController.h"

NSString *const MJSampleIndexCellIdentifier = @"Cell";

@interface MJSampleIndexViewController ()
{
    NSArray *_sampleIndexs;
    SRRefreshView *slimeView;
    UITableView *mTab;
}
@end

@implementation MJSampleIndexViewController

- (SRRefreshView *)slimeView
{
    if (slimeView == nil) {
        slimeView = [[SRRefreshView alloc] init];
        slimeView.delegate = self;
        slimeView.upInset = 0;
        slimeView.slimeMissWhenGoingBack = YES;
        slimeView.slime.bodyColor = [UIColor grayColor];
        slimeView.slime.skinColor = [UIColor grayColor];
        slimeView.slime.lineWith = 1;
        slimeView.slime.shadowBlur = 4;
        slimeView.slime.shadowColor = [UIColor grayColor];
    }
    
    return slimeView;
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (slimeView) {
        [slimeView scrollViewDidScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (slimeView) {
        [slimeView scrollViewDidEndDraging];
    }
}

#pragma mark - slimeRefresh delegate
//加载更多
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [slimeView endRefresh];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"快速集成下拉刷新";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIView *baView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 100, 20)];
    baView.backgroundColor = [UIColor redColor];
    
    
    //self.navigationController.navigationBarHidden = YES;
    // 1.注册cell
    
    mTab = [[UITableView alloc] initWithFrame:CGRectMake(0,20,self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    mTab.delegate = self;
    mTab.dataSource =self;
    
    [mTab registerClass:[UITableViewCell class] forCellReuseIdentifier:MJSampleIndexCellIdentifier];
    
    // 2.初始化数据
    MJSampleIndex *si1 = [MJSampleIndex sampleIndexWithTitle:@"tableView刷新演示" controllerClass:[MJTableViewController class]];
    MJSampleIndex *si2 = [MJSampleIndex sampleIndexWithTitle:@"collectionView刷新演示" controllerClass:[MJCollectionViewController class]];
    _sampleIndexs = @[si1, si2];
    
    [mTab addSubview:[self slimeView]];
    
   
    
    [self.view addSubview:mTab];
    
    [self.view addSubview:baView];
    
    NSLog(@"---%f---%f",mTab.frame.origin.y,mTab.frame.size.height);
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _sampleIndexs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MJSampleIndexCellIdentifier forIndexPath:indexPath];
    
    // 1.取出模型
    MJSampleIndex *si = _sampleIndexs[indexPath.row];
    
    // 2.赋值
    cell.textLabel.text = si.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.取出模型
    MJSampleIndex *si = _sampleIndexs[indexPath.row];
    
    // 2.创建控制器
    UIViewController *vc = [[si.controllerClass alloc] init];
    vc.title = si.title;

    // 3.跳转
    [self.navigationController pushViewController:vc animated:YES];
}

@end
