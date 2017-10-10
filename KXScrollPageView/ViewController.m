//
//  ViewController.m
//  KXScrollPageView
//
//  Created by HMG on 2017/10/9.
//  Copyright © 2017年 HMG. All rights reserved.
//

#import "ViewController.h"
#import "KXScrollPageView.h"
@interface ViewController ()<KXBannerViewDelegate>

@property (nonatomic, strong) KXScrollPageView *scrollPageView;

@end

@implementation ViewController

- (KXScrollPageView *)scrollPageView
{
    if (!_scrollPageView) {
        
        NSArray *datas = @[@"11", @"22", @"33"];
        _scrollPageView = [[KXScrollPageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 160) withImageDatas:datas];
        _scrollPageView.backgroundColor = [UIColor whiteColor];
        _scrollPageView.delegate = self;
        _scrollPageView.animationType = HMBasserAnimationTypeOglFlip;
        
    }
    return _scrollPageView;
}


- (void)KXBannerViewClickImageDidWithIndex:(NSInteger)index
{
    NSLog(@"%ld", index);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self.view addSubview:self.scrollPageView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
