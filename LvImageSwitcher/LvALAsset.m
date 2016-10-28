//
//  LvALAsset.m
//  LvImageSwitcher
//
//  Created by lv on 2016/10/12.
//  Copyright © 2016年 lv. All rights reserved.
//

#import "LvALAsset.h"

@implementation LvALAsset


-(void)setIsHaveSelect:(BOOL)isHaveSelect
{
    if (_isHaveSelect!=isHaveSelect) {
        _isHaveSelect=isHaveSelect;
    }
}

-(BOOL)isIsHaveSelect
{
    return _isHaveSelect;
}

@end
