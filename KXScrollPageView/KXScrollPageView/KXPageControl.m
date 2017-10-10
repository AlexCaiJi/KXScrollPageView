//
//  KXPageControl.m
//  KXScrollPageView
//
//  Created by HMG on 2017/10/9.
//  Copyright © 2017年 HMG. All rights reserved.
//

#import "KXPageControl.h"

#define KPAGECONTROL_SIZE 6

@implementation KXPageControl

/**
 *  改变pageControl中点的大小
 */
- (void)setCurrentPage:(NSInteger)page {
    [super setCurrentPage:page];
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
        CGSize size;
        size.height = KPAGECONTROL_SIZE;
        size.width = KPAGECONTROL_SIZE;
        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y, size.width,size.height)];
        if (subviewIndex == page) {
            [subview setBackgroundColor:self.currentPageIndicatorTintColor];
        } else {
            [subview setBackgroundColor:self.pageIndicatorTintColor];
        }
    }
}

@end
