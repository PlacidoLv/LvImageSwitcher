//
//  LvEditImageView.m
//  LvImageSwitcher
//
//  Created by lv on 2016/10/12.
//  Copyright © 2016年 lv. All rights reserved.
//
#import "LvEditImageView.h"
#import "LvScrollView.h"

#define MarginLeftAndRight 20.0f //图片选择部分距左右的边距

@interface LvEditImageView ()<UIGestureRecognizerDelegate>
{
    UIImageView *_imgEdit;
    CGFloat floatW;
    CGFloat floatY;
    UIView *_viewImage;
    LvScrollView *_imageScrollView;
}
@end

@implementation LvEditImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [self loadView];
}

-(void)loadView
{
    floatW=self.frame.size.width-2*MarginLeftAndRight;
    floatY=(self.frame.size.height-floatW)/2;
    
    
    [_viewImage removeFromSuperview];
    _viewImage=[[UIView alloc]initWithFrame:CGRectMake(MarginLeftAndRight, floatY, floatW, floatW)];
    [self addSubview:_viewImage];
    
    
    _imgEdit=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, floatW, floatW)];
    _imgEdit.image=self.image;
    _imgEdit.userInteractionEnabled=YES;
    _imgEdit.contentMode=UIViewContentModeScaleAspectFill;
    [_viewImage addSubview:_imgEdit];
    _imgEdit.hidden=YES;

    _imageScrollView = [[LvScrollView alloc] initWithFrame:_imgEdit.frame];
    [_imageScrollView displayImage:self.image];
    [_viewImage addSubview:_imageScrollView];
    

    UIView *viewCoverLeft=[[UIView alloc]initWithFrame:CGRectMake(0, 0, MarginLeftAndRight, self.frame.size.height)];
    viewCoverLeft.backgroundColor=[UIColor blackColor];
    viewCoverLeft.alpha=0.5;
    viewCoverLeft.userInteractionEnabled=NO;
    [self addSubview:viewCoverLeft];

    UIView *viewCoverRight=[[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width-MarginLeftAndRight, 0, MarginLeftAndRight, self.frame.size.height)];
    viewCoverRight.backgroundColor=viewCoverLeft.backgroundColor;
    viewCoverRight.alpha=viewCoverLeft.alpha;
    viewCoverRight.userInteractionEnabled=NO;
    [self addSubview:viewCoverRight];
    
    UIView *viewCoverTop=[[UIView alloc]initWithFrame:CGRectMake(MarginLeftAndRight, 0, self.frame.size.width-2*MarginLeftAndRight , floatY)];
    viewCoverTop.backgroundColor=viewCoverLeft.backgroundColor;
    viewCoverTop.userInteractionEnabled=NO;
    viewCoverTop.alpha=viewCoverLeft.alpha;
     [self addSubview:viewCoverTop];
    
    UIView *viewCoverBotton=[[UIView alloc]initWithFrame:CGRectMake(MarginLeftAndRight, self.frame.size.height-floatY, self.frame.size.width-2*MarginLeftAndRight , floatY)];
    viewCoverBotton.backgroundColor=viewCoverLeft.backgroundColor;
    viewCoverBotton.alpha=viewCoverLeft.alpha;
    viewCoverBotton.userInteractionEnabled=NO;
    [self addSubview:viewCoverBotton];
    
    
    UIView *viewBorder=[[UIView alloc]initWithFrame:CGRectMake(MarginLeftAndRight, floatY, floatW, floatW)];
    viewBorder.backgroundColor=[UIColor clearColor];
    viewBorder.layer.borderColor=[UIColor whiteColor].CGColor;
    viewBorder.layer.borderWidth=1;
    viewBorder.userInteractionEnabled=NO;
    [self addSubview:viewBorder];
    
    UIButton *btnCut=[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-80 , self.frame.size.height-30, 80, 20)];
    [btnCut setTitle:@"裁剪" forState:UIControlStateNormal];
    btnCut.titleLabel.font=[UIFont systemFontOfSize:15];
    [btnCut addTarget:self action:@selector(btnCutClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnCut];
    
    UIButton *btnCancel=[[UIButton alloc]initWithFrame:CGRectMake(0 , self.frame.size.height-30, 80, 20)];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    btnCancel.titleLabel.font=[UIFont systemFontOfSize:15];
    [btnCancel addTarget:self action:@selector(btnCancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnCancel];
}
-(void)btnCancelClick
{
    [self removeSelf];
}

-(void)btnCutClick
{
    if ([self.delegate respondsToSelector:@selector(viewEditFinish:)])
    {
        UIImage *img=[self getImage];
        [self.delegate viewEditFinish:img];
    }
}

-(void)removeSelf
{
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha=0.2;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (UIImage *)getImage
{
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.frame.size.width , self.frame.size.height), NO, 1.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [self getImageFromImage:image];
}

// 根据给定得图片，从其指定区域截取一张新得图片
-(UIImage *)getImageFromImage:(UIImage *)bigImage
{
    //大图bigImage
    //定义myImageRect，截图的区域
    CGRect myImageRect = CGRectMake(MarginLeftAndRight+1, floatY+1, floatW-2, floatW-2);
    
    CGImageRef imageRef = bigImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size;
    size.width = floatW-2;
    size.height = floatW-2;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    return smallImage;
}






@end
