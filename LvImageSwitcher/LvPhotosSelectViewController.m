//
//  LvPhotosSelectViewController.m
//  LvImageSwitcher
//
//  Created by lv on 2016/10/12.
//  Copyright © 2016年 lv. All rights reserved.
//

#import "LvPhotosSelectViewController.h"
#import "LvPhotoCollectionCell.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "LvPhotoModel.h"
#import "LvGroupTableViewCell.h"
#import "LvEditImageView.h"
#import "MBProgressHUD.h"

#define SIZE [UIApplication sharedApplication].keyWindow.rootViewController.view.bounds.size

static NSString *itemID=@"selectPhotos";

@interface LvPhotosSelectViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,ViewEditFinishDelegate,UITableViewDelegate,UITableViewDataSource,LvPhotosSelectViewControllerDelegate>
{
    NSMutableArray *_arrPhotos;
    ALAssetsLibrary *assetsLibrary;
    UICollectionView *_collectionView;
    UITableView *_tabGroup;

    NSMutableArray *_arrGroup;
    LvEditImageView *_edit;
}

@end

@implementation LvPhotosSelectViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.intMaxCount=1;
        self.floatSectionHeight=15;
        self.title=@"选择图片";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    if (self.intMaxCount>1)
    {
        UIBarButtonItem *itemRight = [[UIBarButtonItem alloc]initWithTitle:@"完成(0)" style:UIBarButtonItemStylePlain target:self action:@selector(btnSelectFinishClick:)];
        self.navigationItem.rightBarButtonItem = itemRight;
    }
    _arrGroup = [NSMutableArray arrayWithCapacity:0];
    _arrPhotos = [[NSMutableArray alloc] init];
    if (!self.arrSelectPhotos)
    {
        _arrSelectPhotos = [[NSMutableArray alloc] init];
    }
    
    if (self.selectType == SelectTypeGroup)
    {
        [self tabGroupLoad];
    }
    else
    {
        [self loadCollectionView];
    }
    
    [self getData];
}


-(void)btnNavBackClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnSelectFinishClick:(UIButton *)sender
{
    NSMutableArray *arrSelect=[NSMutableArray arrayWithCapacity:0];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_arrSelectPhotos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LvALAsset *model=obj;
        
        LvPhotoModel *modelP=[[LvPhotoModel alloc]init];
        NSDate *date = [model.asset valueForProperty:ALAssetPropertyDate];
        modelP.intTimeTemp = (NSInteger)[date timeIntervalSince1970];
        modelP.imageURL = model.asset.defaultRepresentation.url;
        modelP.imageThumbnail=[UIImage imageWithCGImage:model.asset.thumbnail];
        modelP.imageFull=[UIImage imageWithCGImage:[[model.asset defaultRepresentation] fullScreenImage]];
        
        
        [arrSelect addObject:modelP];
        
    }];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(selectFinish:)])
    {
        [self.delegate selectFinish:arrSelect];
    }
    
    if (self.selectFatherType==SelectTypeGroup)
    {
        if (self.backVC==nil)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([obj isKindOfClass:[self.backVC class]]) {
                    [self.navigationController popToViewController:self.backVC animated:YES];
                }
            }];
        }
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem.rightBarButtonItem setTitle:[NSString stringWithFormat:@"完成(%zd)",_arrSelectPhotos.count]];
}

-(void)getData
{
    [_arrPhotos removeAllObjects];
    [_collectionView reloadData];
    [_tabGroup reloadData];
    
    if (self.assetsGroup)
    {
        dispatch_queue_t queue=dispatch_queue_create("getImg", DISPATCH_QUEUE_SERIAL);
        dispatch_sync(queue, ^{
            
            [self.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result)
                {
                    NSDate *date = [result valueForProperty:ALAssetPropertyDate];
                    LvALAsset *set=[[LvALAsset alloc]init];
                    set.asset=result;
                    set.timetemp = (NSInteger )[date timeIntervalSince1970];
                    [_arrPhotos addObject:set];
                    
                    __block BOOL isSame=NO;
                    [_arrSelectPhotos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        LvALAsset *setSlect=obj;
                        
                        if(setSlect.timetemp == set.timetemp)
                        {
                            isSame=YES;
                        }
                    }];
                    set.isHaveSelect=isSame;
                }
            }];
            
            
            [UIView animateWithDuration:0.3 animations:^{
                _collectionView.alpha=1;
            } completion:^(BOOL finished) {
                [_collectionView reloadData];
                [_tabGroup reloadData];
            }];
        });

    }
    else
    {
        dispatch_queue_t queue=dispatch_queue_create("getImg", DISPATCH_QUEUE_SERIAL);
        assetsLibrary = [[ALAssetsLibrary alloc] init];
        dispatch_group_t disGroup=dispatch_group_create();

        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];

            if (group&&group.numberOfAssets>0)
            {
                
                dispatch_group_async(disGroup, queue, ^{
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    });
                    

                    NSMutableArray *arrGroup=[NSMutableArray arrayWithCapacity:0];
                    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                        if (result)
                        {
                            NSDate *date = [result valueForProperty:ALAssetPropertyDate];
                            
                            
                            LvALAsset *set=[[LvALAsset alloc]init];
                            set.asset=result;
                            set.timetemp = (NSInteger )[date timeIntervalSince1970];
                            if (self.selectType==SelectTypeGroup)
                            {
                                [arrGroup addObject:set];
                            }
                            else
                            {
                                [_arrPhotos insertObject:set atIndex:0];
                            }
                        }
                    }];
                    
                    if (self.selectType==SelectTypeGroup)
                    {
                        if (arrGroup.count>0)
                        {
                            [_arrGroup addObject:group];
                            [_arrPhotos addObject:arrGroup];
                        }
                    }
                   
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [UIView animateWithDuration:0.3 animations:^{
                            _collectionView.alpha=1;
                        } completion:^(BOOL finished) {
                            [_collectionView reloadData];
                            [_tabGroup reloadData];
                        }];
             
                    });

                });
            }
         
        } failureBlock:^(NSError *error) {
            
            NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleDisplayName"];
            NSString *strAlert = [NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册", appName];
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:strAlert delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];

    }
    
    
}

-(void)sortbyorder
{
    NSSortDescriptor *timetempDesc = [NSSortDescriptor sortDescriptorWithKey:@"timetemp" ascending:NO];
    NSArray *descs = [NSArray arrayWithObjects:timetempDesc,nil];
    NSArray *array1 =[_arrPhotos sortedArrayUsingDescriptors:descs];
    
    [_arrPhotos removeAllObjects];
    [_arrPhotos addObjectsFromArray:array1];
}
-(void)tabGroupLoad
{
    _tabGroup=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, SIZE.width, SIZE.height-64) style:UITableViewStyleGrouped];
    _tabGroup.delegate=self;
    _tabGroup.dataSource=self;
    _tabGroup.rowHeight=80;
    [self.view addSubview:_tabGroup];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrGroup.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"selectImgID";
    LvGroupTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell=[[LvGroupTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    ALAssetsGroup *group=_arrGroup[indexPath.row];
    [cell reloadUI:group];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    ALAssetsGroup *group=_arrGroup[indexPath.row];
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
    self.navigationItem.title=@"返回";
    LvPhotosSelectViewController *photo=[LvPhotosSelectViewController new];
    photo.delegate=self;
    photo.intMaxCount=self.intMaxCount;
    photo.assetsGroup=group;
    photo.backVC=self.backVC;
    photo.title=strGroupName;
    photo.selectFatherType=self.selectType;
    photo.arrSelectPhotos=self.arrSelectPhotos;
    [self.navigationController pushViewController:photo animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.floatSectionHeight;
}

-(void)selectFinish:(NSMutableArray *)arrSelect
{
    if ([self.delegate respondsToSelector:@selector(selectFinish:)])
    {
        [self.delegate selectFinish:arrSelect];
    }
}
- (void)loadCollectionView
{
    UICollectionViewFlowLayout *customLayout = [[UICollectionViewFlowLayout alloc] init]; // 自定义的布局对象
    customLayout.minimumInteritemSpacing=1;
    customLayout.minimumLineSpacing=0.5;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SIZE.width, SIZE.height-64) collectionViewLayout:customLayout];
    [_collectionView registerClass:[LvPhotoCollectionCell class] forCellWithReuseIdentifier:itemID];
    _collectionView.backgroundColor=[UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsHorizontalScrollIndicator=NO;
    _collectionView.showsVerticalScrollIndicator=NO;
    _collectionView.alpha=0.2;
    [self.view addSubview:_collectionView];
    
}

#pragma mark - UICollectionView数据源


// 返回有多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return _arrPhotos.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}



// 返回每个cell长什么样子
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LvALAsset *model=_arrPhotos[indexPath.item];
    LvPhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemID forIndexPath:indexPath];
    cell.indexPath = indexPath;

    cell.collectionView=collectionView;
    [cell reloadUI:model];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(_collectionView.frame.size.width/4-2, _collectionView.frame.size.width/4);
    
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 0, 2);
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

        if (self.intMaxCount==1)
        {
            LvALAsset *model=_arrPhotos[indexPath.item];
            model.isHaveSelect=!model.isHaveSelect;
            [self addModel:model];
            
            [_edit removeFromSuperview];
            _edit=[[LvEditImageView alloc]initWithFrame:CGRectMake(0, 0, SIZE.width, SIZE.height)];
            _edit.image=[UIImage imageWithCGImage:[[model.asset defaultRepresentation] fullScreenImage]];
            _edit.delegate=self;
            [self.view addSubview:_edit];
            
            return;
            
//            NSMutableArray *arrSelect=[NSMutableArray arrayWithCapacity:0];
//            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            [_arrSelectPhotos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                LvALAsset *model=obj;
//                
//                LvPhotoModel *modelP=[[LvPhotoModel alloc]init];
//                NSDate *date = [model.asset valueForProperty:ALAssetPropertyDate];
//                modelP.intTimeTemp = (NSInteger)[date timeIntervalSince1970];
//                modelP.imageURL = model.asset.defaultRepresentation.url;
//                modelP.imageThumbnail=[UIImage imageWithCGImage:model.asset.thumbnail];
//                modelP.imageFull=[UIImage imageWithCGImage:[[model.asset defaultRepresentation] fullScreenImage]];
//                
//                
//                [arrSelect addObject:modelP];
//                
//            }];
//            
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            if ([self.delegate respondsToSelector:@selector(selectFinish:)])
//            {
//                [self.delegate selectFinish:arrSelect];
//            }
//            [self.navigationController popViewControllerAnimated:YES];
            
            
        }
        else
        {
            LvALAsset *model=_arrPhotos[indexPath.item];
            model.isHaveSelect=!model.isHaveSelect;
            [self addModel:model];
            [collectionView reloadData];
        }



    
}
-(void)viewEditFinish:(UIImage *)image
{
    [_edit removeFromSuperview];
    NSMutableArray *arrSelect=[NSMutableArray arrayWithCapacity:0];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_arrSelectPhotos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LvALAsset *model=obj;
        
        LvPhotoModel *modelP=[[LvPhotoModel alloc]init];
        NSDate *date = [model.asset valueForProperty:ALAssetPropertyDate];
        modelP.intTimeTemp = (NSInteger)[date timeIntervalSince1970];
        modelP.imageURL = model.asset.defaultRepresentation.url;
        modelP.imageThumbnail=image;
        modelP.imageFull=image;
        
        [arrSelect addObject:modelP];
        
    }];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([self.delegate respondsToSelector:@selector(selectFinish:)])
    {
        [self.delegate selectFinish:arrSelect];
    }
    
    if (self.selectFatherType==SelectTypeGroup)
    {
        if (self.backVC==nil)
        {
             [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([obj isKindOfClass:[self.backVC class]]) {
                    [self.navigationController popToViewController:self.backVC animated:YES];
                }
            }];
        }
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)addModel:(LvALAsset *)model
{
    if (model.isHaveSelect)
    {
        [_arrSelectPhotos addObject:model];
        
        if(_arrSelectPhotos.count>self.intMaxCount)
        {
            if(_arrSelectPhotos.count>1)
            {
                LvALAsset *set=_arrSelectPhotos[0];
                set.isHaveSelect=NO;
                [_arrSelectPhotos removeObjectAtIndex:0];
            }
        }
    }
    else
    {
        [_arrSelectPhotos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            LvALAsset *modelSelect=obj;
            if (modelSelect.timetemp == model.timetemp)
            {
                [_arrSelectPhotos removeObject:obj];
            }
        }];
    }
    
    [self.navigationItem.rightBarButtonItem setTitle:[NSString stringWithFormat:@"完成(%zd)",_arrSelectPhotos.count]];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning");
    // Dispose of any resources that can be recreated.
}

@end
