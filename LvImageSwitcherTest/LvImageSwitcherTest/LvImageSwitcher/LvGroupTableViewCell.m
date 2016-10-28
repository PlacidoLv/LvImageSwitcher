//
//  LvGroupCollectionViewCell.m
//  LvImageSwitcher
//
//  Created by lv on 2016/10/18.
//  Copyright © 2016年 lv. All rights reserved.
//

#import "LvGroupTableViewCell.h"

#define HEIGHT 10.0f

@implementation LvGroupTableViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

-(void)reloadUI:(ALAssetsGroup *)group
{
    
    NSString *strGroupName = [group valueForProperty:ALAssetsGroupPropertyName];
    if ([strGroupName isEqualToString:@"Camera Roll"])
    {
        strGroupName = @"相机";
    }
    else
    {
        if ([strGroupName isEqualToString:@"My Photo Stream"])
        {
            strGroupName = @"我的照片";
        }
    }
    
    self.imageView.image=[UIImage imageWithCGImage:group.posterImage];
    self.textLabel.text=strGroupName;
    self.detailTextLabel.text=[NSString stringWithFormat:@"%zd",[group numberOfAssets]];
    self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat cellHeight = self.frame.size.height - 2 *HEIGHT;
    self.imageView.frame = CGRectMake(HEIGHT, HEIGHT, cellHeight, cellHeight);
}
@end
