//
//  LvPhotoModel.m
//  LvImageSwitcher
//
//  Created by lv on 2016/10/12.
//  Copyright © 2016年 lv. All rights reserved.
//

#import "LvPhotoCollectionCell.h"
#import "LvImageSwitcherHeader.h"


@interface LvPhotoCollectionCell()
{
    
 

}
@end

@implementation LvPhotoCollectionCell


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUI];
        
    }
    return self;
}

-(void)reloadUI:(LvALAsset *)asset
{
    _imageView.image=[UIImage imageWithCGImage:asset.asset.aspectRatioThumbnail];
    _imgSelect.image= [UIImage imageNamed:asset.isHaveSelect?@"勾-选中":@""];
}


-(void)initUI
{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.5,0.5,self.frame.size.width-1,self.frame.size.width-1)];
    _imageView.backgroundColor = [UIColor grayColor];
//    _imageView.userInteractionEnabled = YES;
    _imageView.contentMode=UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds=YES;
    
    [self addSubview:_imageView];
    
    _imgSelect = [[UIImageView alloc] initWithFrame:CGRectMake(_imageView.frame.size.width-27,5, 22, 22)];
    [_imageView addSubview:_imgSelect];
}




@end
