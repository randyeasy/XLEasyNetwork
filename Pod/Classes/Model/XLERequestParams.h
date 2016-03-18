//
//  XLERequestParams.h
//  Pods
//
//  Created by Randy on 16/3/10.
//
//

#import <Foundation/Foundation.h>

#import "XLEasyNetworkTypeDefines.h"

@interface XLERequestParams : NSObject
@property (assign, nonatomic, getter=isGZIP) BOOL gzip;
@property (assign, nonatomic) XLEHTTPMethod httpMethod;
@property (assign, nonatomic) NSTimeInterval timeOut;//默认60s
/** 请求最大重试次数*/
@property (strong, nonatomic, readonly) NSDictionary *params;
@property (strong, nonatomic, readonly) NSDictionary *headers;

- (instancetype)initWithParams:(NSDictionary *)params;
- (instancetype)initWithParams:(NSDictionary *)params method:(XLEHTTPMethod)method;

- (void)setParamValue:(id)param forKey:(id)key;
- (void)setHeaderValue:(NSString *)value forKey:(NSString *)key;
- (void)setHeaderContentType:(XLEHTTPContentType)contentType;

- (NSString *)httpMethodStr;

@end
