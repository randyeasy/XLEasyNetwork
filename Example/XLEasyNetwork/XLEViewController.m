//
//  XLEViewController.m
//  XLEasyNetwork
//
//  Created by 晓亮 on 03/10/2016.
//  Copyright (c) 2016 晓亮. All rights reserved.
//

#import "XLEViewController.h"
#import <XLEasyNetwork/XLEasyNetwork.h>

@interface XLEViewController ()

@end

@implementation XLEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"网络测试";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doAddItemsOperation{
    [super doAddItemsOperation];
    [self.items addObject:[XLEDemoItem itemWithName:@"请求测试" desc:@"get 请求" callback:^{
        XLERequestParams *params = [[XLERequestParams alloc] initWithParams:nil method:XLE_HTTP_GET];
        [[XLENetworkManager sharedInstance] requestWithOwner:nil url:@"https://httpbin.org/get" params:params success:^(id  _Nonnull response, NSDictionary * _Nonnull responseHeaders, XLERequestParams * _Nonnull params) {
            NSLog(@"response:%@,resonseHeaders:%@",response,responseHeaders);
        } failure:^(NSError * _Nonnull error, XLERequestParams * _Nonnull params) {
            NSLog(@"error:%@",error);
        }];
    }]];
    
    [self.items addObject:[XLEDemoItem itemWithName:@"请求测试" desc:@"post 请求" callback:^{
        XLERequestParams *params = [[XLERequestParams alloc] initWithParams:@{@"id":@"871715731"}];
        [[XLENetworkManager sharedInstance] requestWithOwner:nil url:@"http://itunes.apple.com/lookup" params:params success:^(id  _Nonnull response, NSDictionary * _Nonnull responseHeaders, XLERequestParams * _Nonnull params) {
            NSLog(@"response:%@,resonseHeaders:%@",response,responseHeaders);
        } failure:^(NSError * _Nonnull error, XLERequestParams * _Nonnull params) {
            NSLog(@"error:%@",error);
        }];
    }]];
    
    [self.items addObject:[XLEDemoItem itemWithName:@"请求测试" desc:@"post 请求 owner" callback:^{
        XLERequestParams *params = [[XLERequestParams alloc] initWithParams:@{@"id":@"871715731"}];
        NSObject *object = [[NSObject alloc] init];
        [[XLENetworkManager sharedInstance] requestWithOwner:object url:@"http://itunes.apple.com/lookup" params:params success:^(id  _Nonnull response, NSDictionary * _Nonnull responseHeaders, XLERequestParams * _Nonnull params) {
            NSLog(@"response:%@,resonseHeaders:%@",response,responseHeaders);
        } failure:^(NSError * _Nonnull error, XLERequestParams * _Nonnull params) {
            NSLog(@"error:%@",error);
        }];
    }]];
    
    [self.items addObject:[XLEDemoItem itemWithName:@"请求测试" desc:@"post 请求 取消" callback:^{
        XLERequestParams *params = [[XLERequestParams alloc] initWithParams:@{@"id":@"871715731"}];
        NSInteger taskId = [[XLENetworkManager sharedInstance] requestWithOwner:nil url:@"http://itunes.apple.com/lookup" params:params success:^(id  _Nonnull response, NSDictionary * _Nonnull responseHeaders, XLERequestParams * _Nonnull params) {
            NSLog(@"response:%@,resonseHeaders:%@",response,responseHeaders);
        } failure:^(NSError * _Nonnull error, XLERequestParams * _Nonnull params) {
            NSLog(@"error:%@",error);
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[XLENetworkManager sharedInstance] cancelRequestWithTaskId:taskId owner:nil];
        });
    }]];
    
    [self.items addObject:[XLEDemoItem itemWithName:@"下载测试" desc:@"大图下载" callback:^{
        XLERequestParams *params = [[XLERequestParams alloc] initWithParams:@{@"id":@"871715731"}];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        NSString *downPath = [docDir stringByAppendingPathComponent:@"downloadtest"];
        [[XLENetworkManager sharedInstance] downloadWithOwner:nil url:@"http://scitechdaily.com/images/New-Image-of-the-Galaxy-Messier-94-also-Known-as-NGC-4736.jpg" params:params downloadPath:downPath progress:^(NSProgress * _Nonnull progress) {
            NSLog(@"progress:%@",progress);
        } success:^(id  _Nonnull response, NSDictionary * _Nonnull responseHeaders, XLERequestParams * _Nonnull params) {
            NSLog(@"response:%@,resonseHeaders:%@",response,responseHeaders);
        } failure:^(NSError * _Nonnull error, XLERequestParams * _Nonnull params) {
            NSLog(@"error:%@",error);
        }];
    }]];
    
    [self.items addObject:[XLEDemoItem itemWithName:@"上传测试" desc:@"大图上传" callback:^{
        XLERequestParams *params = [[XLERequestParams alloc] initWithParams:@{@"id":@"871715731"}];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"upload" ofType:@"jpg"];
        XLEFileParams *file = [[XLEFileParams alloc] initWithName:@"file" fileName:@"upload.jpg" filePath:filePath miniType:XLE_FILEPARAMS_PIC];
        
        [[XLENetworkManager sharedInstance] uploadWithOwner:nil url:@"https://httpbin.org/post" params:params formFile:file progress:^(NSProgress * _Nonnull progress) {
            NSLog(@"progress:%@",progress);
        } success:^(id  _Nonnull response, NSDictionary * _Nonnull responseHeaders, XLERequestParams * _Nonnull params) {
            NSLog(@"response:%@,resonseHeaders:%@",response,responseHeaders);
        } failure:^(NSError * _Nonnull error, XLERequestParams * _Nonnull params) {
            NSLog(@"error:%@",error);
        }];
    }]];
    
}

@end
