//
//  TGInitialViewController.m
//  TGCameraViewController
//
//  Created by Bruno Furtado on 15/09/14.
//  Copyright (c) 2014 Tudo Gostoso Internet. All rights reserved.
//
#import "HYWeatherModel.h"
#import "TGInitialViewController.h"
#import "TGViewController.h"
#import "TGCamera.h"
#import "TGCameraViewController.h"
#import "CCLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <EventKit/EventKit.h>
#import <AdobeCreativeSDKImage/AdobeCreativeSDKImage.h>
//#import "RKCTestView.h"
#import <AdobeCreativeSDKFoundation/AdobeCreativeSDKFoundation.h>
#import "HSDatePickerViewController.h"
#import "UIButton+Bootstrap.h"
#import"MBProgressHUD.h"

#import "shotScreenViewController.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "shotScreenModel.h"
#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
#define kKYCustomPhotoAlbumName_ @"Photo-Ub Photo Origin"
#define kKYCustomPhotoModifiedAlbumName_ @"Photo-Ub Photo Edited"
@interface TGInitialViewController () <TGCameraDelegate,CLLocationManagerDelegate,HSDatePickerViewControllerDelegate,UIAlertViewDelegate,passImage,AdobeUXImageEditorViewControllerDelegate >{
    CLLocationManager *locationmanager;
    
    NSMutableArray * _data;
    NSMutableArray*_imageData;
    NSString *_cityName;
    NSString *_eventTitle;
    NSString *_addressLocation;
    NSString *_coordinate;
    
    //--------------weather---
    UIButton *cityBtn ;
    UIButton *dataLabel ;
    NSArray *arryList;
    NSDictionary* weathers;
    
    AppDelegate* _appDelegate;
     ALAsset *url;
    NSString*text;
    //-----------------------
      ALAssetsLibrary     * assetsLibrary_;
}
@property (nonatomic, strong) ALAssetsLibrary     * assetsLibrary;
@property (strong,nonatomic)UIImage *shotedScreenImg;
@property (strong,nonatomic)UIImageView *shotedSceenImgView;


@property(nonatomic,retain)MBProgressHUD *HUD;
//@property (weak, nonatomic)NSString *cityName;


//Today
//@property (weak, nonatomic) IBOutlet UILabel *TodayDate;
//@property (weak, nonatomic) IBOutlet UIImageView *TodayImage;
//@property (weak, nonatomic) IBOutlet UILabel *TodayMin;
//@property (weak, nonatomic) IBOutlet UILabel *TodayMax;
//----------------------date clendrier---------------
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) NSDate *selectedDate;

//---------------------------------------------------------


@property(nonatomic,strong)UILabel *textLabel; //CCLocation

@property(nonatomic,strong)UIButton *button; //CCLocation
@property(nonatomic,strong)UITextField *txtQueryKey;

- (IBAction)takePhotoTapped;

- (void)clearTapped;

@end



@implementation TGInitialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    _imageData=[[NSMutableArray alloc]init];
    _data=[[NSMutableArray alloc]init];
   
    
    [TGCamera setOption:kTGCameraOptionSaveImageToAlbum value:[NSNumber numberWithBool:YES]];
    
    _photoView.clipsToBounds = YES;
    _photoView.image=_chooseImage;
    //self.photoView.image=[UIImage imageNamed:@"Demo.png"];
    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                 target:self
                                                                                 action:@selector(clearTapped)];
    
    self.navigationItem.rightBarButtonItem = clearButton;
    
    if (IS_IOS8) {
        [UIApplication sharedApplication].idleTimerDisabled = TRUE;
        locationmanager = [[CLLocationManager alloc] init];
        [locationmanager requestAlwaysAuthorization];        //NSLocationAlwaysUsageDescription
        [locationmanager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
        locationmanager.delegate = self;
    }
    
    
    [self createButton];
    
    [self getLat];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark - TGCameraDelegate required

- (void)cameraDidCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    TGViewController * viewController=[[TGViewController alloc]init];
    
    [self presentViewController:viewController animated:YES completion:nil];
    
}

- (void)cameraDidTakePhoto:(UIImage *)image
{
    _photoView.image = image;
        [_data addObject:image];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
      //  [self Album:nil];
}

- (void)cameraDidSelectAlbumPhoto:(UIImage *)image
{
    _photoView.image = image;
     [_data addObject:image];
    [self dismissViewControllerAnimated:YES completion:nil];
  //  [self Album:nil];
}

#pragma mark - Custom Getter

- (ALAssetsLibrary *)assetsLibrary
{
    if (assetsLibrary_) {
        return assetsLibrary_;
    }
    assetsLibrary_ = [[ALAssetsLibrary alloc] init];
    return assetsLibrary_;
}

#pragma mark -
#pragma mark - TGCameraDelegate optional

- (void)cameraWillTakePhoto
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)cameraDidSavePhotoAtPath:(NSURL *)assetURL
{
    NSLog(@"%s album path: %@", __PRETTY_FUNCTION__, assetURL);
    
    
    
  
    [self.assetsLibrary  assetForURL:assetURL resultBlock:^(ALAsset *asset) {
       _photoView.image= [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
       //--------------------------------------------------------------
       

        
        AdobeUXImageEditorViewController *editorController = [[AdobeUXImageEditorViewController alloc] initWithImage:[UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage]];
        [editorController setDelegate:self];
        [self presentViewController:editorController animated:YES completion:nil];

        
//        
//        viewController.imageChoose=[UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
//        //   viewController.imageUrl=url;
//        NSLog(@"%s album path-----: %@", __PRETTY_FUNCTION__, url);
//        //    [self presentViewController:viewController animated:YES completion:nil];
//        [self presentViewController:viewController animated:YES completion:^{
//            [viewController choosePhoto:nil];
//        }];
  //---------------------------------------------------------------------------------------
        
        
    } failureBlock:^(NSError *error) {
         NSLog(@"%s: Cannot get image: %@", __PRETTY_FUNCTION__, [error description]);
    }];

        /* Modify image's size before save it to photos album
         *
         *  CGSize sizeToSave = CGSizeMake(imageToSave.size.width, imageToSave.size.height);
         *  UIGraphicsBeginImageContextWithOptions(sizeToSave, NO, 0.f);
         *  [imageToSave drawInRect:CGRectMake(0.f, 0.f, sizeToSave.width, sizeToSave.height)];
         *  finalImageToSave = UIGraphicsGetImageFromCurrentImageContext();
         *  UIGraphicsEndImageContext();
         */
     
        
        // The completion block to be executed after image taking action process done
        void (^completion)(NSURL *, NSError *) = ^(NSURL *assetURL, NSError *error) {
            if (error) {
                NSLog(@"%s: Write the image data to the assets library (camera roll): %@",
                      __PRETTY_FUNCTION__, [error localizedDescription]);
            }
            
            NSLog(@"%s: Save image with asset url %@ (absolute path: %@), type: %@", __PRETTY_FUNCTION__,
                  assetURL, [assetURL absoluteString], [assetURL class]);
            // Add new item to |photos_| & table view appropriately
          
            dispatch_async(dispatch_get_main_queue(), ^{
              
            });
        };
        
        void (^failure)(NSError *) = ^(NSError *error) {
            if (error) NSLog(@"%s: Failed to add the asset to the custom photo album: %@",
                             __PRETTY_FUNCTION__, [error localizedDescription]);
        };
        
        // Save image to custom photo album
        // The lifetimes of objects you get back from a library instance are tied to
        //   the lifetime of the library instance.
        [self.assetsLibrary saveImage: _photoView.image
                              toAlbum:kKYCustomPhotoAlbumName_
                           completion:completion
                              failure:failure];
  

//    ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
//    [lib assetForURL:assetURL resultBlock:^(ALAsset *asset)
//    {
//        url=asset;
//        
//        
//    }
//        failureBlock:^(NSError *error)
//    {}
//     ];
    
    
     //[self edit:nil];

}

- (void)cameraDidSavePhotoWithError:(NSError *)error
{
    NSLog(@"%s error: %@", __PRETTY_FUNCTION__, error);
}

#pragma mark -
#pragma mark - Actions

- (void)takePhotoTapped
{    
    TGCameraNavigationController *navigationController = [TGCameraNavigationController newWithCameraDelegate:self];
    [self presentViewController:navigationController animated:YES completion:nil];
}
- (IBAction)Album:(id)sender {

    
    
    [self edit:nil];
    
}



-(UIImage*)convertViewToImage:(UIView*)v{
    CGSize s = v.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (void)edit:(id)sender {
   

  
    AdobeUXImageEditorViewController *editorController = [[AdobeUXImageEditorViewController alloc] initWithImage:_photoView.image];
    [editorController setDelegate:self];
    [self presentViewController:editorController animated:YES completion:nil];
    
}

#pragma mark -
#pragma mark - Private methods

- (void)clearTapped
{
    _photoView.image = nil;
}




-(void)createButton{
//    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, IS_IOS7 ? 130 : 110, 320, 60)];
//    _textLabel.backgroundColor = [UIColor clearColor];
//    _textLabel.font = [UIFont systemFontOfSize:15];
//    _textLabel.textColor = [UIColor redColor];
//    _textLabel.textAlignment = NSTextAlignmentCenter;
//    _textLabel.numberOfLines = 0;
//    _textLabel.text = @"测试位置";
//    [self.view addSubview:_textLabel];
  
       _button= [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _button.frame = CGRectMake(0, IS_IOS7 ? 150 : 110, 155, 30);
        _button.backgroundColor = [UIColor clearColor];
        //_button.titleLabel.font = [UIFont systemFontOfSize:15];
       [_button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//       _button.titleLabel.textAlignment = NSTextAlignmentCenter;
//       _button.titleLabel.numberOfLines = 0;
//       _button.titleLabel.text = @"测试位置";
       [_button setTitle:@"Location" forState:UIControlStateNormal];
       [_button  addTarget:self action:@selector(geocodeQuery:) forControlEvents:UIControlEventTouchDownRepeat];
    [_button defaultStyle];
    // [_button addAwesomeIcon:FAIconCheck beforeTitle:NO];
       [_button addTarget:self action:@selector(getCity) forControlEvents:UIControlEventTouchUpInside];
    [_button addTarget:self action:@selector(dragMoving:withEvent: )forControlEvents: UIControlEventTouchDragInside];
    [_button addTarget:self action:@selector(dragEnded:withEvent: )forControlEvents: UIControlEventTouchUpInside |
     
     UIControlEventTouchUpOutside];
   // [_button setBackgroundImage:[UIImage imageNamed:@"map.png"]forState:UIControlStateNormal];
   
    
    UIImageView *Maplabel =[[UIImageView alloc]initWithFrame:CGRectMake(0, IS_IOS7 ? 0 : 0, 30, 30)];
    Maplabel.image=[UIImage imageNamed:@"map.png"];
    [_button addSubview:Maplabel];
 [self.view addSubview:_button];
    
    UIButton *latBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    latBtn.frame = CGRectMake(100,IS_IOS7 ? 200 : 180, 120, 30);
    [latBtn setTitle:@"获取坐标" forState:UIControlStateNormal];
    [latBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [latBtn addTarget:self action:@selector(getLat) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:latBtn];
    
    latBtn.hidden=YES;

    
    
        cityBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cityBtn.frame = CGRectMake(0,IS_IOS7 ?310 : 240, 35, 35);
        [cityBtn setTitle:@"" forState:UIControlStateNormal];
    
        [cityBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        [cityBtn addTarget:self action:@selector(getCity) forControlEvents:UIControlEventTouchUpInside];
    [cityBtn addTarget:self action:@selector(dragMoving:withEvent: )forControlEvents: UIControlEventTouchDragInside];
    [cityBtn addTarget:self action:@selector(dragEnded:withEvent: )forControlEvents: UIControlEventTouchUpInside |
     UIControlEventTouchUpOutside];
    cityBtn.hidden=YES;
        //[cityBtn defaultStyle];
        [self.view addSubview:cityBtn];
    
    
    UIButton *allBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    allBtn.frame = CGRectMake(100,IS_IOS7 ? 300 : 280, 120, 30);
    [allBtn setTitle:@"获取所有信息" forState:UIControlStateNormal];
    [allBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [allBtn addTarget:self action:@selector(getAllInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:allBtn];
    allBtn.hidden=YES;
    
    
    dataLabel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    dataLabel.frame = CGRectMake(0,IS_IOS7 ? 200 : 170, 185, 35);
    [dataLabel setTitle:@"Date" forState:UIControlStateNormal];
    [dataLabel defaultStyle];
    [dataLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //        [cityBtn addTarget:self action:@selector(getCity) forControlEvents:UIControlEventTouchUpInside];
    [dataLabel addTarget:self action:@selector(dragMoving:withEvent: )forControlEvents: UIControlEventTouchDragInside];
    [dataLabel addTarget:self action:@selector(dragEnded:withEvent: )forControlEvents: UIControlEventTouchUpInside |
     UIControlEventTouchUpOutside];
     dataLabel.hidden=YES;
    //[cityBtn defaultStyle];
    [self.view addSubview:dataLabel];
    
    
    
}
- (void) dragMoving: (UIControl *) c withEvent:ev
{
    c.center = [[[ev allTouches] anyObject] locationInView:self.view];
}

- (void) dragEnded: (UIControl *) c withEvent:ev
{
    c.center = [[[ev allTouches] anyObject] locationInView:self.view];
    
   
}

-(void)getLat
{
    __block __weak TGInitialViewController *wself = self;
  _coordinate=[[NSString alloc]init];
    
    if (IS_IOS8) {
        
        [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            
            NSLog(@"%f %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude);
//            [wself setLabelText:[NSString stringWithFormat:@"%f %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude]];
            _coordinate=[NSString stringWithFormat:@"%f %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude];
        }];
    }
    
}

-(void)getCity
{
    __block __weak TGInitialViewController *wself = self;
    //self.cityName=[[NSString alloc]init];
    if (IS_IOS8) {
        
        [[CCLocationManager shareLocation]getCity:^(NSString *cityString) {
            NSLog(@"%@",cityString);
            [wself setLabelText:cityString];
            _cityName=cityString;
        }];
        
    }
     [self SendRequestToGetJsonData:nil];
    cityBtn.hidden=NO;
}


-(void)getAllInfo
{
    __block NSString *string;
    __block __weak TGInitialViewController *wself = self;
    _addressLocation=[[NSString alloc]init];
    
    if (IS_IOS8) {
        
        [[CCLocationManager shareLocation]getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            string = [NSString stringWithFormat:@"%f %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude];
        } withAddress:^(NSString *addressString) {
            NSLog(@"%@",addressString);
            string = [NSString stringWithFormat:@"%@",addressString];
            [wself setLabelText:string];
            _addressLocation=addressString;
        }];
    }
    
}

-(void)setLabelText:(NSString *)text
{
    NSLog(@"text %@",text);
  [_button setTitle:text forState:UIControlStateNormal];
}

- (void)geocodeQuery:(id)sender {
   // _txtQueryKey.text=_button.currentTitle;
    
    
    if (_button.currentTitle== nil || [_button.currentTitle length] == 0) {
        return;
    }
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:_coordinate completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"查询记录数：%i",[placemarks count]);
        if ([placemarks count] > 0) {
            CLPlacemark* placemark = placemarks[0];
            
            CLLocationCoordinate2D coordinate = placemark.location.coordinate;
            NSDictionary* address = placemark.addressDictionary;
            MKPlacemark *place = [[MKPlacemark alloc]
                                  initWithCoordinate:coordinate addressDictionary:address];
            
            MKMapItem *mapItem = [[MKMapItem alloc]initWithPlacemark:place];
            [mapItem openInMapsWithLaunchOptions:nil];
            
            /*
             //地图上设置行车路线
             NSDictionary* options =[[NSDictionary alloc]initWithObjectsAndKeys:
             MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsDirectionsModeKey, nil];
             
             MKMapItem *mapItem = [[MKMapItem alloc]initWithPlacemark:place];
             [mapItem openInMapsWithLaunchOptions:options];
             */
            
            //关闭键盘
       
        }
    }];
    
    
    //关闭键盘
   // [_txtQueryKey resignFirstResponder];
    
}
//---------------------------------- date--------------------------------------
- (IBAction)showDatePicker:(id)sender {
    HSDatePickerViewController *hsdpvc = [HSDatePickerViewController new];
    hsdpvc.delegate = self;
    if (self.selectedDate) {
        hsdpvc.date = self.selectedDate;
    }
    [self presentViewController:hsdpvc animated:YES completion:nil];
    
    
}
- (void)addTheDateToTheClendrier:(id)sender {
    
    
    
    
    EKEventStore* eventStore = [[EKEventStore alloc] init];
    NSDate* ssdate = [NSDate dateWithTimeIntervalSinceNow:-3600*24*90];//事件段，开始时间
    NSDate* ssend = [NSDate dateWithTimeIntervalSinceNow:3600*24*90];//结束时间，取中间
    NSPredicate* predicate = [eventStore predicateForEventsWithStartDate:ssdate
                                                                 endDate:ssend
                                                               calendars:nil];
    NSArray* events = [eventStore eventsMatchingPredicate:predicate];//数组里面就是时间段中的EKEvent事件数组
    
    //往日历写事件
    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
    NSDate *startDate = [[NSDate alloc] init];
    NSDate *endDate  = [[NSDate alloc] init];
    event.title     = _eventTitle;
    event.startDate = self.selectedDate ;
    event.endDate   = self.selectedDate ;
    
    event.location =_cityName;
    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
    __block NSError *err;
    //ios 6以后和之前方法不一样
    if([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        [eventStore requestAccessToEntityType:EKEntityTypeEvent
                                   completion:^(BOOL granted, NSError *error) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           if (granted) {
                                               [eventStore saveEvent:event span:EKSpanFutureEvents commit:YES error:&err];
                                           } else {
                                               NSLog(@"不允许访问日历");
                                           }
                                       });
                                   }];
    } else {
        [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
    }
}
- (void) alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1) {
                // 获取UIAlertView中第1个输入框
                UITextField* nameField = [alertView textFieldAtIndex:0];
                // 获取UIAlertView中第2个输入框
               // UITextField* passField = [alertView textFieldAtIndex:1];
                // 显示用户输入的用户名和密码
                NSString* msg = [NSString stringWithFormat:
                                 @"%@"
                                 , nameField.text];
        
        _eventTitle=msg;
//                UIAlertView *alert = [[UIAlertView alloc]
//                                      initWithTitle:@"提示"
//                                      message:nameField
//                                      delegate:nil
//                                      cancelButtonTitle:@"确定"
//                                      otherButtonTitles: nil];
//                // 显示UIAlertView
//                [alert show];
        
        NSLog(@"-----%@",msg);
        
        [self addTheDateToTheClendrier:nil];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录" message:@"Auto-Sync To Clendrier "
                                                   delegate:nil
                                          cancelButtonTitle:@"ok"
                                          otherButtonTitles:nil , nil];
    // 设置该警告框显示输入用户名和密码的输入框
    alert.alertViewStyle = UIAlertActionStyleDefault;
    // 设置第2个文本框关联的键盘只是数字键盘
    //[alert textFieldAtIndex:1].keyboardType = UIKeyboardTypeNumberPad;
    // 显示UIAlertView
    [alert show];
        
            }

}

#pragma mark - HSDatePickerViewControllerDelegate
- (void)hsDatePickerPickedDate:(NSDate *)date {
    NSLog(@"Date picked %@", date);
    NSDateFormatter *dateFormater = [NSDateFormatter new];
    dateFormater.dateFormat = @"yyyy.MM.dd HH:mm:ss";
    //self.dateLabel.text = [dateFormater stringFromDate:date];
    [dataLabel setTitle:[dateFormater stringFromDate:date] forState:UIControlStateNormal];
    self.selectedDate = date;
    
    
    
}

//optional
- (void)hsDatePickerDidDismissWithQuitMethod:(HSDatePickerQuitMethod)method {
    NSLog(@"Picker did dismiss with %lu", method);
    
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录" message:@"Please input event title"
                                                                        delegate:self
                                                                        cancelButtonTitle:@"cancel"
                                                                        otherButtonTitles:@"ok" , nil];
    // 设置该警告框显示输入用户名和密码的输入框
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    // 设置第2个文本框关联的键盘只是数字键盘
    //[alert textFieldAtIndex:1].keyboardType = UIKeyboardTypeNumberPad;
    // 显示UIAlertView
    [alert show];
    
    dataLabel.hidden=NO;
}

//optional
- (void)hsDatePickerWillDismissWithQuitMethod:(HSDatePickerQuitMethod)method {
    NSLog(@"Picker will dismiss with %lu", method);
}

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
//------------------weather----------------------------------------
- (void)SendRequestToGetJsonData:(UIButton*)button {
    
   // [self ShowLoading];
    [self SendRequest];
    //[self HideLoading];
}


-(void)SendRequest{
    if ([_cityName isEqualToString:@"Paris"]) {
        _cityName=@"Pari";
    };
    //_cityName=@"rennes";
    NSString *url = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?q=%@&mode=json&units=metric&cnt=7",_cityName];
    
    
 
//    string=url;
 //  NSString *url = @"http://api.openweathermap.org/data/2.5/forecast/daily?q=Paris&mode=json&units=metric&cnt=7";
    
    _appDelegate = [UIApplication sharedApplication].delegate;
    
    // use AFHTTPRequestOperationManager send GET request
    [_appDelegate.manager GET:url parameters:nil
     // get server respond success block
                      success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         // server respond JSON data  transfer  to Objective-C object，assign to authors proprety
         weathers = responseObject;
         
         NSLog(@"json----:%@",weathers);
         
         [self assignValue:weathers];
         
     }
     // get server respond failblock
                      failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"show error information: %@", error);
     }];
}

#pragma mark--assign Value to storyboard label

-(void)assignValue:(NSDictionary*)Data {
    
    //    self.TodayMin.text=[NSString stringWithFormat:@"Min：%@°C",
    //                        [authors[@"list"][0][@"temp"][@"min"] stringValue]];
    
    HYWeatherModel  * weatherModel=[[HYWeatherModel alloc]initWithDataDic:Data];
//    self.TodayDate.text=weatherModel.TodayDate;
//    self.TodayMin.text=weatherModel.TodayMin;
//    self.TodayMax.text=weatherModel.TodayMax;
//    self.TodayImage.image=[UIImage imageNamed:weatherModel.TodayImage];
   // cityBtn.imageView.image=[UIImage imageNamed:weatherModel.TodayImage];
    [cityBtn setBackgroundImage:[UIImage imageNamed:weatherModel.TodayImage] forState:UIControlStateNormal];
 cityBtn.adjustsImageWhenHighlighted=YES;
    //[cityBtn setImage:[UIImage imageNamed:weatherModel.TodayImage]forState:UIControlStateNormal];
    
}

#pragma mark--loader pour faire patienter l'utilisateur

-(void)ShowLoading{
    
    self.HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.dimBackground=YES;
    self.HUD.labelText=@"Veuillez patienter";
    
}

-(void)HideLoading{
    
    [self.HUD hide:YES afterDelay:1];
    
}
#pragma mark--Snapshot

- (IBAction)Snapshot:(id)sender {
    
    
    [self shotPartedScreen];
    
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
    CGRect rect = CGRectMake(0, 64, 320, 418);
    shotScreenModel *shotModel = [[shotScreenModel alloc]init];
    [shotModel imageFromView:self.view atFrame:_photoView.frame andDelegate:self];
}
#pragma passImgDelegate
-(void)passImage:(UIImage *)image
{
    
    _shotedScreenImg = image;
    [_data addObject:image];
    

    
    [self.assetsLibrary saveImage: image
                          toAlbum:kKYCustomPhotoModifiedAlbumName_
                       completion:nil
                          failure:nil];
    TGViewController *TGview=[[TGViewController alloc]init];
    
    [self presentViewController:TGview animated:YES completion:nil];
}


- (void)photoEditor:(AdobeUXImageEditorViewController *)editor finishedWithImage:(UIImage *)image
{
    // Handle the result image here
    
    self.photoView.image=image;


    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (void)photoEditorCanceled:(AdobeUXImageEditorViewController *)editor
{ NSLog(@"success forcancell");
    // Handle cancellation here
    

    [self dismissViewControllerAnimated:YES completion:nil];
   
    
}


@end