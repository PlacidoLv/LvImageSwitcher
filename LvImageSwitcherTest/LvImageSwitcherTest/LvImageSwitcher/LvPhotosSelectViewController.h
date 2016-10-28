//
//  LvPhotosSelectViewController.h
//  LvImageSwitcher
//
//  Created by lv on 2016/10/12.
//  Copyright © 2016年 lv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "LvPhotoModel.h"

typedef enum : NSUInteger {
    SelectTypeTable = 0,//列表
    SelectTypeGroup = 1,//分组
    
} SelectType;

@protocol LvPhotosSelectViewControllerDelegate <NSObject>

@optional
-(void)selectFinish:(NSMutableArray *)arrSelect;

@end

@interface LvPhotosSelectViewController : UIViewController
@property(nonatomic,retain)UIView *navView;//导航栏
@property(nonatomic,assign)NSInteger intMaxCount;//图片最大选择数量
@property(nonatomic,assign)CGFloat floatSectionHeight;//图片最大选择数量
@property(nonatomic,assign)SelectType selectType;//图片排序方式
@property(nonatomic,assign)SelectType selectFatherType;
@property(nonatomic,retain)ALAssetsGroup *assetsGroup;//子group
@property(nonatomic,retain) NSMutableArray *arrSelectPhotos;
@property(nonatomic,retain) UIViewController *backVC;
@property(nonatomic,assign)id<LvPhotosSelectViewControllerDelegate>delegate;
@end

