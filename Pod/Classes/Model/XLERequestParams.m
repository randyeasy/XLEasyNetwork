//
//  XLERequestParams.m
//  Pods
//
//  Created by Randy on 16/3/10.
//
//

#import "XLERequestParams.h"
#import "XLENetworkManager.h"

@interface XLERequestParams ()
@property (strong, nonatomic) NSMutableDictionary *mutParams;
@property (strong, nonatomic) NSMutableDictionary *mutHeaders;
@end

@implementation XLERequestParams

- (instancetype)init
{
    return [self initWithParams:nil];
}

- (instancetype)initWithParams:(NSDictionary *)params;
{
    return [self initWithParams:params method:XLE_HTTP_POST];
}

- (instancetype)initWithParams:(NSDictionary *)params
                        method:(XLEHTTPMethod)method;
{
    self = [super init];
    if (self) {
        _httpMethod = method;
        _mutParams = [params mutableCopy];
        self.gzip = YES;
        if (_mutParams == nil) {
            _mutParams = [NSMutableDictionary new];
        }
        _timeOut = [XLENetworkManager sharedInstance].defaultTimeoutInterval;
    }
    return self;
}

- (void)setParamValue:(id)param forKey:(id)key;
{
    NSParameterAssert(param);
    NSParameterAssert(key);
    if (param && key) {
        [self.mutParams setObject:param forKey:key];
    }
}

- (void)setHeaderValue:(NSString *)value forKey:(NSString *)key;
{
    NSParameterAssert(value);
    NSParameterAssert(key);
    if (value && key) {
        if ([key isEqualToString:@"contentType"]) {
            NSAssert(0, @"contentType 请通过 setHeaderContentType 方法设置");
        }
        else
        {
            [self.mutHeaders setObject:value forKey:key];
        }
    }
}

- (void)setHeaderContentType:(XLEHTTPContentType)contentType;
{
    if (contentType == XLE_HTTP_CONTENT_FORM_URLENCODED) {
        [self.mutHeaders setObject:@"application/x-www-form-urlencoded" forKey:@"contentType"];
    }
    else if (contentType == XLE_HTTP_CONTENT_JSON)
    {
        [self.mutHeaders setObject:@"application/json" forKey:@"contentType"];
    }
}

#pragma mark - set get
- (NSMutableDictionary *)mutHeaders{
    if (_mutHeaders == nil) {
        _mutHeaders = [NSMutableDictionary new];
    }
    return _mutHeaders;
}

- (NSDictionary *)params{
    return [self.mutParams copy];
}

- (NSDictionary *)headers{
    return [self.mutHeaders copy];
}

- (void)setGzip:(BOOL)gzip{
    _gzip = gzip;
    if (gzip) {
        [self setHeaderValue:@"gzip" forKey:@"Accept-Encoding"];
    }
    else
    {
        [self.mutHeaders removeObjectForKey:@"Accept-Encoding"];
    }
}

- (NSString *)httpMethodStr{
    NSString *methodStr = @"POST";
    if (self.httpMethod == XLE_HTTP_GET) {
        methodStr = @"GET";
    }
    return methodStr;
}

@end
