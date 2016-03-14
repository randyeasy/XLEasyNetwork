//
//  XLERequestRetryModel.m
//  Pods
//
//  Created by Randy on 16/3/11.
//
//

#import "XLERequestRetryModel.h"

@implementation XLERequestRetryModel

- (instancetype)initWithMaxRetryCount:(NSInteger)count;
{
    self = [super init];
    if (self) {
        _maxRetryCount = count;
        _curRetryCount = 0;
    }
    return self;
}

- (BOOL)nextRetry;
{
    if (_curRetryCount < _maxRetryCount) {
        _curRetryCount++;
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)resetRetry;
{
    _curRetryCount = 0;
}

@end
