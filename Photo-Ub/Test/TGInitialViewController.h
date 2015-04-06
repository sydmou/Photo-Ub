//
//  TGInitialViewController.h
//  TGCameraViewController
//
//  Created by Bruno Furtado on 15/09/14.
//  Copyright (c) 2014 Tudo Gostoso Internet. All rights reserved.
//
#import <EventKit/EventKit.h>
#import "shotScreenModel.h"
#import "AppDelegate.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
@class MBProgressHUD;
@import UIKit;

@interface TGInitialViewController : UIViewController


@property (strong, nonatomic) IBOutlet UIImageView *photoView;
@property(nonatomic,strong)UIImage *chooseImage; //CCLocation

-(void)cameraDidTakePhoto:(UIImage *)image;
- (void)takePhotoTapped;
@end