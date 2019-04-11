#import "AppDelegate+EMMAPlugin.h"
#import "EMMAPlugin.h"
#import <objc/runtime.h>
#import <EMMA_iOS/EMMA.h>

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;

@interface AppDelegate () <UNUserNotificationCenterDelegate>
@end
#endif

@implementation AppDelegate (EMMAPlugin)

+ (void)load {
    Method originalMethod = class_getInstanceMethod(self, @selector(application:didFinishLaunchingWithOptions:));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(application:swizzledDidFinishLaunchingWithOptions:));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void) application:(UIApplication*)application swizzledDidFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    [self application:application swizzledDidFinishLaunchingWithOptions:launchOptions];
    
    
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    EMMAPlugin * plugin = [self getPlugin];
    [plugin setPushDelegate:self];
#endif
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [EMMA registerToken:deviceToken];
    NSLog(@"Obtained token %@", deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Remote notification registration failed: %@", error);
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    if ([self isPushFromEMMA: userInfo]) {
        [EMMA handlePush: userInfo];
    }

    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionBadge);
}

- (void) userNotificationCenter:(UNUserNotificationCenter *)center
 didReceiveNotificationResponse:(UNNotificationResponse *)response
          withCompletionHandler:(void (^)(void))completionHandler {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if ([self isPushFromEMMA: userInfo]) {
        [EMMA handlePush: userInfo];
    }
    
    completionHandler();
}

#else

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if ([self isPushFromEMMA: userInfo]){
        [EMMA handlePush:userInfo];
    }
    NSLog(@"%@", NSStringFromSelector(_cmd));
    completionHandler(UIBackgroundFetchResultNoData);
}

#endif

-(BOOL) isPushFromEMMA: (NSDictionary*) userInfo {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return [userInfo objectForKey:EMMAPushKey] != nil;
}

-(EMMAPlugin *) getPlugin {
    return  [self.viewController getCommandInstance:PLUGIN_NAME];
}

@end
