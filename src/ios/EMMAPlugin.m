#import <Cordova/CDV.h>
#import "EMMAPlugin.h"
#import "AppDelegate.h"

@interface EMMAPlugin()
@property (nonatomic, strong) NSDictionary* inAppTypes;
@property (nonatomic, copy) NSString *nativeAdCallbackId;
@end

@implementation EMMAPlugin

@synthesize nativeAdCallbackId;

- (void)pluginInitialize {
    self.inAppTypes = @{
                       inAppStartview: @(Startview),
                       inAppAdball: @(Adball),
                       inAppStrip: @(Strip),
                       inAppBanner: @(Banner),
                       inAppNativeAd: @(NativeAd)
                       };
}

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
                                                    messageAsString: CONCAT(sessionKeyArg, mandatoryNotEmpty)];
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
}

-(void)inAppMessage: (CDVInvokedUrlCommand*)command {
    NSDictionary * message = [command argumentAtIndex:0 withDefault:nil];
    
    if (!message) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString: invalidMethodArguments];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }
    
    NSString * type = [message objectForKey:inAppTypeArg];
    if (!type || [type isEqualToString:@""]) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString: CONCAT(inAppTypeArg, mandatoryNotEmpty)];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }
    
    NSNumber *requestType = [self.inAppTypes objectForKey: type];

    if ([requestType integerValue] == NativeAd) {
        
        BOOL batch = [[message objectForKey:inAppBatchArg] boolValue];
        NSString *templateId = [message objectForKey:inAppTemplateIdArg];
        
        if (!templateId || [templateId isEqualToString:@""]) {
            CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                        messageAsString: CONCAT(inAppTemplateIdArg, mandatoryNotEmpty)];
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            return;
        }
        
        self.nativeAdCallbackId = command.callbackId;
        
        EMMANativeAdRequest *request = [EMMANativeAdRequest new];
        [request setIsBatch:batch];
        [request setTemplateId:templateId];
        [EMMA inAppMessage:request withDelegate:self];
        
    } else {
        EMMAInAppRequest *request = [[EMMAInAppRequest alloc] initWithType: [requestType integerValue]];
        [EMMA inAppMessage:request];
    }
    
}

-(NSArray*) processNativeAd:(NSArray*) nativeAds {
    NSMutableArray *result = [NSMutableArray new];
    for (EMMANativeAd *nativeAd in nativeAds) {
        [result addObject:[self nativeAdToDic:nativeAd]];
    }
    return result;
}

-(NSDictionary*) nativeAdToDic:(EMMANativeAd*) nativeAd {
    return @{
             @"id": [NSNumber numberWithInt:[nativeAd idPromo]],
             @"templateId": [nativeAd nativeAdTemplateId],
             @"times": [NSNumber numberWithLong:[nativeAd times]],
             @"tag": [nativeAd tag],
             @"showOn": [nativeAd openInSafari]? @"browser" : @"inapp",
             @"fields": [nativeAd nativeAdContent]
             };
}

- (void)onClose:(EMMACampaign *)campaign {
}

- (void)onHide:(EMMACampaign *)campaign {
}

- (void)onShown:(EMMACampaign *)campaign {
}

-(void) onReceived:(EMMANativeAd*) nativeAd {
    NSArray *nativeAdArray = [NSArray arrayWithObject:nativeAd];
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                 messageAsArray:[self processNativeAd:nativeAdArray]];
    [self.commandDelegate sendPluginResult:result callbackId:nativeAdCallbackId];
}

-(void) onBatchNativeAdReceived:(NSArray<EMMANativeAd*>*) nativeAds {
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                 messageAsArray:[self processNativeAd:nativeAds]];
    [self.commandDelegate sendPluginResult:result callbackId:nativeAdCallbackId];
}

@end
