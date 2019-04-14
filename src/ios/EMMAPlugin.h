#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

/* ERROR MESSAGES */
#define invalidMethodArguments @"Check if method exists or arguments are correct"
#define mandatoryNotEmpty @" can not be empty"
#define mandatoryNotZero @" can not be zero"
#define keyValueMappingError @" key-value attributes invalid"
#define mappingValueError @"only allowed property value in string type"

/* START SESSION */
#define sessionKeyArg @"sessionKey"
#define debugArg @"debug"
#define apiUrlArg @"apiUrl"
#define queueTimeArg @"queueTime"
#define trackScreenEventsArg @"trackScreenEvents"
#define customPowlinkDomainsArg @"powlinkDomains"
#define customShortPowlinkDomainsArg @"customShortPowlinkDomains"
#define minQueueTime 10

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
#define orderTotalPriceArg "totalPrice"
#define orderCustomerIdArg @"customerId"
#define orderCurrencyCodeArg @"currencyCode"
#define orderCouponArg @"coupon"

#define orderProductPriceArg @"price"
#define orderProductIdArg @"productId"
#define orderProductNameArg @"productName"
#define orderProductQuantityArg @"quantity"

/* INAPP */
#define inAppTypeArg @"type"
#define inAppStartview @"startview"
#define inAppBanner @"banner"
#define inAppStrip @"strip"
#define inAppAdball @"adball"

#define CONCAT(a, b) \
    [NSString stringWithFormat:@"%@%@", a, b]



#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
#endif

@interface EMMAPlugin : CDVPlugin
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@property (nonatomic, strong) id<UNUserNotificationCenterDelegate> pushDelegate;
#endif
- (void)startSession:(CDVInvokedUrlCommand*)command;
- (void)startPush:(CDVInvokedUrlCommand *)command;
@end
