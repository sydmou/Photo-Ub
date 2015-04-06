//
//  ViewController.m
//  Test
//
//  Created by 张昊 on 15/3/31.
//  Copyright (c) 2015年 HaoYa. All rights reserved.
//

#import "ViewController.h"
#import <AdobeCreativeSDKImage/AdobeCreativeSDKImage.h>
//#import "RKCTestView.h"
#import <AdobeCreativeSDKFoundation/AdobeCreativeSDKFoundation.h>
@interface ViewController ()<AdobeUXImageEditorViewControllerDelegate >

@end

@implementation ViewController


- (void)viewDidAppear:(BOOL)animated {
    

    BOOL loggedIn = [AdobeUXAuthManager sharedManager].authenticated;
    if(loggedIn) {
        NSLog(@"We have a cached logged in");
        
        [_loginButton setTitle:@"Logout" forState:UIControlStateNormal];
        AdobeAuthUserProfile *up = [AdobeUXAuthManager sharedManager].userProfile;
        NSLog(@"User Profile: %@", up);
        
        UIImage*image=[UIImage imageNamed:@"Demo.png"];
        [self displayEditorForImage:image];
        
        
    }


}
- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    CGRect frame = [UIScreen mainScreen].bounds;
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_loginButton setTitle:@"Login" forState:UIControlStateNormal];
    _loginButton.frame = CGRectMake(0, 0, frame.size.width, 100);
    [_loginButton addTarget:self action:@selector(doLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    
    NSString* const CreativeSDKClientId = @"8b186c996d3d409993801aeaaf9657fc";
    NSString* const CreativeSDKClientSecret = @"c2e96ff1-d184-439c-b605-5a3c3e413afa";
    
    [[AdobeUXAuthManager sharedManager] setAuthenticationParametersWithClientID:CreativeSDKClientId withClientSecret:CreativeSDKClientSecret];
    
    //The authManager caches our login, so check on startup
    
    //    UIImage*image=[UIImage imageNamed:@"Demo.png"];
//   [self displayEditorForImage:image];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  //  [self loadView];
    // Dispose of any resources that can be recreated.
}

//- (void)loadView
//{
//    
//    CGRect frame = [UIScreen mainScreen].bounds;
//    
//    RKCTestView *tv = [[RKCTestView alloc] initWithFrame:frame];
//    
//    self.view = tv;
//    
//    NSString* const CreativeSDKClientId = @"8b186c996d3d409993801aeaaf9657fc";
//    NSString* const CreativeSDKClientSecret = @"c2e96ff1-d184-439c-b605-5a3c3e413afa";
//    
//    [[AdobeUXAuthManager sharedManager] setAuthenticationParametersWithClientID:CreativeSDKClientId withClientSecret:CreativeSDKClientSecret];
//    
//    //The authManager caches our login, so check on startup
//    BOOL loggedIn = [AdobeUXAuthManager sharedManager].authenticated;
//    if(loggedIn) {
//        NSLog(@"We have a cached logged in");
//        
//        [((RKCTestView *)self.view).loginButton setTitle:@"Logout" forState:UIControlStateNormal];
//        AdobeAuthUserProfile *up = [AdobeUXAuthManager sharedManager].userProfile;
//        NSLog(@"User Profile: %@", up);
//        
//        UIImage*image=[UIImage imageNamed:@"Demo.png"];
//        [self displayEditorForImage:image];
//    
//    }
//
//           }



-(void)doLogin {
   
    //Are we logged in?
    BOOL loggedIn = [AdobeUXAuthManager sharedManager].authenticated;
    
    if(!loggedIn) {
        
        [[AdobeUXAuthManager sharedManager] login:self
                                        onSuccess: ^(AdobeAuthUserProfile * userProfile) {
                                            NSLog(@"success for login");
                                            
                                            UIImage*image=[UIImage imageNamed:@"Demo.png"];
                                            [self displayEditorForImage:image];                                            [_loginButton setTitle:@"Logout" forState:UIControlStateNormal];
                                             
                                        }
                                          onError: ^(NSError * error) {
                                              NSLog(@"Error in Login: %@", error);
                                          }];
    } else {
        
        [[AdobeUXAuthManager sharedManager] logout:^void {
            NSLog(@"success for logout");
            [_loginButton setTitle:@"Login" forState:UIControlStateNormal];
        } onError:^(NSError *error) {
            NSLog(@"Error on Logout: %@", error);
        }];
    }
}
- (void)displayEditorForImage:(UIImage *)imageToEdit
{
    AdobeUXImageEditorViewController *editorController = [[AdobeUXImageEditorViewController alloc] initWithImage:imageToEdit];
    [editorController setDelegate:self];
    [self presentViewController:editorController animated:YES completion:nil];
}
- (void)photoEditor:(AdobeUXImageEditorViewController *)editor finishedWithImage:(UIImage *)image
{
    // Handle the result image here
}

- (void)photoEditorCanceled:(AdobeUXImageEditorViewController *)editor
{ NSLog(@"success forcancell");
    // Handle cancellation here
}
@end
