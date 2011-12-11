//
//  MainViewController.m
//  tottepost mainview controller
//
//  Created by Ken Watanabe on 11/12/10.
//  Copyright (c) 2011 cocotomo. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"
//-----------------------------------------------------------------------------
//Private Implementations
//-----------------------------------------------------------------------------
@interface MainViewController(PrivateImplementation)
@end

@implementation MainViewController(PrivateImplementation)
@end

//-----------------------------------------------------------------------------
//Public Implementations
//-----------------------------------------------------------------------------
@implementation MainViewController
- (id)initWithFrame:(CGRect)frame
{
    self = [super init];
    if(self){
        self.view = [[MainView alloc] initWithFrame:frame];

        
        bool isCameraSupported = [UIImagePickerController isSourceTypeAvailable:
                                  UIImagePickerControllerSourceTypeCamera];        
        if (isCameraSupported == false) {
            // TODO: カメラがサポートしてないときの処理
            NSLog(@"カメラがサポートされていません。");
            return self;
        }
         
        // iPad か iPhone/iPod touch かの判定
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            // iPad 時の処理
        }else{
            // iPhone/iPod touch の処理
        }
    }

    NSLog(@"width = %f",frame.size.width);
    NSLog(@"height = %f",frame.size.height);

    return self;
}

// モーダルビューとしてカメラ画面を呼び出す
- (void) createCameraController
{
    imagePicker_ = [[UIImagePickerController alloc] init];
    imagePicker_.delegate = self;
    imagePicker_.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker_.cameraOverlayView = self.view;

    //ツールバー追加
    CGRect toolbarRect = CGRectMake(0, self.view.frame.size.height - 55, self.view.frame.size.width, 55);
    UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:toolbarRect];
    toolbar.barStyle = UIBarStyleBlack;
    [imagePicker_.view addSubview:toolbar];
    
    // カメラボタン
    cameraButton_ =
    [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                 target:self
                                                 action:@selector(clickPhoto:)];
    cameraButton_.style = UIBarButtonItemStyleBordered;
    
    //カメラボタンを真ん中に寄せるためのスペース
    UIBarButtonItem* fixedSpace = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                   target:nil
                                   action:nil];
    fixedSpace.width = self.view.frame.size.width/2 - 30;
    
    [toolbar setItems:[NSArray arrayWithObjects:fixedSpace, cameraButton_, nil]];
    
    //イメージピッカーを前面に表示
    [self presentModalViewController:imagePicker_ animated:YES];    
}

//撮影ボタンを押したときに呼ばれるメソッド
- (void)clickPhoto:(UIBarButtonItem*)sender
{
    NSLog(@"DEBUG");
    //[imagePicker takePicture];    
}

//画像が選択された時に呼ばれるデリゲートメソッド
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingImage:(UIImage*)image editingInfo:(NSDictionary*)editingInfo{
    
    
}

//画像の保存完了時に呼ばれるメソッド
-(void)targetImage:(UIImage*)image
didFinishSavingWithError:(NSError*)error contextInfo:(void*)context{
    
    if(error){
        // 保存失敗時
    }else{
        // 保存成功時
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    //回転検知関係の初期化
    device_ = [UIDevice currentDevice];
    [device_ beginGeneratingDeviceOrientationNotifications];
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(deviceRotate) name:UIDeviceOrientationDidChangeNotification object:nil];
}

//デバイスが動いたときに呼ばれる
-(void) deviceRotate
{
    NSLog(@"DEBUG");
    if(device_.orientation == UIDeviceOrientationPortrait ||
       device_.orientation == UIDeviceOrientationPortraitUpsideDown) //縦向きの場合
    {
        row = 0;
        //NSLog(@"ImageTab deviceRotate portrait");
    }
    else if(device_.orientation == UIDeviceOrientationLandscapeLeft ||
            device_.orientation == UIDeviceOrientationLandscapeRight) //横向きの場合
    {
        row = 1;
        //NSLog(@"ImageTab deviceRotate landscape");
    }
    
    if(row == prevRow)
    {
        return;
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}
@end