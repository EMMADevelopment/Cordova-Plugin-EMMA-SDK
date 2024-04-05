#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
#import <EMMA_iOS/EMMA_iOS.h>

#define PUSH_ENABLED 1

/* ERROR MESSAGES */
#define invalidMethodArguments @"Check if method exists or arguments are correct"
#define mandatoryNotEmpty @" can not be empty"
#define mandatoryNotZero @" can not be zero"
#define keyValueMappingError @" key-value attributes invalid"
#define mappingValueError @"only allowed property value in string type"
#define conversionValueMustBe1And63 @" conversionValues must be a number between 1 and 63"
#define coarseValueMustBe @" must be high, medium or low"

/* START SESSION */
#define sessionKeyArg @"sessionKey"
#define debugArg @"debug"
#define apiUrlArg @"apiUrl"
#define queueTimeArg @"queueTime"
#define trackScreenEventsArg @"trackScreenEvents"
#define customPowlinkDomainsArg @"powlinkDomains"
#define customShortPowlinkDomainsArg @"customShortPowlinkDomains"
#define minQueueTime 10
#define skanAttributionArg @"skanAttribution"
#define skanCustomManagementAttributionArg @"skanCustomManagementAttribution"

/* PUSH */
#define EMMAPushKey @"eMMa"

/* EVENT */
#define eventTokenArg @"token"
#define eventAttributesArg @"attributes"

/* GLOBAL */
#define extrasArg @"extras"

/* LOGIN - REGISTER */
#define userIdArg @"userId"
#define emailArg @"email"

/* ORDER */
#define orderIdArg @"orderId"
#define orderTotalPriceArg @"totalPrice"
#define orderCustomerIdArg @"customerId"
#define orderCouponArg @"coupon"

#define orderProductPriceArg @"price"
#define orderProductIdArg @"productId"
#define orderProductNameArg @"productName"
#define orderProductQuantityArg @"quantity"

/* INAPP */
#define inAppTypeArg @"type"
#define inAppTemplateIdArg @"templateId"
#define inAppCampaignId @"campaignId"
#define inAppBatchArg @"batch"

#define inAppStartview @"startview"
#define inAppBanner @"banner"
#define inAppStrip @"strip"
#define inAppAdball @"adball"
#define inAppNativeAd @"nativeAd"

#define nativeAdId @"id"

/* SKAdNetwork */
#define skadConversionValue @"conversionValue"
#define skadCoarseValue @"coarseValue"
#define skadLockWindow @"lockWindow"
#define conversionModelArg @"conversionModel"

#define CONCAT(a, b) \
    [NSString stringWithFormat:@"%@%@", a, b]


#define EMMALinkNotification @"EMMALinkNotification"

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 && PUSH_ENABLED == 1
@import UserNotifications;
#endif

@interface EMMAPlugin : CDVPlugin<EMMAInAppMessageDelegate>
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 && PUSH_ENABLED == 1
@property (nonatomic, strong) id<UNUserNotificationCenterDelegate> pushDelegate;
#endif

- (void)startSession:(CDVInvokedUrlCommand*)command;
- (void)startPush:(CDVInvokedUrlCommand *)command;
- (void)setNotificationDelegate:(id<UNUserNotificationCenterDelegate>)delegate;
- (void)trackLocation:(CDVInvokedUrlCommand *)command;
- (void)trackEvent:(CDVInvokedUrlCommand *)command;
- (void)trackUserExtraInfo:(CDVInvokedUrlCommand *)command;
- (void)loginUser:(CDVInvokedUrlCommand *)command;
- (void)registerUser:(CDVInvokedUrlCommand *)command;
- (void)startOrder:(CDVInvokedUrlCommand *)command;
- (void)addProduct:(CDVInvokedUrlCommand *)command;
- (void)trackOrder:(CDVInvokedUrlCommand *)command;
- (void)cancelOrder:(CDVInvokedUrlCommand *)command;
- (void)enableUserTracking:(CDVInvokedUrlCommand *)command;
- (void)disableUserTracking:(CDVInvokedUrlCommand *)command;
- (void)isUserTrackingEnabled:(CDVInvokedUrlCommand *)command;
- (void)inAppMessage:(CDVInvokedUrlCommand *)command;
- (void)onDeviceReady:(CDVInvokedUrlCommand *)command;
- (void)setCustomerId:(CDVInvokedUrlCommand *)command;
- (void)requestTrackingWithIdfa:(CDVInvokedUrlCommand *)command;
- (void)sendInAppImpression:(CDVInvokedUrlCommand *)command;
- (void)sendInAppClick:(CDVInvokedUrlCommand *)command;
- (void)openNativeAd:(CDVInvokedUrlCommand *)command;
- (void)handleLink:(CDVInvokedUrlCommand *)command;
- (void)areNotificationsEnabled:(CDVInvokedUrlCommand *)command;
- (void)requestNotificationsPermission:(CDVInvokedUrlCommand *)command;
- (void)sendPushToken:(CDVInvokedUrlCommand *)command;
- (void)updatePostbackConversionValue:(CDVInvokedUrlCommand *)command;
- (void)updatePostbackConversionValueSkad4:(CDVInvokedUrlCommand *)command;
@end
