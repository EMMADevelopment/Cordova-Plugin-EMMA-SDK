//
//  EMMADefines.h
//  EMMA
//
//  Created by Jaume Cornadó Panadés on 11/11/14.
//  Copyright (c) 2017 EMMA SOLUTIONS SL. All rights reserved.
//
#import <UIKit/UIKit.h>

@class EMMACampaign;
@class EMMANativeAd;
@class EMMACoupon;
@class EMMAInstallAttribution;
@class EMMAPush;


#ifndef EMMADefines_h
#define EMMADefines_h

typedef void(^imageCompletionBlock)(UIImage *image);

/**
 StartView Options
 */
typedef NS_OPTIONS(NSUInteger, EMMAStartViewOptions) {
	kStartViewManualCall = (1 << 0),
    kStartViewOpenLinksInSafari = (1 << 1)
};

typedef NS_OPTIONS(NSUInteger, EMMAAdBallOptions) {
    kAdBallNotInBackground = (1 << 0),
    kAdBallManualCall = (1 << 1)
};

typedef NS_ENUM(NSInteger, InAppType){
    Startview,
    Adball,
    Strip,
    Banner,
    PromoTab,
    Coupons,
    RedeemCoupon,
    CancelCoupon,
    CouponValidRedeems,
    NativeAd
};

typedef NS_OPTIONS(NSUInteger, EMMACampaignType) {
    kCampaignPush = 1,
    kCampaignStartView = 2,
    kCampaignTabBar = 3,
    kCampaignAdBall = 4,
    kCampaignBanner = 5,
    kCampaignStrip = 6,
    kCampaignCoupon = 7,
    kCampaignNativeAd = 8,
};

typedef NS_OPTIONS(NSUInteger, EMMAPushSystemOptions) {
    kPushSystemDisableAlert = (1 << 0)
};

typedef NS_OPTIONS(NSUInteger, EMMAPushType) {
    kPushTypePressedOnShutdown = 0,
    kPushTypePressedOnBackground = 1,
    kPushTypeNotPressedOnShutdown = 2,
    kPushTypeNotPressedOnBackground = 3,
    kPushTypeOnActive = 4
};

/** Block definition for recovering the pushtags */
typedef void(^EMMAPushTagBlock)(NSString* pushTag, NSString* pushTagID);

/** Block definition for recovering userInfo */
typedef void(^EMMAGetUserInfoBlock)(NSDictionary* userInfo);

/** Block definition for recovering userId */
typedef void(^EMMAGetUserIdBlock)(NSString* userId);

/** Block definition for banner show **/
typedef void(^EMMAOnBannerShow)(BOOL isShown);

/** Block definition for recovering coupons */
typedef void(^EMMAGetCouponsBlock)(NSDictionary* couponsResponse);


/**
 This protocol defines the delegate methods of the push system
 */
@protocol EMMAPushDelegate <NSObject>
/**
 Sends the push campaign  to the delegate when a push is opened
 
 @param pushTag the push tag on the push message
 */
-(void)onPushOpen:(EMMAPush*)push;
@end

/**
 *  This protocol defines the delegate methods of the StartView
 */
@protocol EMMAStartViewDelegate <NSObject>

@optional

/**
 *  Called when a user navigates through the StartView
 *
 *  @param url the url loaded in StartView
 */
-(void) onPresented;

@end

@protocol EMMAInAppMessageDelegate <NSObject>
@required
-(void) onShown:(EMMACampaign*) campaign;
-(void) onHide:(EMMACampaign*) campaign;
-(void) onClose:(EMMACampaign*) campaign;
@optional
-(void) onReceived:(EMMANativeAd*) nativeAd;
-(void) onBatchNativeAdReceived:(NSArray<EMMANativeAd*>*) nativeAds;
@end

@protocol EMMACouponDelegate <NSObject>
@required
-(void) onCouponsReceived: (NSArray<EMMACoupon*>*) coupons;
-(void) onCouponsFailure;
@optional
-(void) onCouponValidRedeemsReceived:(int) validRedeems;
@end

@protocol EMMAInstallAttributionDelegate <NSObject>
@required
-(void) onAttributionReceived:(EMMAInstallAttribution*) attribution;
@end

@protocol EMMARequestDelegate <NSObject>
@required
-(void) onStarted:(NSString*) id;
-(void) onSuccess:(NSString*) id containsData:(BOOL) data;
-(void) onFailed:(NSString*) id;
@end


#endif
