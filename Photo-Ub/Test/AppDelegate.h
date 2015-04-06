//
//  AppDelegate.h
//  Test
//
//  Created by 张昊 on 15/3/31.
//  Copyright (c) 2015年 HaoYa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperationManager.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;
@end

