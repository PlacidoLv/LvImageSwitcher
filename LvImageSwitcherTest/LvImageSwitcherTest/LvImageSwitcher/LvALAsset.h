//
//  LvALAsset.h
//  LvImageSwitcher
//
//  Created by lv on 2016/10/12.
//  Copyright © 2016年 lv. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>

@interface LvALAsset : NSObject
@property(nonatomic,retain)ALAsset *asset;
@property(nonatomic,retain)NSString *assetURL;
@property(nonatomic,assign)BOOL isHaveSelect;
@property(nonatomic,assign)NSInteger timetemp;
@end
