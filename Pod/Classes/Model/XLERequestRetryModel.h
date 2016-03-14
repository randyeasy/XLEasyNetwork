//
//  XLERequestRetryModel.h
//  Pods
//
//  Created by Randy on 16/3/11.
//
//

#import <Foundation/Foundation.h>

@interface XLERequestRetryModel : NSObject
@property (assign, readonly, nonatomic) NSInteger maxRetryCount;
@property (assign, readonly, nonatomic) NSInteger curRetryCount;

- (instancetype)initWithMaxRetryCount:(NSInteger)count;

- (BOOL)nextRetry;
- (void)resetRetry;

@end
