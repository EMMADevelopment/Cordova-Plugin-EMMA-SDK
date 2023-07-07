//
//  EMMAConfiguration.h
//  eMMa
//
//  Created by Ivan Aguila Garrofe on 24/7/17.
//  Copyright © 2017 EMMA. All rights reserved.
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
/** Enable or disable Apple Ads attribution. If Apple Ads attribution is disable the attribution is made with match by fingerprint.
    Default YES.
 */
@property BOOL appleAdsAttribution;
/** Enable or disable SKAdNetworkAttribution.
    Default YES
 */
@property BOOL skanAttribution;
/** Enable or disable if updateConversionPostback is managed by SDK or custom. Default is managed by SDK.
    Default NO.
 */
@property BOOL skanCustomManagementAttribution;

-(id) initWithSessionKey:(NSString*) sessionKey;

@end
