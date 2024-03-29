//
//  MJCollectionViewController.m
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
NSString *const MJCollectionViewCellIdentifier = @"Cell";

/**
 *  随机颜色
 */
#define MJRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

#import "MJCollectionViewController.h"
#import "MJTestViewController.h"
#import "MJRefresh.h"

@interface MJCollectionViewController ()
/**
 *  存放假数据
 */
@property (strong, nonatomic) NSMutableArray *fakeColors;
@end

@implementation MJCollectionViewController

#pragma mark - 初始化
/**
 *  数据的懒加载
 */
- (NSMutableArray *)fakeColors
{
    if (!_fakeColors) {
        self.fakeColors = [NSMutableArray array];
        
        for (int i = 0; i<5; i++) {
            // 添加随机色
            [self.fakeColors addObject:MJRandomColor];
        }
    }
    return _fakeColors;
}

/**
 *  初始化
 */
- (id)init
{
    // UICollectionViewFlowLayout的初始化（与刷新控件无关）
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 100);
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    layout.minimumInteritemSpacing = 20;
    layout.minimumLineSpacing = 20;
    // 设置全局section header 和 footer
    [layout setHeaderReferenceSize:CGSizeMake(200, 50)];
     [layout setFooterReferenceSize:CGSizeMake(200, 50)];
    return [self initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.初始化collectionView
    [self setupCollectionView];
    
    // 2.集成刷新控件
    [self addHeader];
    [self addFooter];
}

/**
 *  初始化collectionView
 */
- (void)setupCollectionView
{
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:MJCollectionViewCellIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class]forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CLHeader"];
    [self.collectionView registerClass:[UICollectionReusableView class]forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CLFooter"];
}

- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [self.collectionView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        // 增加5条假数据
        for (int i = 0; i<5; i++) {
            [vc.fakeColors insertObject:MJRandomColor atIndex:0];
        }
        
        // 模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [vc.collectionView reloadData];
            // 结束刷新
            [vc.collectionView headerEndRefreshing];
        });
    }];
    
#warning 自动刷新(一进入程序就下拉刷新)
    [self.collectionView headerBeginRefreshing];
}

- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    [self.collectionView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        // 增加5条假数据
        for (int i = 0; i<5; i++) {
            [vc.fakeColors addObject:MJRandomColor];
        }
        
        // 模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [vc.collectionView reloadData];
            // 结束刷新
            [vc.collectionView footerEndRefreshing];
        });
    }];
}

/**
 为了保证内部不泄露，在dealloc中释放占用的内存
 */
- (void)dealloc
{
    NSLog(@"MJCollectionViewController--dealloc---");
}

#pragma mark - collection数据源代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.fakeColors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MJCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = self.fakeColors[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MJTestViewController *test = [[MJTestViewController alloc] init];
    [self.navigationController pushViewController:test animated:YES];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *supplementaryView = nil;
    NSString *text = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CLHeader" forIndexPath:indexPath];
        text = [NSString stringWithFormat:@"Header %ld",(long)indexPath.section];
        supplementaryView.backgroundColor = [UIColor darkGrayColor];
    }
    else
    {
        supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CLFooter" forIndexPath:indexPath];;
        text = [NSString stringWithFormat:@"Footer %ld",(long)indexPath.section];
        supplementaryView.backgroundColor = [UIColor lightGrayColor];
    }
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    lab.backgroundColor = [UIColor clearColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor redColor];
    lab.text = text;
    [supplementaryView addSubview:lab];
    
    return supplementaryView;
}

// 单独设置某个section header 和 footer
//-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    if(section == 0)
//    {
//        CGSize size = {320, 50};
//        return size;
//    }
//    else
//    {
//        CGSize size = {320, 50};
//        return size;
//    }
//}
//
//-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
//    if(section == 0)
//    {
//        CGSize size = {320, 50};
//        return size;
//    }
//    else
//    {
//        CGSize size = {320, 50};
//        return size;
//    }
//}


@end
