//
//  XLENetworkMonitor.h
//  Pods
//
//  Created by Randy on 16/3/10.
//
//

#import <Foundation/Foundation.h>
#import "XLEasyTypeDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLENetworkMonitor : NSObject
@property (assign, readonly, nonatomic) XLENetworkStatus status;
@property (assign, readonly, getter=isReachable, nonatomic) BOOL reachable;
@property (assign, readonly, getter=isReachableViaWWAN, nonatomic) BOOL reachableViaWWAN;
@property (assign, readonly, getter=isReachableViaWiFi, nonatomic) BOOL reachableViaWiFi;
@property (copy, nonatomic) NSString *domain; //默认 www.baidu.com
@property (assign, readonly, nonatomic) BOOL isMonitoring;

+ (instancetype)sharedInstance;

/**
 *  启用网络状态改变监听，建议应用启动时添加
 */
- (void)startMonitoring;

/**
 *  停止网络状态改变监听。
 */
- (void)stopMonitoring;

/**
 *  添加一个监听者 没有排重，可重复添加
 *
 *  @param listener
 *  @param selector 执行方法
 */
- (void)addListener:(NSObject *)listener
           selector:(SEL)selector;
/**
 *  删除一个监听者(listener和selector都匹配) 重复添加的会全部移除
 *
 *  @param listener
 *  @param selector 执行方法
 */
- (void)removeListener:(NSObject *)listener
              selector:(SEL)selector;
/**
 *  移除监听 listener匹配的都移除 重复添加的全部移除
 *
 *  @param listener 监听者
 */
- (void)removeListener:(NSObject *)listener;

- (NSString *)getNetworkStatusName;

@end

NS_ASSUME_NONNULL_END
