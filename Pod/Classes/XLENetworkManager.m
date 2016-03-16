//
//  XLENetworkManager.m
//  Pods
//
//  Created by Randy on 16/3/10.
//
//

#import "XLENetworkManager.h"

/**
 *  viewModel
 */
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "XLENetworkMonitor.h"
#import "NSObject+XLEDestoryMonitor.h"

/**
 *  model
 */
#import "XLERequestRetryModel.h"

NSString *const XLE_NETWORK_VERSION = @"1.0.0";

@interface XLENetworkManager ()
@property (strong, nonatomic) AFHTTPSessionManager *manager;
@property (assign, nonatomic) NSInteger httpTaskId;//保证taskId从1开始
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSURLSessionTask *> *taskDic;
@end

@implementation XLENetworkManager

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        responseSerializer.removesKeysWithNullValues = YES;
        NSMutableSet *contentTypes = [NSMutableSet setWithSet:responseSerializer.acceptableContentTypes];
        [contentTypes addObject:@"text/plain"];
        responseSerializer.acceptableContentTypes = contentTypes;
        
        _defaultTimeoutInterval = 60.0f;
        [[AFHTTPRequestSerializer serializer] setTimeoutInterval:_defaultTimeoutInterval];
        _httpTaskId = 0; //默认为0，使用的时候请加1再使用
    }
    return self;
}

- (NSInteger)requestRetryWithOwner:(NSObject *)owner
                               url:(NSString *)url
                          params:(XLERequestParams *)params
                      retryCount:(NSInteger)count
                         success:(XLERequestSuccess)success
                         failure:(XLERequestFailure)failure;
{
    NSInteger taskId = ++self.httpTaskId;
    
    [self requestWithOwner:owner
                    taskId:taskId
                        url:url
                 retryCount:count
                     params:params
                    success:success
                    failure:failure];
    return taskId;
}

- (NSInteger)requestWithOwner:(NSObject *)owner
                          url:(NSString *)url
                     params:(XLERequestParams *)params
                    success:(XLERequestSuccess)success
                    failure:(XLERequestFailure)failure;
{
    NSInteger taskId = ++self.httpTaskId;
    
    [self requestWithOwner:owner
                    taskId:taskId
                        url:url
                 retryCount:0
                     params:params
                    success:success
                    failure:failure];
    return taskId;
}

- (NSInteger)downloadWithOwner:(NSObject *)owner
                           url:(NSString *)url
                      params:(XLERequestParams *)params
                downloadPath:(NSString *)path
                     success:(XLERequestSuccess)success
                     failure:(XLERequestFailure)failure;
{
    return [self downloadWithOwner:owner
                               url:url
                            params:params
                      downloadPath:path
                          progress:nil
                           success:success
                           failure:failure];
}

- (NSInteger)uploadWithOwner:(NSObject *)owner
                         url:(NSString *)url
                    params:(XLERequestParams *)params
                  formFile:(XLEFileParams *)formFile
                   success:(XLERequestSuccess)success
                   failure:(XLERequestFailure)failure;
{
    return [self uploadWithOwner:owner
                             url:url
                          params:params
                        formFile:formFile
                        progress:nil
                         success:success
                         failure:failure];
}

- (NSInteger)downloadWithOwner:(NSObject *)owner
                           url:(NSString *)url
                      params:(XLERequestParams *)params
                downloadPath:(NSString *)path
                    progress:(XLERequestProgress)progress
                     success:(XLERequestSuccess)success
                     failure:(XLERequestFailure)failure;
{
    NSInteger taskId = ++self.httpTaskId;
    
    [owner XLE_addDestoryMonitorCallback:^(id owner, NSInteger taskId) {
        [self cancelRequestWithTaskId:taskId];
    } taskId:taskId];
    
    __weak XLENetworkManager *weakSelf = self;
    __weak NSObject *weakOwner = owner;

    [self configRequestSerializerWithParams:params];
    NSError *error;
    NSURLRequest *request = [self.manager.requestSerializer requestWithMethod:params.httpMethodStr URLString:url parameters:params.params error:&error];
    if (error) {
        if (failure) {
            failure(error, params);
        }
        return 0;
    }
    NSURLSessionTask * task = [self.manager downloadTaskWithRequest:request progress:progress destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (![weakSelf analysisRequestCanceledWithTaskId:taskId]) {
            if (error) {
                if (failure) {
                    failure(error, params);
                }
            }
            else
            {
                if (success) {
                    NSDictionary *responseHeaders = nil;
                    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                        responseHeaders = ((NSHTTPURLResponse *)response).allHeaderFields;
                    }
                    success(filePath, responseHeaders, params);
                }
            }
        }
        [weakSelf finishRequestWithTaskId:taskId owner:weakOwner];
    }];
    [task resume];
    [self.taskDic setObject:task forKey:[NSString stringWithFormat:@"%ld",taskId]];
    return taskId;
}

- (NSInteger)uploadWithOwner:(NSObject *)owner
                         url:(NSString *)url
                    params:(XLERequestParams *)params
                  formFile:(XLEFileParams *)formFile
                  progress:(XLERequestProgress)progress
                   success:(XLERequestSuccess)success
                   failure:(XLERequestFailure)failure;
{
    NSInteger taskId = ++self.httpTaskId;
    
    [owner XLE_addDestoryMonitorCallback:^(id owner, NSInteger taskId) {
        [self cancelRequestWithTaskId:taskId];
    } taskId:taskId];
    
    [self configRequestSerializerWithParams:params];
    
    __weak XLENetworkManager *weakSelf = self;
    __weak NSObject *weakOwner = owner;

    NSError *error;
    NSURLRequest *request = [self.manager.requestSerializer multipartFormRequestWithMethod:params.httpMethodStr URLString:url parameters:params.params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSError *formError;
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:formFile.filePath] name:formFile.name fileName:formFile.fileName mimeType:formFile.miniType error:&formError];
        if (formError) {
            if (failure) {
                failure(formError, params);
            }
        }
    } error:&error];
    
    if (error) {
        if (failure) {
            failure(error, params);
        }
        return 0;
    }
    NSURLSessionTask * task = [self.manager uploadTaskWithRequest:request fromFile:[NSURL fileURLWithPath:formFile.filePath] progress:progress completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (![weakSelf analysisRequestCanceledWithTaskId:taskId]) {
            if (error) {
                if (failure) {
                    failure(error, params);
                }
            }
            else
            {
                if (success) {
                    NSDictionary *responseHeaders = nil;
                    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                        responseHeaders = ((NSHTTPURLResponse *)response).allHeaderFields;
                    }
                    success(responseObject, responseHeaders, params);
                }
            }
        }
        [weakSelf finishRequestWithTaskId:taskId owner:weakOwner];
    }];
    if (task) {
        [self.taskDic setObject:task forKey:[NSString stringWithFormat:@"%ld",taskId]];
        [task resume];
    }
    return taskId;
}

- (void)cancelRequestWithTaskId:(NSInteger)taskId owner:(NSObject *)owner
{
    [owner XLE_removeDestoryMonitorWithTaskId:taskId];
    [self cancelRequestWithTaskId:taskId];
}

#pragma mark - internal
- (void)finishRequestWithTaskId:(NSInteger)taskId owner:(NSObject *)owner
{
    [owner XLE_removeDestoryMonitorWithTaskId:taskId];
    NSString *key = [NSString stringWithFormat:@"%ld",taskId];
    [self.taskDic removeObjectForKey:key];
}

- (void)cancelRequestWithTaskId:(NSInteger)taskId
{
    NSString *key = [NSString stringWithFormat:@"%ld",taskId];
    NSURLSessionTask * task = [self.taskDic objectForKey:key];
    [task cancel];
    [self.taskDic removeObjectForKey:key];
}

- (BOOL)analysisRequestCanceledWithTaskId:(NSInteger)taskId
{
    return ([self.taskDic objectForKey:[NSString stringWithFormat:@"%ld",taskId]] == nil);
}

- (BOOL)analysisShouldRetryFromError:(NSError *)error
{
    //TODO 有些情况下不需要重发。
    return YES;
}

- (void)requestWithOwner:(NSObject *)owner
                      taskId:(NSInteger)taskId
                      url:(NSString *)url
               retryCount:(NSInteger)count
                     params:(XLERequestParams *)params
                    success:(XLERequestSuccess)success
                    failure:(XLERequestFailure)failure;
{
    [owner XLE_addDestoryMonitorCallback:^(id owner, NSInteger taskId) {
        [self cancelRequestWithTaskId:taskId];
    } taskId:taskId];
    
    [self configRequestSerializerWithParams:params];
    
    __weak XLENetworkManager *weakSelf = self;
    __weak NSObject *weakOwner = owner;

    void (^requestSuc)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject){
        if (success && ![weakSelf analysisRequestCanceledWithTaskId:taskId]) {
            NSDictionary *responseHeaders = nil;
            if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
                responseHeaders = ((NSHTTPURLResponse *)task.response).allHeaderFields;
            }
            success(responseObject, responseHeaders, params);
        }
        [weakSelf finishRequestWithTaskId:taskId owner:weakOwner];
    };
    
    void (^requestFail)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        if (![weakSelf analysisRequestCanceledWithTaskId:taskId]) {
            if (count>0) {
                [weakSelf requestWithOwner:weakOwner
                                    taskId:taskId
                                       url:url
                                retryCount:count-1
                                    params:params
                                   success:success
                                   failure:failure];
            }
            else{
                [weakSelf finishRequestWithTaskId:taskId owner:weakOwner];
                if (failure) {
                    failure(error, params);
                }
            }
        }
    };
    
    NSURLSessionTask * task;
    switch (params.httpMethod) {
        case XLE_HTTP_GET: {
            task = [self.manager GET:url parameters:params.params progress:nil success:requestSuc failure:requestFail];
            break;
        }
        case XLE_HTTP_POST: {
            task = [self.manager POST:url parameters:params.params constructingBodyWithBlock:nil progress:nil success:requestSuc failure:requestFail];
            break;
        }
    }
    if (task) {
        [self.taskDic setObject:task forKey:[NSString stringWithFormat:@"%ld",taskId]];
    }
}

- (void)configRequestSerializerWithParams:(XLERequestParams *)params
{
    [self.manager.requestSerializer setTimeoutInterval:params.timeOut];
    NSArray *allHeaderKeys = [params.headers allKeys];
    for (NSString *oneKey in allHeaderKeys) {
        [self.manager.requestSerializer setValue:params.headers[oneKey] forHTTPHeaderField:oneKey];
    }
}

- (AFHTTPSessionManager *)manager{
    if (_manager == nil) {
        _manager = [[AFHTTPSessionManager alloc] init];
        _manager.securityPolicy.allowInvalidCertificates = YES;
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    return _manager;
}

- (NSString *)version{
    return XLE_NETWORK_VERSION;
}

#pragma mark - set get
- (NSMutableDictionary *)taskDic{
    if (_taskDic == nil) {
        _taskDic = [NSMutableDictionary new];
    }
    return _taskDic;
}

@end
