//
//  LvScrollView.m
//  LvImageSwitcher
//
//  Created by lv on 2016/10/12.
//  Copyright © 2016年 lv. All rights reserved.
//
#import "LvScrollView.h"

@interface LvScrollView ()<UIScrollViewDelegate>
{
    CGSize _imageSize;
}
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation LvScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = NO;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.alwaysBounceHorizontal = YES;
        self.alwaysBounceVertical = YES;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
        self.minimumZoomScale = 1.0f;
        self.maximumZoomScale = 2.0f;
    }
    return self;
}

- (void)displayImage:(UIImage *)image
{
    [self.imageView removeFromSuperview];
    self.imageView = nil;
    
    self.imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView.clipsToBounds = NO;
    self.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [self addSubview:self.imageView];
    
    CGRect frame = self.imageView.frame;
    if (image.size.height > image.size.width)
    {
        frame.size.width = self.bounds.size.width;
        frame.size.height = self.bounds.size.width  *(image.size.height/image.size.width) ;
    } else
    {
        frame.size.height = self.bounds.size.height;
        frame.size.width = (self.bounds.size.height / image.size.height) * image.size.width;
    }
    self.imageView.frame = frame;
    
    //设置偏移量
    CGSize imageSize = self.imageView.bounds.size;
    if (imageSize.width > imageSize.height)
    {
        self.contentOffset = CGPointMake((self.imageView.frame.size.width-self.frame.size.width)/2, 0);
    }
    else if (imageSize.width < imageSize.height)
    {
        self.contentOffset = CGPointMake(0, (self.imageView.frame.size.height-self.frame.size.height)/2);
    }
    
    
    self.contentSize = imageSize;
}


#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end

