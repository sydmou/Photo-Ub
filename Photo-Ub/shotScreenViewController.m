//
//  shotScreenViewController.m
//  截屏
//
//  Created by PYC/Mr.ma on 14-7-7.
//  Copyright (c) 2014年 PYC\MFW. All rights reserved.
//

#import "shotScreenViewController.h"

#import "shotScreenModel.h"

@interface shotScreenViewController ()

@property (strong,nonatomic)UIImage *shotedScreenImg;
@property (strong,nonatomic)UIImageView *shotedSceenImgView;
@end

@implementation shotScreenViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self shotScreen];
   
}
#pragma button action
//截取整个屏幕
-(void)shotScreen
{
    
    shotScreenModel *shotModel = [[shotScreenModel alloc]init];
    [shotModel imageFromView:self.view andDelegate:self];
}
//截取屏幕某一位置的图片
-(void)shotPartedScreen
{
    CGRect rect = CGRectMake(100, 100, 100, 100);
    shotScreenModel *shotModel = [[shotScreenModel alloc]init];
    [shotModel imageFromView:self.view atFrame:rect andDelegate:self];
}
#pragma passImgDelegate
-(void)passImage:(UIImage *)image
{
    
    _shotedScreenImg = image;
    _shotedSceenImgView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 40,200, 300)];
    [_shotedSceenImgView setImage:_shotedScreenImg];
    [self.view addSubview:_shotedSceenImgView];
}
#pragma shotScreenModel

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


@end
