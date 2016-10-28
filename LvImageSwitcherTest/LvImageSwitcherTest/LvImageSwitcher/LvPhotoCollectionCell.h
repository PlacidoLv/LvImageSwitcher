//
//  LvPhotoModel.h
//  LvImageSwitcher
//
//  Created by lv on 2016/10/12.
//  Copyright © 2016年 lv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LvPhotoModel.h"
#import "LvALAsset.h"

@interface LvPhotoCollectionCell : UICollectionViewCell
@property(nonatomic,retain)UIImageView *imageView;
@property(nonatomic,retain)UIImageView *imgSelect;
@property(nonatomic,retain)NSIndexPath *indexPath;
@property(nonatomic,retain)UICollectionView *collectionView;
@property(nonatomic,retain)LvPhotoModel *model;

-(void)reloadUI:(LvALAsset *)model;
@end
