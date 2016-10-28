//
//  LvEditImageView.h
//  LvImageSwitcher
//
//  Created by lv on 2016/10/12.
//  Copyright © 2016年 lv. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewEditFinishDelegate <NSObject>

@optional
-(void)viewEditFinish:(UIImage *)image;

@end

@interface LvEditImageView : UIView



@property(nonatomic,strong)UIImage *image;

@property(nonatomic,assign)id<ViewEditFinishDelegate>delegate;
@end
