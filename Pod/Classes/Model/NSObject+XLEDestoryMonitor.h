//
//  NSObject+XLEMonitorDestory.h
//  Pods
//
//  Created by Randy on 16/3/14.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (XLEDestoryMonitor)

- (void)XLE_addDestoryMonitorCallback:(void(^)(id owner, NSInteger taskId))callback
                               taskId:(NSInteger)taskId;
- (void)XLE_removeDestoryMonitorWithTaskId:(NSInteger)taskId;

@end

NS_ASSUME_NONNULL_END
