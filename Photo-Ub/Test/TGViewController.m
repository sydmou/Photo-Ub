//
//  TGViewController.m
//  TGCameraViewController
//
//  Created by 张昊 on 15/3/17.
//  Copyright (c) 2015年 Tudo Gostoso Internet. All rights reserved.
//

#import "TGViewController.h"
#import "TGCameraViewController.h"
#import "TGInitialViewController.h"
//#import <AdobeCreativeSDKImage/AdobeCreativeSDKImage.h>
@interface TGViewController ()

@end

@implementation TGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, 320, 460);
    self.view.backgroundColor = [UIColor whiteColor];
    DCPathButton *dcPathButton = [[DCPathButton alloc]
                                  initDCPathButtonWithSubButtons:2
                                  totalRadius:100
                                  centerRadius:30
                                  subRadius:40
                                  centerImage:@"custom_center"
                                  centerBackground:nil
                                  subImages:^(DCPathButton *dc){
                                      [dc subButtonImage:@"custom_1" withTag:0];
                                      [dc subButtonImage:@"custom_2" withTag:1];
                                     
                                  }
                                  subImageBackground:nil
                                  inLocationX:0 locationY:0 toParentView:self.view];
    dcPathButton.delegate = self;
    // Do any additional setup after loading the view.
}
//- (void)displayEditorForImage:(UIImage *)imageToEdit
//{
//    AdobeUXImageEditorViewController *editorController = [[AdobeUXImageEditorViewController alloc] initWithImage:imageToEdit];
//    [editorController setDelegate:self];
//    [self presentViewController:editorController animated:YES completion:nil];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (IBAction)Camera:(id)sender {
//   
//   TGInitialViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"initial"];
//    
//    [self presentViewController:viewController animated:YES completion:^{
//        [viewController takePhotoTapped];
//    }];
//    // [viewController choosePhoto:nil];
//    
//    
//}
#pragma mark - DCPathButton delegate

- (void)button_0_action{
    
    TGInitialViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"initial"];
    
    [self presentViewController:viewController animated:YES completion:^{
        [viewController takePhotoTapped];
    }];

}

- (void)button_1_action{
    UIImage *image=[UIImage imageNamed:@"Demo.png"];
    
  //  [self displayEditorForImage:image];
//    NSLog(@"Button Press Tag 1!!");
//    
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        picker.delegate = self;
//        //设置选择后的图片可被编辑
//        //    picker.allowsEditing = YES;
//       // [self presentModalViewController:picker animated:YES];
//    [self presentViewController:picker animated:YES completion:nil];
    
    
    
}

- (void)button_2_action{
    NSLog(@"Button Press Tag 2!!");
    
    
}

- (void)button_3_action{
    NSLog(@"Button Press Tag 3!!");
}

- (void)button_4_action{
    NSLog(@"Button Press Tag 4!!");
}

- (void)button_5_action{
    NSLog(@"Button Press Tag 5!!");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
