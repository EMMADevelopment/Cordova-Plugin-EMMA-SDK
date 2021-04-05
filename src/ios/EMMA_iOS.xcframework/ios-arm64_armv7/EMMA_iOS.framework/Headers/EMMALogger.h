//
//  EMMALogger.h
//  EMMA
//
//  Created by Jaume Cornadó Panadés on 14/10/14.
//  Copyright (c) 2014 EMMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMMALogger : NSObject

//TODO document this
typedef NS_OPTIONS(NSUInteger, kEmmaLogTypes) {
    kEmmaLogLevelNone = (1 << 0),
    kEmmaLogLevelDebug = (1 << 1),
    kEmmaLogLevelInfo = (1 << 2),
    kEmmaLogLevelWarning = (1 << 3),
    kEmmaLogLevelError = (1 << 4)
};

//TODO document this
@property NSUInteger logLevel;

+(id) sharedLogger;

//TODO document this
+(void) log: (NSString*) message, ...;

//TODO document this
+(void) log: (NSString*) message andType: (kEmmaLogTypes) logType;

@end
