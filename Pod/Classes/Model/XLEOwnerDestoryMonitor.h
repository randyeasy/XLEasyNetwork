//
//  XLEOwnerDestoryMonitor.h
//  Pods
//
//  Created by Randy on 16/3/11.
//
//

#import <Foundation/Foundation.h>

@interface XLEOwnerDestoryMonitor : NSObject
@property (weak, nonatomic) id owner;
@property (assign, nonatomic) NSInteger taskId;

/**
 *  owner即时释放，请不要再想持有owner,否则会崩溃
 */
@property (copy, nonatomic) void(^cancelOperation)(id owner, NSInteger taskId);

@end
