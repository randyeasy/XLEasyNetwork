//
//  XLEasyNetworkTypeDefines.h
//  Pods
//
//  Created by Randy on 16/3/10.
//
//

#ifndef XLEasyNetworkTypeDefines_h
#define XLEasyNetworkTypeDefines_h

typedef NS_ENUM(NSInteger, XLEHTTPMethod) {
    XLE_HTTP_GET = 0,
    XLE_HTTP_POST = 1
};

typedef NS_ENUM(NSInteger, XLEHTTPContentType) {
    XLE_HTTP_CONTENT_FORM_URLENCODED,//"application/x-www-form-urlencoded"
    XLE_HTTP_CONTENT_JSON,//"application/json"
};

typedef NS_ENUM(NSInteger, XLENetworkStatus) {
    XLENetworkStatusUnknown          = -1,
    XLENetworkStatusNotReachable     = 0,
    XLENetworkStatusReachableViaWWAN = 1,
    XLENetworkStatusReachableViaWiFi = 2,
};

/**
 *  "audio/mp3"
 */
extern NSString *const XLE_FILEPARAMS_MP3;
/**
 *  "image/\*" \没有
 */
extern NSString *const XLE_FILEPARAMS_PIC;

#endif /* XLEasyNetworkTypeDefines_h */
