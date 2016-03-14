//
//  XLENetworkMonitor.m
//  Pods
//
//  Created by Randy on 16/3/10.
//
//

#import "XLENetworkMonitor.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "XLENetworkMonitorContext.h"

@interface XLENetworkMonitor ()
@property (strong, nonatomic) AFNetworkReachabilityManager *afManager;
@property (assign, nonatomic) XLENetworkStatus status;
@property (assign, nonatomic) BOOL isMonitoring;
@property (strong, nonatomic) NSMutableArray *listeners;

@end

@implementation XLENetworkMonitor

- (void)dealloc {
    [self stopMonitoring];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _status = XLENetworkStatusUnknown;
        _domain = @"www.baidu.com";
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


- (void)startMonitoring {
    [self stopMonitoring];
    self.afManager = [AFNetworkReachabilityManager managerForDomain:self.domain];
    __weak XLENetworkMonitor *weakSelf = self;
    [self.afManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        weakSelf.status = [weakSelf transferNetworkStatus:status];
        [weakSelf sendNetworkStatusChangeToListeners];
    }];
    [self.afManager startMonitoring];
    self.isMonitoring = YES;
}

- (void)stopMonitoring {
    self.isMonitoring = NO;
    [self.afManager stopMonitoring];
    self.afManager = nil;
}

- (void)addListener:(NSObject *)listener selector:(SEL)selector
{
    XLENetworkMonitorContext *context = [XLENetworkMonitorContext contextWithListener:listener selector:selector];
    [self.listeners addObject:context];
}

- (void)removeListener:(NSObject *)listener selector:(SEL)selector
{
    NSArray *theList = [self.listeners copy];
    for (XLENetworkMonitorContext *oneContext in theList) {
        if ([oneContext isEqualWithListener:listener selector:selector]) {
            [self.listeners removeObject:oneContext];
        }
        else if (!oneContext.listener)//如果listener已经释放，也移除掉
        {
            [self.listeners removeObject:oneContext];
        }
    }
}

- (void)removeListener:(NSObject *)listener
{
    NSArray *theList = [self.listeners copy];
    for (XLENetworkMonitorContext *oneContext in theList) {
        if (listener == oneContext.listener) {
            [self.listeners removeObject:oneContext];
        }
        else if (!oneContext.listener)//如果listener已经释放，也移除掉
        {
            [self.listeners removeObject:oneContext];
        }
    }
}

- (NSString *)getNetworkStatusName
{
    NSString *statusName = @"未知";
    switch (self.status) {
        case XLENetworkStatusUnknown: {
            statusName = @"未知";
            break;
        }
        case XLENetworkStatusNotReachable: {
            statusName = @"无网络";
            break;
        }
        case XLENetworkStatusReachableViaWWAN: {
            statusName = @"WWAN";
            break;
        }
        case XLENetworkStatusReachableViaWiFi: {
            statusName = @"WiFi";
            break;
        }
    }
    return statusName;
}

#pragma mark - internal
- (void)sendNetworkStatusChangeToListeners
{
    NSArray *theList = [self.listeners copy];
    for (XLENetworkMonitorContext *oneContext in theList) {
        if (!oneContext.listener) {
            [self.listeners removeObject:oneContext];
        }
        else
        {
            [oneContext doMonitorAction];
        }
    }
}

- (XLENetworkStatus)transferNetworkStatus:(AFNetworkReachabilityStatus)status
{
    XLENetworkStatus networkStatus;
    switch (status) {
        case AFNetworkReachabilityStatusNotReachable:
            networkStatus = XLENetworkStatusNotReachable;
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            networkStatus = XLENetworkStatusReachableViaWWAN;
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            networkStatus = XLENetworkStatusReachableViaWiFi;
            break;
        default:
            networkStatus = XLENetworkStatusUnknown;
            break;
    }
    return networkStatus;
}

#pragma mark - set get
- (void)setDomain:(NSString *)domain
{
    NSString *theDomain = domain.length>0?domain:@"www.baidu.com";
    if (![theDomain isEqualToString:_domain]) {
        _domain = theDomain;
        if (self.isMonitoring) {
            [self startMonitoring];
        }
    }
}

- (BOOL)isReachable {
    return [self isReachableViaWWAN] || [self isReachableViaWiFi];
}

- (BOOL)isReachableViaWWAN {
    return self.status == XLENetworkStatusReachableViaWWAN;
}

- (BOOL)isReachableViaWiFi {
    return self.status == XLENetworkStatusReachableViaWiFi;
}

- (NSMutableArray *)listeners{
    if (_listeners == nil) {
        _listeners = [NSMutableArray new];
    }
    return _listeners;
}

@end
