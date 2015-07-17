//
//  MJTestViewController.m
//  MJRefreshExample
//
//  Created by MJ Lee on 14-5-28.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "MJTestViewController.h"

@interface MJTestViewController ()


@property (nonatomic, strong)  CAGradientLayer *gradientLayer;

@end

@implementation MJTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"测试控制器";
    
    UIView *manView = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    manView.layer.masksToBounds = YES;
    manView.layer.cornerRadius = 50;
    manView.backgroundColor = [UIColor blueColor];
    manView.clipsToBounds = YES;
    [self.view addSubview:manView];
    
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 100, 50)];
    subView.backgroundColor = [UIColor redColor];
    [manView addSubview:subView];
    
    UILabel *textLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 200, 200, 30)];
    textLab.backgroundColor =[ UIColor clearColor];
    textLab.text = @"文字渐变效果显示";
    [textLab sizeToFit];
    [self.view addSubview:textLab];
    
    [UIView animateWithDuration:1.0f animations:^{
        CGRect rect = subView.frame;
        rect.origin.y = 50;
        subView.frame = rect;
        
    }];
    
    // 创建渐变层
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.frame = textLab.frame;
    // 设置渐变层的颜色
    _gradientLayer.colors = @[(id)[self randomColor].CGColor,(id)[self randomColor].CGColor,(id)[self randomColor].CGColor];
    // 添加渐变层到view图层上
    // mask原理：默认会显示mask层底部内容，如果渐变层放在mask上，就不会显示了
    [self.view.layer addSublayer:_gradientLayer];
    
    // mask层工作原理，按照透明度裁剪，只保留非透明部分，文字就是非透明的，因为除了文字部分，其它都会被裁剪掉，因此只会显示文字上面渐变层的内容，让渐变层去填充文字颜色
    _gradientLayer.mask = textLab.layer;
    // 注意，把lable层设为mask层，lable层就不能显示了，会直接从你层中移除，然后作为渐变层的mask层，且lable层的父层会指向渐变层
    textLab.frame = _gradientLayer.bounds;
    
    // 加入定时器
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(textColorChange)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode]; // 加入主线程
    
}

- (void) textColorChange
{
     _gradientLayer.colors = @[(id)[self randomColor].CGColor,(id)[self randomColor].CGColor,(id)[self randomColor].CGColor];
}

- (UIColor *) randomColor
{
    CGFloat r = arc4random_uniform(256)/255.0;
    CGFloat g = arc4random_uniform(256)/255.0;
    CGFloat b = arc4random_uniform(256)/255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0f];
}

@end
