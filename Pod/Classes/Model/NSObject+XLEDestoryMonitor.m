//
//  NSObject+XLEMonitorDestory.m
//  Pods
//
//  Created by Randy on 16/3/14.
//
//

#import "NSObject+XLEDestoryMonitor.h"
#import <objc/runtime.h>
#import "XLEOwnerDestoryMonitor.h"

static void *XLEMonitorDestory_Listener = &XLEMonitorDestory_Listener;

@implementation NSObject (XLEDestoryMonitor)

- (NSMutableArray *)XLE_ownerDestoryMonitors;
{
    id value = objc_getAssociatedObject(self, XLEMonitorDestory_Listener);
    if (value == nil) {
        value = [NSMutableArray new];
        [self XLE_setOwnerDestoryMonitors:value];
    }
    return value;
}

- (void)XLE_setOwnerDestoryMonitors:(NSMutableArray *)list
{
    objc_setAssociatedObject(self, XLEMonitorDestory_Listener, list, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)XLE_addDestoryMonitorCallback:(void(^)(id owner, NSInteger taskId))callback taskId:(NSInteger)taskId;
{
    NSMutableArray *theList = [self XLE_ownerDestoryMonitors];
    XLEOwnerDestoryMonitor *monitor = [[XLEOwnerDestoryMonitor alloc] init];
    monitor.owner = self;
    monitor.taskId = taskId;
    monitor.cancelOperation = callback;
    [theList addObject:monitor];
}

- (void)XLE_removeDestoryMonitorWithTaskId:(NSInteger)taskId;
{
    NSMutableArray *mutList = [self XLE_ownerDestoryMonitors];
    NSArray *theList = [mutList copy];
    for (XLEOwnerDestoryMonitor *oneMonitor in theList) {
        if (oneMonitor.taskId == taskId) {
            [mutList removeObject:oneMonitor];
        }
    }
}

@end
