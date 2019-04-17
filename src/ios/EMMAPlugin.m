#import <Cordova/CDV.h>
#import "EMMAPlugin.h"
#import "AppDelegate.h"

@interface EMMAPlugin()
@property (nonatomic, strong) NSDictionary* inAppTypes;
@property (nonatomic, copy) NSString *nativeAdCallbackId;
@end

@implementation EMMAPlugin

@synthesize nativeAdCallbackId;

enum ActionTypes {
    Login, Register
};

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
    
    NSDictionary *attributes = [eventMessage objectForKey:eventAttributesArg];
    
    EMMAEventRequest *request = [EMMAEventRequest new];
    
    if (attributes && [attributes count] > 0) {
        [request setAttributes:attributes];
    }
    
    [EMMA trackEvent:request];
}

-(void)trackUserExtras:(CDVInvokedUrlCommand*)command {
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
    
    [EMMA trackExtraUserInfo:userExtrasMsg];
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
        [EMMA loginUser:userId forMail:email];
    } else {
        [EMMA registerUser:userId forMail:email];
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
    
    id _currencyCode = [startOrderMsg objectForKey:orderCurrencyCodeArg];
    if (_currencyCode) {
        [EMMA setCurrencyCode:_currencyCode];
    } else {
        [EMMA setCurrencyCode:@"EUR"];
    }
    
    NSString* coupon = [startOrderMsg objectForKey:orderTotalPriceArg];
    NSString* customerId = [startOrderMsg objectForKey:orderCustomerIdArg];
    
    id _extras = [startOrderMsg objectForKey:extrasArg];
    NSDictionary * extras = nil;
    if (_extras &&  [extras isKindOfClass: [NSDictionary class]]) {
        extras = (NSDictionary*) _extras;
    }
    
    [EMMA startOrder:orderId customerId:customerId totalPrice:totalPrice coupon:coupon extras:extras];
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
    
    [EMMA addProduct:productId name:productName qty:quantity price:price extras:extras];
}

- (void)trackOrder:(CDVInvokedUrlCommand *)command {
    [EMMA trackOrder];
}

- (void)cancelOrder:(CDVInvokedUrlCommand *)command {
    NSString* orderId = [command argumentAtIndex:0 withDefault: nil];
    if (!orderId || [orderId isEqualToString:@""]) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString: CONCAT(orderIdArg, mandatoryNotEmpty)];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }
    
    [EMMA cancelOrder:orderId];
}

- (void) enableUserTracking {
    [EMMA enableUserTracking];
}

- (void) disableUserTracking:(CDVInvokedUrlCommand *)command  {
    BOOL deleteUser = [[command argumentAtIndex:0 withDefault: nil] boolValue];
    [EMMA disableUserTracking:deleteUser];
}

- (void) isUserTrackingEnabled:(CDVInvokedUrlCommand *)command {
    BOOL userTracking = [EMMA isUserTrackingEnabled];
    
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