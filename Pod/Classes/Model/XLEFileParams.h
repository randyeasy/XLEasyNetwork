//
//  XLEFileParams.h
//  Pods
//
//  Created by Randy on 16/3/10.
//
//

#import <Foundation/Foundation.h>

#import "XLEasyTypeDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLEFileParams : NSObject
@property (copy, nonatomic) NSString *miniType;
@property (copy, nonatomic) NSString *filePath;
@property (copy, nonatomic) NSString *fileName;
@property (copy, nonatomic) NSString *name;

/**
 *  初始化方法
 * 
 *  @param name   上传的文件信息对应的key 为空时为"file"
 *  @param fileName 文件名称带后缀
 *  @param filePath 文件本地路径
 *  @param miniType XLE_FILEPARAMS_MP3、XLE_FILEPARAMS_PIC等
 *
 *  @return 
 */
- (instancetype)initWithName:(nullable NSString *)name
                    fileName:(NSString *)fileName
                        filePath:(NSString *)filePath
                        miniType:(NSString *)miniType;

@end

NS_ASSUME_NONNULL_END