#import "AppDelegate+EMMAPlugin.h"
#import "EMMAPlugin.h"
#import <objc/runtime.h>
#import <EMMA_iOS/EMMA_iOS.h>

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 && PUSH_ENABLED == 1
@import UserNotifications;

@interface AppDelegate () <UNUserNotificationCenterDelegate>
#else
@interface AppDelegate ()
#endif

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler;
@end

@implementation AppDelegate (EMMAPlugin)

#if PUSH_ENABLED == 1
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = @selector(application:didFinishLaunchingWithOptions:);
        SEL swizzledSelector = @selector(application:swizzledDidFinishLaunchingWithOptions:);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void) application:(UIApplication*)application swizzledDidFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    [self application:application swizzledDidFinishLaunchingWithOptions:launchOptions];
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    EMMAPlugin * plugin = [self getPlugin];
    [plugin setNotificationDelegate:self];
#endif
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [EMMALegacy registerToken:deviceToken];
    NSLog(@"Obtained token %@", deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Remote notification registration failed: %@", error);
}

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    if ([self isPushFromEMMA: userInfo]) {
        [EMMALegacy handlePush: userInfo];
    }
    
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionBadge);
}

-(void) userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if ([self isPushFromEMMA: userInfo]) {
        [EMMALegacy handlePush: userInfo withActionIdentifier:response.actionIdentifier];
    }
    
    completionHandler();
}
#endif
#endif

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *restorableObjects))restorationHandler {
    
    if (userActivity.webpageURL) {
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:EMMALinkNotification object:[userActivity webpageURL]]];
    }
    
    return YES;
}

- (BOOL) isPushFromEMMA: (NSDictionary*) userInfo {
    return [userInfo objectForKey:EMMAPushKey] != nil;
}

- (EMMAPlugin *) getPlugin {
    return  [self.viewController getCommandInstance:PLUGIN_NAME];
}

@end
