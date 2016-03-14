//
//  XLENetworkManager.h
//  Pods
//
//  Created by Randy on 16/3/10.
//
//

#import <Foundation/Foundation.h>

#import "XLERequestParams.h"
#import "XLEFileParams.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^XLERequestSuccess)(id response, NSDictionary *responseHeaders, XLERequestParams *params);
typedef void(^XLERequestFailure)(NSError *error, XLERequestParams *params);
typedef void(^XLERequestProgress)(NSProgress * _Nonnull progress);

@interface XLENetworkManager : NSObject
@property (assign, nonatomic) NSTimeInterval defaultTimeoutInterval; //默认 60s

+ (instancetype)sharedInstance;

/**
 *  http 请求
 *
 *  @param owner   请求的拥有者，如果owner释放，请求自动取消。传nil时请求为全局请求，不自动取消。
 *  @param url     请求地址
 *  @param params  请求参数
 *  @param success 成功回调
 *  @param failure 失败回调
 *
 *  @return 请求的唯一id
 */
- (NSInteger)requestWithOwner:(nullable NSObject *)owner
                          url:(NSString *)url
                     params:(XLERequestParams *)params
                    success:(nullable XLERequestSuccess)success
                    failure:(nullable XLERequestFailure)failure;

/**
 *  http 请求 失败后自动重发
 *
 *  @param owner   请求的拥有者，如果owner释放，请求自动取消。传nil时请求为全局请求，不自动取消。
 *  @param url     请求地址
 *  @param params  请求参数
 *  @param retryCount 请求失败后的重发次数，为0时只请求一次，为1时请求两次
 *  @param success 成功回调
 *  @param failure 失败回调
 *
 *  @return 请求的唯一id
 */
- (NSInteger)requestRetryWithOwner:(nullable NSObject *)owner
                               url:(NSString *)url
                          params:(XLERequestParams *)params
                      retryCount:(NSInteger)count
                         success:(XLERequestSuccess)success
                         failure:(XLERequestFailure)failure;

/**
 *  下载
 *
 *  @param owner   请求的拥有者，如果owner释放，请求自动取消。传nil时请求为全局请求，不自动取消。
 *  @param url     下载地址
 *  @param params  下载参数
 *  @param path    下载的本地路径
 *  @param success 成功回调
 *  @param failure 失败回调
 *
 *  @return 请求的唯一id
 */
- (NSInteger)downloadWithOwner:(nullable NSObject *)owner
                           url:(NSString *)url
                      params:(XLERequestParams *)params
                downloadPath:(NSString *)path
                     success:(nullable XLERequestSuccess)success
                     failure:(nullable XLERequestFailure)failure;

/**
 *  上传 表单提交
 *
 *  @param owner   请求的拥有者，如果owner释放，请求自动取消。传nil时请求为全局请求，不自动取消。
 *  @param url      上传地址
 *  @param params   上传参数
 *  @param formFile 上传的文件信息
 *  @param success  成功回调
 *  @param failure  失败回调
 *
 *  @return 请求的唯一id
 */
- (NSInteger)uploadWithOwner:(nullable NSObject *)owner
                         url:(NSString *)url
                    params:(XLERequestParams *)params
                  formFile:(XLEFileParams *)formFile
                   success:(nullable XLERequestSuccess)success
                   failure:(nullable XLERequestFailure)failure;

/**
 *  下载文件
 *
 *  @param owner   请求的拥有者，如果owner释放，请求自动取消。传nil时请求为全局请求，不自动取消。
 *  @param url      文件地址
 *  @param params   参数
 *  @param path     本地下载路径
 *  @param progress 进度
 *  @param success  成功回调，response为文件的下载路径
 *  @param failure  失败回调
 *
 *  @return 请求唯一id
 */
- (NSInteger)downloadWithOwner:(nullable NSObject *)owner
                           url:(NSString *)url
                      params:(XLERequestParams *)params
                downloadPath:(NSString *)path
                    progress:(nullable XLERequestProgress)progress
                     success:(nullable XLERequestSuccess)success
                     failure:(nullable XLERequestFailure)failure;

/**
 *  上传 表单提交
 *
 *  @param owner   请求的拥有者，如果owner释放，请求自动取消。传nil时请求为全局请求，不自动取消。
 *  @param url      上传地址
 *  @param params   上传的参数
 *  @param formFile 上传的文件信息
 *  @param progress 进度
 *  @param success  成功回调
 *  @param failure  失败回调
 *
 *  @return 请求的唯一id
 */
- (NSInteger)uploadWithOwner:(nullable NSObject *)owner
                         url:(NSString *)url
                    params:(XLERequestParams *)params
                  formFile:(XLEFileParams *)formFile
                  progress:(nullable XLERequestProgress)progress
                   success:(nullable XLERequestSuccess)success
                   failure:(nullable XLERequestFailure)failure;

/**
 *  根据请求的唯一id取消某一个请求
 *
 *  @param owner   请求的拥有者，如果请求的时候有添加owner，传相同的owner。
 *  @param taskId 请求唯一id
 */
- (void)cancelRequestWithTaskId:(NSInteger)taskId
                          owner:(nullable NSObject *)owner;

- (NSString *)version;

@end

NS_ASSUME_NONNULL_END
