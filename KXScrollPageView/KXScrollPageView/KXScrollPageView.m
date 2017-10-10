//
//  KXScrollPageView.m
//  KXScrollPageView
//
//  Created by HMG on 2017/10/9.
//  Copyright © 2017年 HMG. All rights reserved.
//

#import "KXScrollPageView.h"
#import "UIImageView+WebCache.h"
@interface KXScrollPageView ()

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) KXPageControl *pageControl;

@property (nonatomic, assign) CGSize pageImageSize;

@property (nonatomic, strong) NSArray *imageDatas;

@end

@implementation KXScrollPageView

#pragma mark - LazyLoad methods
- (instancetype)initWithFrame:(CGRect)frame withImageDatas:(NSArray *)datas
{
    if (self=[super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        _imageDatas = datas;
        [self show3DBannerViewWithImageDatas:datas];
    }
    return self;
}


#pragma mark - View methods
- (KXPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl=[[KXPageControl alloc] init];
        _pageControl.currentPageIndicatorTintColor=[UIColor grayColor];
        _pageControl.pageIndicatorTintColor=[UIColor whiteColor];
        [self addSubview:_pageControl];
    }
    return _pageControl;
}


/**
 设置pageControl的指示器图片
 */
- (void)setPageImage:(UIImage *)image andCurrentPageImage:(UIImage *)currentImage {
    if (!image || !currentImage) return;
    _pageImageSize = image.size;
    [_pageControl setValue:currentImage forKey:@"_currentPageImage"];
    [_pageControl setValue:image forKey:@"_pageImage"];
}

/**
 设置pageControl的指示器颜色
 */
- (void)setPageColor:(UIColor *)color andCurrentPageColor:(UIColor *)currentColor {
    _pageControl.pageIndicatorTintColor = color;
    _pageControl.currentPageIndicatorTintColor = currentColor;
}

/**
 设置pageControl的指示器位置
 */
- (void)setPageControlPosition:(HMPageControlPosition)pageControlPosition
{
    _pageControlPosition = pageControlPosition;
    _pageControl.hidden = (_pageControlPosition == HMPageControlPositionHide) || (_imageDatas.count == 1);
    if (_pageControl.hidden) return;
    
    CGSize size;
    if (!_pageImageSize.width) {//没有设置图片，系统原有样式
        size = [_pageControl sizeForNumberOfPages:_pageControl.numberOfPages + 1];
        size.height = KPAGECONTROL_SIZE + 2;
    } else {//设置图片了
        size = CGSizeMake(_pageImageSize.width * (_pageControl.numberOfPages * 2 - 1), _pageImageSize.height);
    }
    _pageControl.frame = CGRectMake(0, 0, size.width, size.height);
    
    if (_pageControlPosition == HMPageControlPositionDefault || _pageControlPosition == HMPageControlPositionBottomCenter)
        _pageControl.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height-10);
    else if (_pageControlPosition == HMPageControlPositionBottomLeft)
        _pageControl.frame = CGRectMake(HORMARGIN, self.frame.size.height-20, size.width, size.height);
    else
        _pageControl.frame = CGRectMake(self.frame.size.width - HORMARGIN - size.width, self.frame.size.height-20, size.width, size.height);
}



#pragma mark - Actions methods
/**
 实现定时器的方法
 */
-(void)changeImageAction:(NSTimer *)sender
{
    [self transitionAnimation:YES andAnimationMode:self.animationType];
}

- (void)show3DBannerViewWithImageDatas:(NSArray *)datas {
    

    if (datas == nil) {
        return;
    }
    
    [self startTimer];
    _imageView=[[UIImageView alloc]initWithFrame:self.bounds];
    _imageView.backgroundColor = [UIColor purpleColor];
    
    /** 设置起始图片 */
    if ([datas[0] isKindOfClass:[NSString class]]) {
        if ([datas[0] hasPrefix:@"http"]) {
            [_imageView sd_setImageWithURL:[NSURL URLWithString:datas[0]] placeholderImage:[UIImage imageNamed:@""]];
        } else {
            _imageView.image = [UIImage imageNamed:datas[0]];
        }
    } else if ([datas[0] isKindOfClass:[UIImage class]]) {
        _imageView.image = (UIImage *)datas[0];
    }
    
    _imageView.userInteractionEnabled = YES;
    self.userInteractionEnabled = YES;
    [self addSubview:_imageView];
    
    /**
     创建点击手势
     */
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doDoubleTap:)];
    
    [_imageView addGestureRecognizer:doubleTap];
    
    /**
     创建滑动的手势（向左滑动）
     */
    UISwipeGestureRecognizer *leftSwipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwipe:)];
    
    /**
     设置滑动的方向 （左
     */
    leftSwipeGesture.direction=UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:leftSwipeGesture];
    
    /**
     创建滑动的手势（向右滑动）
     */
    UISwipeGestureRecognizer *rightSwipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipe:)];
    
    /**
     设置滑动的方向 （右）
     */
    rightSwipeGesture.direction=UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:rightSwipeGesture];
    
    self.pageControl.numberOfPages=datas.count;
    self.pageControlPosition = self.pageControlPosition;
}


/**
 向左滑动浏览下一张图片
 */
-(void)leftSwipe:(UISwipeGestureRecognizer *)gesture
{
    
    [self transitionAnimation:YES andAnimationMode:0];
    
}

/**
 向右滑动浏览上一张图片
 */
-(void)rightSwipe:(UISwipeGestureRecognizer *)gesture
{
    [self transitionAnimation:NO andAnimationMode:0];
    
}

/**
 转场动画
 mode为动画样式
 */
-(void)transitionAnimation:(BOOL)isNext andAnimationMode:(int)mode
{
    //动画模式
    NSArray *animationModeDatas = @[@"cube", @"moveIn", @"reveal", @"fade",@"pageCurl", @"pageUnCurl", @"suckEffect", @"rippleEffect", @"oglFlip"];
    /**
     创建转场动画对象
     */
    CATransition *transition=[[CATransition alloc]init];
    transition.type=animationModeDatas[mode];
    
    /**
     设置子类型 （动画的方向）
     */
    if (isNext) {
        transition.subtype=kCATransitionFromRight;  //右
    }else{
        transition.subtype=kCATransitionFromLeft;   //左
    }
    
    /**
     设置动画时间
     */
    transition.duration = 0.5f;
    
    /**
     设置转场后的新视图添加转场动画
     */
    _imageView.image = [self getImage:isNext];
    
    /**
     加载动画
     */
    [_imageView.layer addAnimation:transition forKey:@"HMTransitionAnimation"];
    
}

/**
 取得当前图片要播的图片
 */
-(UIImage *)getImage:(BOOL)isNext
{
    if (isNext) {
        _currentIndex=(_currentIndex+1)%_imageDatas.count; //0，1，2，3，4，5，0，1
        
        _pageControl.currentPage=_currentIndex;
    }else{
        _currentIndex=(_currentIndex-1+_imageDatas.count)%(int)_imageDatas.count;//0,5,4,3,2,1,5
        
        _pageControl.currentPage=_currentIndex;
    }
    
    NSString *imageNameStr = _imageDatas[_currentIndex];
    UIImage *image = nil;
    if ([imageNameStr isKindOfClass:[NSString class]]) {
        if ([imageNameStr hasPrefix:@"http"]) {
            /** 先从缓存中取 */
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            NSString* key = [manager cacheKeyForURL:[NSURL URLWithString:imageNameStr]];
            SDImageCache* cache = [SDImageCache sharedImageCache];
            image = [cache imageFromDiskCacheForKey:key];
            
        } else {
            image = [UIImage imageNamed:imageNameStr];
        }
    } else if ([imageNameStr isKindOfClass:[UIImage class]]) {
        
        image = (UIImage *)imageNameStr;
    }
    
    return image;
}

- (void)doDoubleTap:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(KXBannerViewClickImageDidWithIndex:)]) {
        [self.delegate KXBannerViewClickImageDidWithIndex:_currentIndex];
    }
}

- (void)stopTimer {
    //关闭定时器
    [_timer invalidate];
    _timer = nil;
}

- (void)startTimer {
    //如果只有一张图片，则直接返回，不开启定时器
    if (_imageDatas.count <= 1) return;
    //如果定时器已开启，先停止再重新开启
    if (_timer) [self stopTimer];
    _timer = [NSTimer timerWithTimeInterval:4 target:self selector:@selector(changeImageAction:)  userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [_timer setFireDate:[NSDate distantPast]];
}

@end
