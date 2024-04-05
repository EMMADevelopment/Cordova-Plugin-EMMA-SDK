#import <Cordova/CDV.h>
#import "EMMAPlugin.h"
#import "AppDelegate.h"

@interface EMMAPlugin()
@property (nonatomic, strong) NSDictionary* inAppTypes;
@property (nonatomic, copy) NSString *nativeAdCallbackId;
@property (nonatomic, strong) NSURL *pendingDeepLink;
@property BOOL deviceReady;
@end

@implementation EMMAPlugin

@synthesize nativeAdCallbackId;

enum ActionTypes {
    Login, Register
};


- (void)pluginInitialize {
    [super pluginInitialize];

    self.inAppTypes = @{
                       inAppStartview: @(Startview),
                       inAppAdball: @(Adball),
                       inAppStrip: @(Strip),
                       inAppBanner: @(Banner),
                       inAppNativeAd: @(NativeAd)
                       };

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onLinkReceivedNotification:) name:EMMALinkNotification object:nil];
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

    id skanAttribution = [configurationArgs objectForKey:skanAttributionArg];
    if (skanAttribution) {
        configuration.skanAttribution = [skanAttribution boolValue];
    }
    
    id skanCustomManagementAttribution = [configurationArgs objectForKey:skanCustomManagementAttributionArg];
    if (skanCustomManagementAttribution) {
        configuration.skanCustomManagementAttribution = [skanCustomManagementAttribution boolValue];
    }

    [EMMALegacy startSessionWithConfiguration:configuration];
    [self onDeviceId];
}

-(void) setNotificationDelegate:(id<UNUserNotificationCenterDelegate>)delegate {
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 && PUSH_ENABLED == 1
    if (delegate) {
        self.pushDelegate = delegate;
        [[UNUserNotificationCenter currentNotificationCenter] setDelegate:delegate];
    }
#endif
}

- (void)startPush:(CDVInvokedUrlCommand*)command {
#if PUSH_ENABLED == 1
    if (_pushDelegate) {
        [EMMALegacy setPushNotificationsDelegate:_pushDelegate];
    }
    [EMMALegacy startPushSystem];
#endif
}

- (void)trackLocation:(CDVInvokedUrlCommand *)command {
    [EMMALegacy trackLocation];
}

-(void) trackEvent: (CDVInvokedUrlCommand*)command {
    NSDictionary* eventMessage = [command argumentAtIndex:0 withDefault: nil];

    if (!eventMessage) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString: invalidMethodArguments];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }

    NSString *token = [eventMessage objectForKey:eventTokenArg];
    if (!token || [token isEqualToString:@""]) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString: CONCAT(eventTokenArg, mandatoryNotEmpty)];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }

    [self.commandDelegate runInBackground:^{
        NSDictionary *attributes = [eventMessage objectForKey:eventAttributesArg];

        EMMAEventRequest *request = [[EMMAEventRequest alloc] initWithToken:token];

        if (attributes && [attributes count] > 0) {
            [request setAttributes:attributes];
        }

        [EMMALegacy trackEvent:request];
    }];
}

-(void)trackUserExtraInfo:(CDVInvokedUrlCommand*)command {
    NSDictionary* userExtrasMsg = [command argumentAtIndex:0 withDefault: nil];

    if (!userExtrasMsg) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString: invalidMethodArguments];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }

    if ([userExtrasMsg count] == 0) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString: CONCAT(@"User extras", mandatoryNotEmpty)];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }

    [self.commandDelegate runInBackground:^{
        [EMMALegacy trackExtraUserInfo:userExtrasMsg];
    }];
}

- (void)loginUser:(CDVInvokedUrlCommand *)command {
    [self loginRegisterWithType:command withType:Login];
}

- (void)registerUser:(CDVInvokedUrlCommand *)command{
    [self loginRegisterWithType:command withType:Register];
}

- (void)loginRegisterWithType:(CDVInvokedUrlCommand *)command withType: (enum ActionTypes) type {
    NSDictionary* loginRegisterMessage = [command argumentAtIndex:0 withDefault: nil];

    if (!loginRegisterMessage) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString: invalidMethodArguments];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }

    NSString *userId = [loginRegisterMessage objectForKey:userIdArg];
    NSString *email = [loginRegisterMessage objectForKey:emailArg];

    if (type == Login) {
        [EMMALegacy loginUser:userId forMail:email];
    } else {
        [EMMALegacy registerUser:userId forMail:email];
    }
}

- (void)startOrder:(CDVInvokedUrlCommand *)command {
    NSDictionary* startOrderMsg = [command argumentAtIndex:0 withDefault: nil];
    if (!startOrderMsg) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString: invalidMethodArguments];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }

    NSString *orderId = [startOrderMsg objectForKey:orderIdArg];
    if (!orderId || [orderId isEqualToString:@""]) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString: CONCAT(orderIdArg, mandatoryNotEmpty)];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }


    id _totalPrice = [startOrderMsg objectForKey:orderTotalPriceArg];
    if (!_totalPrice) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString: CONCAT(orderTotalPriceArg, mandatoryNotZero)];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }

    float totalPrice = [_totalPrice floatValue];

    NSString* coupon = [startOrderMsg objectForKey:orderCouponArg];
    NSString* customerId = [startOrderMsg objectForKey:orderCustomerIdArg];

    id _extras = [startOrderMsg objectForKey:extrasArg];
    NSDictionary * extras = nil;
    if (_extras &&  [extras isKindOfClass: [NSDictionary class]]) {
        extras = (NSDictionary*) _extras;
    }

    [EMMALegacy startOrder:orderId customerId:customerId totalPrice:totalPrice coupon:coupon extras:extras];
}

- (void)addProduct:(CDVInvokedUrlCommand *)command {
    NSDictionary* addProductMsg = [command argumentAtIndex:0 withDefault: nil];

    NSString *productId = [addProductMsg objectForKey:orderProductIdArg];
    if (!productId || [productId isEqualToString:@""]) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString: CONCAT(orderProductIdArg, mandatoryNotEmpty)];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }

    NSString *productName = [addProductMsg objectForKey:orderProductNameArg];
    if (!productName || [productName isEqualToString:@""]) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString: CONCAT(orderProductNameArg, mandatoryNotEmpty)];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }

    id _quantity = [addProductMsg objectForKey:orderProductQuantityArg];
    if (!_quantity) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString: CONCAT(orderProductQuantityArg, mandatoryNotEmpty)];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }

    int quantity = [_quantity intValue];

    id _price = [addProductMsg objectForKey:orderProductPriceArg];
    if (!_price) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString: CONCAT(orderProductPriceArg, mandatoryNotEmpty)];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }

    float price = [_price floatValue];

    id _extras = [addProductMsg objectForKey:extrasArg];
    NSDictionary * extras = nil;
    if (_extras &&  [extras isKindOfClass: [NSDictionary class]]) {
        extras = (NSDictionary*) _extras;
    }

    [EMMALegacy addProduct:productId name:productName qty:quantity price:price extras:extras];
}

- (void)trackOrder:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        [EMMALegacy trackOrder];
    }];
}

- (void)cancelOrder:(CDVInvokedUrlCommand *)command {
    NSString* orderId = [command argumentAtIndex:0 withDefault: nil];
    if (!orderId || [orderId isEqualToString:@""]) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString: CONCAT(orderIdArg, mandatoryNotEmpty)];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }

    [EMMALegacy cancelOrder:orderId];
}

- (void) enableUserTracking: (CDVInvokedUrlCommand *)command {
    [EMMALegacy enableUserTracking];
}

- (void) disableUserTracking:(CDVInvokedUrlCommand *)command  {
    BOOL deleteUser = [[command argumentAtIndex:0 withDefault: nil] boolValue];
    [EMMALegacy disableUserTracking:deleteUser];
}

- (void) isUserTrackingEnabled:(CDVInvokedUrlCommand *)command {
    BOOL userTracking = [EMMALegacy isUserTrackingEnabled];

    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                  messageAsBool:userTracking];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
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
        [EMMALegacy inAppMessage:request withDelegate:self];

    } else {
        EMMAInAppRequest *request = [[EMMAInAppRequest alloc] initWithType: [requestType integerValue]];
        [EMMALegacy inAppMessage:request];
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
             @"tag": [nativeAd tag] == nil? [NSNull null] : [nativeAd tag],
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

- (void) onReceived:(EMMANativeAd*) nativeAd {
    NSArray *nativeAdArray = [NSArray arrayWithObject:nativeAd];
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                 messageAsArray:[self processNativeAd:nativeAdArray]];
    [self.commandDelegate sendPluginResult:result callbackId:nativeAdCallbackId];
}

- (void) onBatchNativeAdReceived:(NSArray<EMMANativeAd*>*) nativeAds {
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                 messageAsArray:[self processNativeAd:nativeAds]];
    [self.commandDelegate sendPluginResult:result callbackId:nativeAdCallbackId];
}

- (void)onDeviceReady:(CDVInvokedUrlCommand *)command {
    self.deviceReady = YES;
    if (self.pendingDeepLink) {
        [self fireDeepLinkEvent:self.pendingDeepLink];
        self.pendingDeepLink = nil;
    }
}

-(void)fireDeepLinkEvent:(NSURL*) url {
    @try {
        if (url) {
            NSString *js = [NSString stringWithFormat:@"cordova.fireDocumentEvent('onDeepLink', {'url':'%@'});", url.absoluteString];
            [self.commandDelegate evalJs:js];
        }
     } @catch (NSException * ex) {
         NSLog(@"Error opening url: %@", url);
     }
}

- (void)onLinkReceivedNotification:(NSNotification *)notification {
    NSURL * url = notification.object;
    if (self.deviceReady) {
        self.pendingDeepLink = nil;
        [self fireDeepLinkEvent:url];
    } else {
        self.pendingDeepLink = url;
    }
}

- (void)handleOpenURL:(NSNotification*)notification {
    [self onLinkReceivedNotification:notification];
}

-(void) fireDeviceIdEvent:(NSString*)deviceId withEventName:(NSString*)eventName {
    NSString *js = [NSString stringWithFormat:@"cordova.fireDocumentEvent('%@', {'deviceId':'%@'});", eventName, deviceId];
    [self.commandDelegate evalJs:js];
}

- (void)onDeviceId {
    [self.commandDelegate runInBackground:^{
        @try {
            NSString* deviceId = [EMMALegacy deviceId];
            [self fireDeviceIdEvent: deviceId withEventName: @"onDeviceId"];
            [self fireDeviceIdEvent: deviceId withEventName: @"syncDeviceId"];
        } @catch (NSException * ex) {
            NSLog(@"Error obtaining deviceId");
        }
    }];
}

- (void)setCustomerId:(CDVInvokedUrlCommand *)command  {
   NSString* customerId = [command argumentAtIndex:0 withDefault: nil];
   if (customerId)
   [self.commandDelegate runInBackground:^{
       [EMMALegacy setCustomerId:customerId];
   }];
}

- (void)requestTrackingWithIdfa:(CDVInvokedUrlCommand *)command {
    if (@available(iOS 14.0, *)) {
        [EMMALegacy requestTrackingWithIdfa];
    }
}

- (void)sendInAppImpressionOrClick:(CDVInvokedUrlCommand *)command isImpression:(bool) isImpression {
    NSDictionary* inAppEvent = [command argumentAtIndex:0 withDefault: nil];
    NSString * type = [inAppEvent objectForKey:inAppTypeArg];
    if (!type || [type isEqualToString:@""]) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString: CONCAT(inAppTypeArg, mandatoryNotEmpty)];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }

    NSNumber *requestType = [self.inAppTypes objectForKey: type];
    NSNumber *campaignId = [NSNumber numberWithInt:[[inAppEvent objectForKey:inAppCampaignId] intValue]];

    if (!campaignId || campaignId <= 0) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString: CONCAT(inAppCampaignId, mandatoryNotEmpty)];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }

    if (isImpression) {
        [EMMALegacy sendImpression:[requestType integerValue] withId:[NSString stringWithFormat:@"%@", campaignId]];
    } else {
        [EMMALegacy sendClick:[requestType integerValue] withId:[NSString stringWithFormat:@"%@", campaignId]];
    }
}

- (void)sendInAppImpression:(CDVInvokedUrlCommand *)command {
    [self sendInAppImpressionOrClick:command isImpression:true];
}

- (void)sendInAppClick:(CDVInvokedUrlCommand *)command {
    [self sendInAppImpressionOrClick:command isImpression:false];
}

- (void)openNativeAd:(CDVInvokedUrlCommand *)command {
    NSDictionary* nativeAdMessage = [command argumentAtIndex:0 withDefault: nil];
    NSNumber * identifier = [NSNumber numberWithInt:[[nativeAdMessage objectForKey:nativeAdId] intValue]];

    if (!identifier || identifier <= 0) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString: CONCAT(nativeAdId, mandatoryNotEmpty)];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }

    [self.commandDelegate runInBackground:^{
        [EMMALegacy openNativeAd:[NSString stringWithFormat:@"%@", identifier]];
    }];
}

- (void)handleLink:(CDVInvokedUrlCommand *)command {
    NSString* link = [command argumentAtIndex:0 withDefault: nil];
    if (link) {
        @try {
            NSURL* url = [NSURL URLWithString:link];
            [self.commandDelegate runInBackground:^{
                [EMMALegacy handleLink:url];
            }];
        } @catch(NSException *ex) {
            NSLog(@"Invalid URL in method handleLink: %@", link);
        }
    }
}

- (void)areNotificationsEnabled:(CDVInvokedUrlCommand *)command {}
- (void)requestNotificationsPermission:(CDVInvokedUrlCommand *)command {}

- (void) sendPushToken: (CDVInvokedUrlCommand *)command {
    NSString* token = [command argumentAtIndex:0 withDefault: nil];
    [self.commandDelegate runInBackground:^{
        NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:token, eventTokenArg, nil];
        [EMMALegacy trackExtraUserInfo: params];
    }];
}

-(void)updatePostbackConversionValue:(CDVInvokedUrlCommand *)command {
    id _conversionValue = [command argumentAtIndex:0 withDefault: nil];
    if (!_conversionValue) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString: CONCAT(skadConversionValue, mandatoryNotEmpty)];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }
    
    NSInteger conversionValue = [_conversionValue integerValue];
    if (conversionValue < 1 || conversionValue > 63){
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString: CONCAT(skadConversionValue, conversionValueMustBe1And63)];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }
    
    [self.commandDelegate runInBackground:^{
        [EMMALegacy updatePostbackConversionValue:conversionValue completionHandler:nil];
    }];
}

-(void)updatePostbackConversionValueSkad4:(CDVInvokedUrlCommand *)command {
    NSDictionary* conversionModel = [command argumentAtIndex:0 withDefault: nil];
    if (!conversionModel) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString: CONCAT(conversionModelArg, mandatoryNotEmpty)];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }
    
    id _conversionValue = [conversionModel objectForKey:skadConversionValue];
    NSString* coarseValue = [conversionModel objectForKey:skadCoarseValue];
    BOOL lockWindow = [conversionModel objectForKey:skadLockWindow] != nil
        && [conversionModel objectForKey:skadLockWindow] != [NSNull null] ? [conversionModel objectForKey:skadLockWindow] : NO;
    
    if (!_conversionValue) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString: CONCAT(skadConversionValue, mandatoryNotEmpty)];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }
    
    
    NSInteger conversionValue = [_conversionValue integerValue];
    if (conversionValue < 1 || conversionValue > 63){
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString: CONCAT(skadConversionValue, conversionValueMustBe1And63)];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }
    
    NSArray *coarseValidValues = @[@"high", @"medium", @"low"];
    if (![coarseValidValues containsObject:coarseValue]) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString: CONCAT(skadCoarseValue, coarseValueMustBe)];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }
    
    [self.commandDelegate runInBackground:^{
        [EMMALegacy updatePostbackConversionValue:conversionValue coarseValue:coarseValue lockWindow:lockWindow completionHandler:nil];
    }];
}


@end
