//
//  EMMAConfiguration.h
//  eMMa
//
//  Created by Ivan Aguila Garrofe on 24/7/17.
//  Copyright © 2017 moddity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMMADefines.h"

@import UserNotifications;

@interface EMMAConfiguration : NSObject

@property (nonatomic, strong) NSString* sessionKey;
@property BOOL debugEnabled;
@property int queueTime;
@property (nonatomic, strong) NSString* urlBase;
@property (nonatomic, strong) NSDictionary* pushLaunchOptions __attribute__((deprecated("Use startPushSystem without parameters")));
@property (nonatomic, strong) NSArray<NSString*>* customPowlinkDomains;
@property (nonatomic, strong) NSArray<NSString*>* shortPowlinkDomains;
@property (nonatomic, assign) id<EMMAPushDelegate> pushDelegate;
@property (nonatomic, assign) id<UNUserNotificationCenterDelegate> pushNotificationsDelegate;
@property BOOL trackScreenEvents;


-(id) initWithSessionKey:(NSString*) sessionKey;

@end

