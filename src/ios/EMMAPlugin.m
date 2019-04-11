#import <Cordova/CDV.h>
#import "EMMAPlugin.h"
#import <EMMA_iOS/EMMA_iOS.h>
#import "AppDelegate.h"


@implementation EMMAPlugin

- (void) startSession:(CDVInvokedUrlCommand *)command {
    NSDictionary* configurationArgs = [command argumentAtIndex:0 withDefault: nil];
    
    if (!configurationArgs) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString: invalidMethodArguments];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }
    
    NSString *sessionKey = [configurationArgs objectForKey:sessionKeyArg];
    if (!sessionKey || [sessionKey isEqualToString:@""]) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString: mandatoryNotEmpty];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }
    
    EMMAConfiguration * configuration = [EMMAConfiguration new];
    configuration.sessionKey = sessionKey;
    configuration.debugEnabled = [[configurationArgs objectForKey:debugArg] boolValue];
    
    NSArray *customPowlinkDomains = [configurationArgs objectForKey:customShortPowlinkDomainsArg];
    if (customPowlinkDomains && [customPowlinkDomains count] > 0) {
        configuration.customPowlinkDomains = customPowlinkDomains;
    }
    
    NSArray * shortPowlinkDomains = [configurationArgs objectForKey:customShortPowlinkDomainsArg];
    if (shortPowlinkDomains && [shortPowlinkDomains count] > 0) {
        configuration.shortPowlinkDomains = shortPowlinkDomains;
    }
    
    int queueTime = [[configurationArgs objectForKey:queueTimeArg] intValue];
    if (queueTime > minQueueTime) {
        configuration.queueTime = queueTime;
    }
    
    NSString *urlApi = [configurationArgs objectForKey:apiUrlArg];
    if (urlApi && ![urlApi isEqualToString:@""]) {
        configuration.urlBase = urlApi;
    }

    [EMMA startSessionWithConfiguration:configuration];
}

- (void)startPush:(CDVInvokedUrlCommand*)command {
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    [EMMA setPushNotificationsDelegate: _pushDelegate];
#endif
    
    [EMMA startPushSystem];
    
    id<UNUserNotificationCenterDelegate> delegado = [[UNUserNotificationCenter currentNotificationCenter] delegate];
    NSLog(@"Delegadp %@", delegado);
}


@end