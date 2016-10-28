//
//  LvPhotoModel.h
//  LvImageSwitcher
//
//  Created by lv on 2016/10/12.
//  Copyright © 2016年 lv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LvPhotoModel : NSObject
@property(nonatomic,assign)NSInteger intTimeTemp;
@property(nonatomic,retain)NSURL *imageURL;
@property(nonatomic,retain)NSString *strPath;
@property(nonatomic,retain)NSString *strQiniuURL;
@property(nonatomic,retain)UIImage *imageFull;
@property(nonatomic,retain)UIImage *imageThumbnail;
@property(nonatomic,assign)BOOL isSelect;
@end
