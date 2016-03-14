//
//  XLEFileParams.m
//  Pods
//
//  Created by Randy on 16/3/10.
//
//

#import "XLEFileParams.h"

NSString *const XLE_FILEPARAMS_MP3 = @"audio/mp3";
NSString *const XLE_FILEPARAMS_PIC = @"image/*";

@implementation XLEFileParams

- (instancetype)initWithName:(NSString *)name
                    fileName:(NSString *)fileName
                    filePath:(NSString *)filePath
                    miniType:(NSString *)miniType;
{
    self = [super init];
    if (self) {
        NSParameterAssert(fileName);
        NSParameterAssert(filePath);
        NSParameterAssert(miniType);
        _name = name?:@"file";
        _fileName = fileName;
        _filePath = filePath;
        _miniType = miniType;
    }
    return self;
}

@end
