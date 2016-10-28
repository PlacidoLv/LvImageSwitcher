//
//  ViewController.m
//  LvImageSwitcher
//
//  Created by lv on 2016/10/12.
//  Copyright © 2016年 lv. All rights reserved.
//

#import "ViewController.h"
#import "LvPhotosSelectViewController.h"

@interface ViewController ()<LvPhotosSelectViewControllerDelegate>
{
    UIImageView *_imgSelect;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *btnAdd=[[UIButton alloc]initWithFrame:CGRectMake(50, 100, 100, 30)];
    [btnAdd setTitle:@"添加" forState:UIControlStateNormal];
    [btnAdd setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btnAdd addTarget:self action:@selector(btnAddClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnAdd];
    
    _imgSelect=[[UIImageView alloc]initWithFrame:CGRectMake(50, 130, 200, 200)];
    [self.view addSubview:_imgSelect];
    
    

}
-(void)viewWillAppear:(BOOL)animated
{
      self.navigationItem.title=@"";
}

-(void)selectFinish:(NSMutableArray *)arrSelect
{
    if (arrSelect.count==0) {
        return;
    }
    LvPhotoModel *model=arrSelect[0];
    _imgSelect.image=model.imageFull;
}

-(void)btnAddClick
{
    self.navigationItem.title=@"返回";

    self.navigationController.navigationBar.barTintColor = [UIColor greenColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
  
    
    LvPhotosSelectViewController *select=[LvPhotosSelectViewController new];
    select.delegate=self;
    select.intMaxCount=3;
    select.selectType=SelectTypeGroup;
    select.floatSectionHeight=15;
    select.backVC=self;
    [self.navigationController pushViewController:select animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
