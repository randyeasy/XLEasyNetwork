//
//  XLENetworkMonitorContext.m
//  Pods
//
//  Created by Randy on 16/3/14.
//
//

#import "XLENetworkMonitorContext.h"

@interface XLENetworkMonitorContext ()
{
    SEL selector;
}

@end

@implementation XLENetworkMonitorContext

+ (XLENetworkMonitorContext *)contextWithListener:(id)listener
                                         selector:(SEL)sel;
{
    XLENetworkMonitorContext *context = [[XLENetworkMonitorContext alloc] init];
    context.listener = listener;
    context->selector = sel;
    return context;
}

- (BOOL)isEqualWithListener:(id)listener selector:(SEL)sel;{
    if (self.listener == listener && self->selector == sel) {
        return YES;
    }
    return NO;
}

- (void)doMonitorAction
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([self.listener respondsToSelector:self->selector]) {
        [self.listener performSelector:self->selector];
    }
#pragma clang diagnostic pop
}

@end
