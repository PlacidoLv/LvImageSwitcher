//
//  LvGroupCollectionViewCell.h
//  LvImageSwitcher
//
//  Created by lv on 2016/10/18.
//  Copyright © 2016年 lv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface LvGroupTableViewCell : UITableViewCell
-(void)reloadUI:(ALAssetsGroup *)group;
@end
