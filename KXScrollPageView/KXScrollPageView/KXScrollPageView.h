//
//  KXScrollPageView.h
//  KXScrollPageView
//
//  Created by HMG on 2017/10/9.
//  Copyright © 2017年 HMG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KXPageControl.h"

#define HORMARGIN 10
#define VERMARGIN 5
#define DES_LABEL_H 20
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define KPAGECONTROL_SIZE 6

/** 图片切换的方式 */
typedef NS_ENUM(NSInteger, HMBasserAnimationType) {
    HMBasserAnimationTypeCube = 0,          //3D翻滚
    HMBasserAnimationTypeReveal = 1,        //从右往左推进
    HMBasserAnimationTypeFade = 2,          //从左往右推进
    HMBasserAnimationTypePageCurl = 3,      //渐变消失
    HMBasserAnimationTypePageUnCurl = 4,    //从右往左翻页
    HMBasserAnimationTypeSuckEffect = 5,    //从左往右翻页
    HMBasserAnimationTypeRippleEffect = 6,  //左上角申缩消失
    HMBasserAnimationTypeOglFlip = 7        //水滴渐变
};


/** pageControl的显示位置 */
typedef NS_ENUM(NSInteger, HMPageControlPosition) {
    HMPageControlPositionDefault,           //默认值 == PositionBottomCenter
    HMPageControlPositionHide,           //隐藏
    HMPageControlPositionBottomLeft,     //左下
    HMPageControlPositionBottomCenter,   //中下
    HMPageControlPositionBottomRight     //右下
};


/** 点击图片的协议 */
@protocol KXBannerViewDelegate <NSObject>

-(void)KXBannerViewClickImageDidWithIndex:(NSInteger)index;

@end


@interface KXScrollPageView : UIView

/** 切换方式 */
@property (nonatomic, assign) HMBasserAnimationType animationType;
/** 显示位置 */
@property (nonatomic, assign) HMPageControlPosition pageControlPosition;

@property (assign, nonatomic) id <KXBannerViewDelegate> delegate;

/**
 ImageDatas
 可以为URL
 可以为UIImage
 可以为String
 */
- (instancetype)initWithFrame:(CGRect)frame withImageDatas:(NSArray *)datas;

/**
 *  设置分页控件指示器的图片
 *  两个图片必须同时设置，否则设置无效
 *  不设置则为系统默认
 *
 *  @param image    其他页码的图片
 *  @param currentImage 当前页码的图片
 */
- (void)setPageImage:(UIImage *)image andCurrentPageImage:(UIImage *)currentImage;


/**
 *  设置分页控件指示器的颜色
 *  不设置则为系统默认
 *
 *  @param color        其他页码的颜色
 *  @param currentColor 当前页码的颜色
 */
- (void)setPageColor:(UIColor *)color andCurrentPageColor:(UIColor *)currentColor;

/** 开启定时器 */
-(void)startTimer;

/** 停止定时器 */
-(void)stopTimer;

@end
