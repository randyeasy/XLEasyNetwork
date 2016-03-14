//
//  XLENetworkMonitorContext.h
//  Pods
//
//  Created by Randy on 16/3/14.
//
//

#import <Foundation/Foundation.h>
#import "XLEasyTypeDefines.h"
@interface XLENetworkMonitorContext : NSObject
@property (weak, nonatomic) id listener;

+ (XLENetworkMonitorContext *)contextWithListener:(id)listener selector:(SEL)sel;

- (BOOL)isEqualWithListener:(id)listener selector:(SEL)sel;
- (void)doMonitorAction;
@end
