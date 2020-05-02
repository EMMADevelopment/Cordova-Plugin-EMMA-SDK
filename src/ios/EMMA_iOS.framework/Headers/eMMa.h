//
//  EMMA.h
//  eMMa_iOS_SDK
//
//  Created by Jaume Cornadó Panadés on 30/9/14.
//  Copyright (c) 2017 EMMA SOLUTIONS SL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class UIButton;
@class EMMAPushSystemController;

@import UserNotifications;

#import "EMMADefines.h"
#import "EMMAConfiguration.h"
#import "EMMAEventRequest.h"
#import "EMMAInAppRequest.h"

@interface EMMA : NSObject

///---------------------------------------------------------------------------------------
/// @name eMMa Initialization
///---------------------------------------------------------------------------------------

/**
Starts the session with our servers

You can get your App Key from your App info. Just go to My Account > Support and create your App (if you did not do it before) and get your App Key right there. Easy!
 
For a simple configuration put this in you AppDelegate's method:
    
 
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        // Override point for customization after application launch.
 
        [EMMA startSession:@"MYFANCYAPPKEY"];
 
        return YES;
    }
 
 @param appKey You app key
*/
+(void)startSession:(NSString*)appKey;

/*
 Starts the session with our servers. 
 
  @param appKey You app key
  @param launchOptions pass the launch options on the appdelegate's didFinishLaunching method
*/

+(void)startSession:(NSString*)appKey withOptions:(NSDictionary*)launchOptions __attribute__((deprecated("Use startSession without options")));

///---------------------------------------------------------------------------------------
/// @name EMMA Configuration
///---------------------------------------------------------------------------------------
+(void)startSessionWithConfiguration:(EMMAConfiguration*) configuration;

/**
 Starts the session in background
 @param configuration EMMA configuration
 */
+(void) startSessionBackground:(EMMAConfiguration *)configuration;

/** Gets the current SDK Version */
+(NSString*)getSDKVersion;

/** Gets the current SDK Build */
+(int) getSDKBuildVersion;

/**
 If you need to see the EMMA log, enable it (before startSession)
 
 @param visible Enable log when true
 */
+(void)setDebuggerOutput:(BOOL)visible;

/**
 Enables EMMA to use the location of the user
 
 This method requieres NSLocationWhenInUseUsageDescription key defined into Info.plist file. If this key is not defined no location tracking will be enabled.
 */
+(void)trackLocation;

/**
 Configures EMMA Root View Controller. Useful to complex implementations
 
 By default EMMA uses the main window rootViewController.
 If this VC is an UINavigationController uses the first VC of the stack as the rootViewController.
 */
+(void)setRootViewController:(UIViewController*)viewController;

/**
 Enable or disable IDFA Tracking
 
    *IMPORTANT*
 
    IDFA tracking is enabled by default on EMMA. If you don’t want to track with IDFA please use method [EMMA setUseIDFA:BOOL]; in order to disable.
    Anyway you need to check the speciefied box on iTunnes Connect question regarding IDFA tracking.
 
 @param use tells to EMMA when to use IDFA tracking. If NO VendorID will be used. It can be enabled/disabled for future app releases.
 */
+(void)setUseIDFA:(BOOL)use;


/** 
 * @name Tracking User Behaviour
 * 
 * With EMMA you can track everything. Here you’ll find the methods that allow tracking custom event that happens on your application and also log all page views.
 */

/**
 Use trackEvent to count the number of times certain events happen during a session of your application.
 
 This can be useful for measuring how often users perform various actions, for example. Your application is currently limited to counting occurrences for 30 different event ids.
 
 EMMAEventRequest * eventRequest = [[EMMAEventRequest alloc] initWithToken: eventName];
 [EMMA trackEvent:eventRequest];
 
 You can get the EVENT_TOKENS creating events on EMMA web platform, if a non-existent token is sent EMMA will return error.
 
 @param event An event token obtained from EMMA Dashboard
 */

+(void) trackEvent:(EMMAEventRequest *) request;

/**
 Use setWhitelist to restrict urls that can be opened for SDK in-app communications
 By default all urls are permited.
 
 Only URLs that starts by an url in the whitelist are opened
 */
+(void)setWhitelist:(NSArray*)urls;

/* 
 Recovery the urls added in whitelist
*/
+(NSArray*)whitelist;

///---------------------------------------------------------------------------------------
/// @name EMMA User Stats
///---------------------------------------------------------------------------------------

/**
 LoginUser logs the user on EMMA database for a user_id (NSString) and email (NSString). When logged you can use [EMMA loginDefault] for log another sign in for the user with the same data.
 
 @param userId the unique id of the user
 @param mail the mail of the user
 @param extras extra fields to track
 */
+(void)loginUser:(NSString*)userId forMail:(NSString*)mail andExtras:(NSDictionary*)extras;

/**
 Convinence method equivalent to loginUserID:forMail:andExtras: without shipping extra fields
 */
+(void)loginUser:(NSString*)userId forMail:(NSString*)mail;


/**
 Log the user with the default data
 */
+(void)loginDefault;

/**
 RegisterUser set a complete registration from device on EMMA database for a user_id (NSString) and email (NSString)
 
 @param userId unique user identifier
 @param mail the mail of the user
 @param extras extra fields to track
 */
+(void)registerUser:(NSString*)userId forMail:(NSString*)mail andExtras:(NSDictionary*)extras;

/** Convinence method without extras, see: registerUserID:forMail:andExtras */
+(void)registerUser:(NSString*)userId forMail:(NSString*)mail;

/**
 This method update or add extra parameters for current logged user in order to have a better segmentation data. It can be used anywhere.
 
    Example of usage:
 
    NSDictionary *extras = @{ @"key1" : @"value1", @"key2" : @"value2" };
    [EMMA trackExtraUserInfo: extras];
 
 @param info This method sends key/value information to track on the user
 */
+(void)trackExtraUserInfo:(NSDictionary*)info;

///---------------------------------------------------------------------------------------
/// @name Tracking Purchase for mCommerce
///---------------------------------------------------------------------------------------

/**
 Starts an order for adding products
 
 @param orderId your order id
 @param customerId your Customer ID. If not passed, EMMA will use the logged one (if exists).
 @param totalPrice your total price
 @param coupon your coupon if needed.
 @param extras extra parameters to track (category, etc...)
 */
+(void)startOrder:(NSString*)orderId customerId:(NSString*)customerId totalPrice:(float)totalPrice coupon:(NSString*)coupon extras:(NSDictionary*)extras;

/**
 Conveinence method without extras. See startOrder:customerId:totalPrice:coupon:extras
 */
+(void)startOrder:(NSString*)orderId customerId:(NSString*)customerId totalPrice:(float)totalPrice coupon:(NSString*)coupon;

/**
 Adds products to your current started order. Always startOrder should be called before.
 
 @param productId your product id.
 @param name your product name
 @param qty your product qty
 @param price product price
 @param extras extra parameters to track
 */
+(void)addProduct:(NSString*)productId name:(NSString*)name qty:(float)qty price:(float)price extras:(NSDictionary*)extras;

/**
 Convinence method without extras. See: addProduct:productId:name:qty:price:extras:
 */
+(void)addProduct:(NSString*)productId name:(NSString*)name qty:(float)qty price:(float)price;

/**
 Track the current order. It should be called after startOrder and after being all cart products added.
 
 The sequence of tracking order in EMMA is always startOrder>addProduct(*distinct products)>trackOrder
 */
+(void)trackOrder;

/** Sets the current currency code for the orders */
+(void)setCurrencyCode:(NSString*)currencyCode;

/**
 Cancel the order referenced by an order id. If your e-commerce allows canceling orders this method updates the purchases data with the cancelled orders.
 */
+(void)cancelOrder:(NSString*)orderId;

///---------------------------------------------------------------------------------------
/// @name EMMA Start View
///---------------------------------------------------------------------------------------

/**
 Sets the current startView options
 
 Options:
    EMMAStartViewManualCall -> Sets the startView in manual mode. Useful for using startviews with labels.
                                Also disables check for startview returning from background
 
 @param options all the options for the startview
 */
+(void) setStartViewOptions: (EMMAStartViewOptions) options;

/**
 *  Sets the delegate for the StartView actions. This will be called when the user interacts with the StartView
 *
 *  @param delegate delegate
 */
+(void) setStartViewDelegate:(id<EMMAStartViewDelegate>) delegate;


/**
 *  If you want you can pass a NSDictionary of parameters (key-value pair) that will append to the URL as a GET parameters. This is useful in case that you need to pass some data from the app to a StartView with a landing page.
 *
 *  @param parameters NSDictionary of parameters
 */
+(void) setStartViewParameters:(NSDictionary*) parameters;

/**
 *  Closes the current StartView
 */
+(void) closeStartView;

///---------------------------------------------------------------------------------------
/// @name eMMa AdBall
///---------------------------------------------------------------------------------------

/**
 Tells if AdBall is on Screen
 
 @return BOOL true if is on screen
 */
+(BOOL) isAdBallShowing;

///---------------------------------------------------------------------------------------
/// @name eMMa Banner
///---------------------------------------------------------------------------------------

/**
 *  Sets the parameter to autocreate the Banner when coming from background
 *
 *  @param autoCreation if YES, it will create the Banner when coming from background automatically
 */
+(void) setBannerAutoCreation:(BOOL) autoCreation;

///---------------------------------------------------------------------------------------
/// @name eMMa Strip
///---------------------------------------------------------------------------------------

/**
 *  Sets the parameter to autocreate the Strip when coming from background
 *
 *  @param autoCreation if YES, it will create the Strip when coming from background automatically
 */
+ (void)setStripAutoCreation:(BOOL) autoCreation;

 
///---------------------------------------------------------------------------------------
/// @name eMMa Tab Bar View
///---------------------------------------------------------------------------------------
/**
 Sets the UITabBarController where the DynamicTab will be shown. If no UITabBarController is defined, application won't execute
 
 @param tabBarController The Application UITabBarController
 */
+(void) setPromoTabBarController:(UITabBarController*)tabBarController;

/**
 *  Sets the index where the Dynamic Tab will be shown if it's not defined on eMMa Platform
 *
 *  @param index position where to show the DynamicTab
 */
+(void) setPromoTabBarIndex:(NSInteger) index;

/**
 *  Sets the UITabBarItem to show if it's not defined on eMMa Platform
 *
 *  @param tabBarItem the tabBarItem to show
 */
+(void) setPromoTabBarItem:(UITabBarItem*) tabBarItem;

/**
 *  Sets the parameter to autocreate the TabBar when coming from background
 *
 *  @param autoCreation if YES, it will create the DynamicTab when coming from background automatically
 */
+(void) setPromoTabBarAutoCreation:(BOOL) autoCreation;


///---------------------------------------------------------------------------------------
/// @name EMMA Rate Alert
///---------------------------------------------------------------------------------------

/**
 Shedules an alert to rate the app
 
 EMMA makes easier to add a Rate alert in order to achieve more positive reviews app.
 
 @param appStoreURL Your AppStore app URL.
 */
+(void)addRateAlertForAppStoreURL:(NSString*)appStoreURL;

/**
 Frequency specifiying hours between alert shows
 
 By default 72 hours.
 
 @param hours  Int specifying hours between alert shows.
 */
+(void) setRateAlertFreq: (int) hours;

/**
 Configures the alert title.
 
 The default value is _Rate this app_
 
 @param title The alert title
 */
+(void) setRateAlertTitle: (NSString*) title;

/**
 Configures the alert message
 
 The default value is _If you like our app, please rate it on App Store!_
 
 @param message The alert message
 */
+(void) setRateAlertMessage: (NSString*) message;

/**
 Sets the cancel button caption
 
 The default value is _No, thanks_
 
 @param cancelButtonText The cancel caption
 */
+(void) setRateAlertCancelButton: (NSString*) cancelButtonText;

/**
 Sets the Rate Button caption
 
 The default value is _Rate it now!_
 
 @param rateItButtonText the rate button caption
 */
+(void) setRateAlertRateItButton: (NSString*) rateItButtonText;

/**
 Sets the Later button caption
 
 The default value is _Later_
 
 @param laterButtonText Later button caption
 */
+(void) setRateAlertLaterButton: (NSString*) laterButtonText;

/**
 *  Sets if the Alert must be shown after an App Update
    Default Value is NO
 *
 *  @param showAlert BOOL
 */
+(void) setRateAlertShowAfterUpdate:(BOOL) showAlert;

///---------------------------------------------------------------------------------------
/// @name EMMA Push system
///---------------------------------------------------------------------------------------

/**
 EMMA allows you to add a very powerful push system easy to integrate. Also allows you send info through pushes and do whatever you want inside your app with it. You need to generate your certificates for your app to be compatible with the push system. Please refer to Appendix Push Notification Certificates.
  */
+(void) startPushSystem;
+(void) startPushSystem: (NSDictionary*) launchOptions __attribute__((deprecated("Use startPushSystem without parameters")));

/**
 This method allows to configure the behaviour of the push system.
 
 Currently the supported options are:
 kPushSystemDisableAlert -> Disables showing alert messages for new pushs received.
 */
+(void) setPushSystemOptions: (EMMAPushSystemOptions) options;

/**
 Configures the delegate for push handling
 
 @param delegate The delegate object
 */
+(void) setPushSystemDelegate: (id<EMMAPushDelegate>)delegate;

/**
 iOS 10 only.
 This delegate allows receive notification with UserNotifications framework.
 
 @param delegate The delegate object
 */

+(void) setPushNotificationsDelegate: (id<UNUserNotificationCenterDelegate>) delegate;

/**
 This method handles the remote notification payload
 
 Example of implementation:
 
    - (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
        [EMMA handlePush:userInfo];
    }
 
 @param userInfo The userInfo payload
 */
+(void) handlePush: (NSDictionary*) userInfo;

/**
 This method registers a new token on eMMa servers.
 
 Example of implementation:
 
    -(void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
        [EMMA registerToken:deviceToken];
    }
 
 @param deviceToken The token received from Apple Servers.
 */
+(void)registerToken:(NSData*)deviceToken;

///---------------------------------------------------------------------------------------
/// @name EMMA User Info
///---------------------------------------------------------------------------------------

+(void)getUserInfo:(EMMAGetUserInfoBlock) resultBlock;

+(void)getUserId:(EMMAGetUserIdBlock) resultBlock;

///---------------------------------------------------------------------------------------
/// @name EMMA Web SDK Sync
///---------------------------------------------------------------------------------------

/**
 *  This method syncs with eMMa Web SDK
 */
+(void)syncWithWebSDK;

/**
 *  This method, sets the domain where the webApp is hosted without the (http://)
 *  Ex: www.example.com
 *
 *  @param domain URL without the http://
 */
+(void)setWebSDKDomain:(NSString*) domain;

/**
 * Returns if session is started and running
 *
 * @return true if started
 */
+(BOOL) isSessionStarted;

/**
 *  This method, sets the API URL for proxies
 *  Ex: https://www.your_proxy.com/ws/
 *
 *  @param url URL
 */
+(void)setWebServiceURL:(NSString*) url;

/**
 * Request a new In App Message providing a custom EMMAInAppRequest
 * <p>
 * NativeAd Example:
 *
 * {
 *
 * EMMANativeAdRequest *requestParams =  [[EMMANativeAdRequest alloc] init];
 * requestParams.templateId = "dashboardAD";
 *
 * EMMA.getInAppMessage(requestParams);
 * }
 * <p>
 * Startview Example:
 *
 * {
 *
 * EMMAInAppRequest *requestParams = [[EMMAInAppRequest alloc] initWithType:Startview];
 * EMMA.getInAppMessage(requestParams);
 * }
 *
 *
 * @param type in app method type.
 * @param request in app request.
 */
+(void)inAppMessage:(EMMAInAppRequest*) request;

+(void)inAppMessage:(EMMAInAppRequest*) request withDelegate:(id<EMMAInAppMessageDelegate>) delegate;

/**
 * Method adds delegate for inapp message requests
 *
 * @param delegate The delegate
 */
+(void)addInAppDelegate:(id<EMMAInAppMessageDelegate>) delegate;

/**
 * Method removes delegate with same instance reference
 *
 * @param delegate The delegate
 */
+(void) removeInAppDelegate:(id<EMMAInAppMessageDelegate>) delegate;

/**
 * Method adds delegate for coupons requests
 *
 * @param delegate The delegate
 */
+(void)addCouponDelegate:(id<EMMACouponDelegate>) delegate;

/**
 * Method opens the native ad on browser or inapp webview whatever 
 * EMMA dashboard configuration
 *
 * @param nativeAdCampaignId The campaign identifier
 */
+(void)openNativeAd:(NSString *) nativeAdCampaignId;

/**
 * Method sends impression event for specific campaign
 * 
 * @param campaignType The type of campaign
 * @param campaignId The campaign identifier
 */
+(void)sendImpression:(EMMACampaignType) campaignType withId:(NSString*) campaignId;

/**
 * Method sends click event for specific campaign
 *
 * @param campaignType The type of campaign
 * @param campaignId The campaign identifier
 */
+(void)sendClick:(EMMACampaignType) campaignType withId:(NSString*) campaignId;

/**
 * Handle deeplink URL for internal porpuses of EMMA, e.g deeplinks with attribution campaigns
 *
 * @param url The deeplink url
 */
+(void)handleLink:(NSURL*) url;

/**
 * Set custom powlink domains
 *
 * @param customDomains Array of powlink domains
 */
+(void) setPowlinkDomains: (NSArray<NSString*> *) customDomains;

/**
 * Set custom short powlink domains
 *
 * @param customDomains Array of powlink domains
 */
+(void) setShortPowlinkDomains: (NSArray<NSString*> *) customDomains;

/**
 * This method enables communication between SDK and EMMA on previously disabled user.
 * If already enabled, does nothing
 */
+(void) enableUserTracking;

/**
 * This method disables all the communication between SDK and EMMA
 * @param deleteUser If this flag is set to true deletes all user data on server. *WARNING* Can alter dashboard stats
 */
+(void) disableUserTracking:(BOOL) deleteUser;

/**
 * Check if user tracking is enabled
 */
+(BOOL) isUserTrackingEnabled;

/**
 * Clears caches and reset instance
 */
+(void) reset;

/**
 * This method enable or disable screen events. Default: YES
 *
 * @param trackScreenEvents if YES track screen events
 */
+(void) trackScreenEvents: (BOOL) trackScreenEvents;

/**
 * This method gets the install attribution info. The response can have three status
 * for attribution: pending, organic or campaign
 *
 * @param attributionDelegate delegate for response
 */
+(void) installAttributionInfo: (id<EMMAInstallAttributionDelegate>) attributionDelegate;

/**
 * This method returns if push notification is from EMMA.
 *
 * @param content notification content
 */
+(BOOL) isEMMAPushNotification:(UNNotificationContent*) content API_AVAILABLE(ios(10.0));

/**
* This method process notification to show a image, gif or video.
*
* @param requet notification request
* @param content notificatio content
* @param completion callback
*/
+(void)didReceiveNotificationRequest:(UNNotificationRequest *)request withNotificationContent:(UNMutableNotificationContent *)content AndCompletionHandler:(void (^)(UNNotificationContent *)) completion;

@end
