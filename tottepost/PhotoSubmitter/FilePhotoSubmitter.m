//
//  FilePhotoSubmitter.m
//  tottepost
//
//  Created by ISHITOYA Kentaro on 11/12/24.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "FilePhotoSubmitter.h"
#import "PhotoSubmitterAPIKey.h"
#import "UIImage+Digest.h"

#define PS_FILE_ENABLED @"PSFileEnabled"

//-----------------------------------------------------------------------------
//Private Implementations
//-----------------------------------------------------------------------------
@interface FilePhotoSubmitter(PrivateImplementation)
- (void) setupInitialState;
- (void) clearCredentials;
@end

@implementation FilePhotoSubmitter(PrivateImplementation)
#pragma mark -
#pragma mark private implementations
/*!
 * initializer
 */
-(void)setupInitialState{
}

/*!
 * clear defaults, on file we will not store access token.
 */
- (void)clearCredentials{
    [self removeSettingForKey:PS_FILE_ENABLED];
}
@end

//-----------------------------------------------------------------------------
//Public Implementations
//-----------------------------------------------------------------------------
@implementation FilePhotoSubmitter
@synthesize authDelegate;
@synthesize albumDelegate;
#pragma mark -
#pragma mark public implementations
/*!
 * initialize
 */
- (id)init{
    self = [super init];
    if (self) {
        [self setupInitialState];
    }
    return self;
}

/*!
 * submit photo with comment
 */
- (void)submitPhoto:(UIImage *)photo comment:(NSString *)comment andDelegate:(id<PhotoSubmitterOperationDelegate>)delegate{
    //dispatch_async(dispatch_get_main_queue(), ^{
        NSString *hash = photo.MD5DigestString;
        UIImageWriteToSavedPhotosAlbum(photo, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void*)hash);	
        [self photoSubmitter:self willStartUpload:hash];
        [self photoSubmitter:self didProgressChanged:hash progress:0.25];
        [self setOperationDelegate:delegate forRequest:hash];
    //});
}

/*!
 * login to file
 */
-(void)login{
    [self setSetting:@"enabled" forKey:PS_FILE_ENABLED];
}

/*!
 * logoff from file
 */
- (void)logout{  
    [self disable];
}

/*!
 * disable
 */
- (void)disable{
    [self clearCredentials];
    [self.authDelegate photoSubmitter:self didLogout:self.type];
}

/*!
 * check is logined
 */
- (BOOL)isLogined{
    return self.isEnabled;
}

/*!
 * check is enabled
 */
- (BOOL) isEnabled{
    return [FilePhotoSubmitter isEnabled];
}

/*!
 * return type
 */
- (PhotoSubmitterType) type{
    return PhotoSubmitterTypeFile;
}

/*!
 * check url is processoble, we will not use this method in file
 */
- (BOOL)isProcessableURL:(NSURL *)url{
    return NO;
}

/*!
 * on open url finished, we will not use this method in file
 */
- (BOOL)didOpenURL:(NSURL *)url{
    return NO;
}

/*!
 * name
 */
- (NSString *)name{
    return @"File";
}

/*!
 * icon image
 */
- (UIImage *)icon{
    return [UIImage imageNamed:@"file_32.png"];
}

/*!
 * small icon image
 */
- (UIImage *)smallIcon{
    return [UIImage imageNamed:@"file_16.png"];
}

/*!
 * get username
 */
- (NSString *)username{
    return nil;
}

/*!
 * albumlist
 */
- (NSArray *)albumList{
    return nil;
}

/*!
 * update album list
 */
- (void)updateAlbumListWithDelegate:(id<PhotoSubmitterAlbumDelegate>)delegate{
    //do nothing
}

/*!
 * selected album
 */
- (PhotoSubmitterAlbumEntity *)targetAlbum{
    return nil;
}

/*!
 * save selected album
 */
- (void)setTargetAlbum:(PhotoSubmitterAlbumEntity *)targetAlbum{
    //do nothing
}

/*!
 * invoke method as concurrent?
 */
- (BOOL)isConcurrent{
    return NO;
}

/*!
 * isEnabled
 */
+ (BOOL)isEnabled{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:PS_FILE_ENABLED]) {
        return YES;
    }
    return NO;
}

/*!
 * saving handler
 */
- (void) image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSString *hash = (__bridge NSString *)contextInfo;
    [self photoSubmitter:self didProgressChanged:hash progress:0.75];
    if(error == nil){
        [self photoSubmitter:self didSubmitted:hash suceeded:YES message:@"Photo upload succeeded"];
    }else{
        [self photoSubmitter:self didSubmitted:hash suceeded:NO message:[error localizedDescription]];
    }
    id<PhotoSubmitterOperationDelegate> operationDelegate = [self operationDelegateForRequest:hash];
    [operationDelegate photoSubmitterDidOperationFinished];
    [self clearRequest:hash];
}
@end