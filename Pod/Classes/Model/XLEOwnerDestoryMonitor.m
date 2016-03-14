//
//  XLEOwnerDestoryMonitor.m
//  Pods
//
//  Created by Randy on 16/3/11.
//
//

#import "XLEOwnerDestoryMonitor.h"

@implementation XLEOwnerDestoryMonitor

- (void)dealloc
{
    if (self.cancelOperation) {
        self.cancelOperation(self.owner, self.taskId);
    }
}

@end
