# Changelog

## 1.11.0

- Add new method getInstallAttributionInfo to retrieve install attribution data for iOS and Android.

## 1.10.0

- Update native SDK dependencies: 4.16.0 for iOS and 4.16.+ for Android.
- Add new method setEmail to set user email.
- Add new method setUserProfile to set customerId, email and tags in a single call.
- Add new method trackUserTags to track user tags.
- Add new method trackPurchase to track purchases with products in a single call.
- Add new method unregisterPushSystem to unregister from push notifications.
- Deprecate trackExtraUserInfo method.
- Deprecate startOrder, addProduct and trackOrder methods.
- Remove cancelOrder method.

## 1.9.2

- Update native SDK dependencies: 4.15.7 for Android and 4.15.6 for iOS.

## 1.9.1

- Update iOS SDK dependency to version 4.15.5.

## 1.9.0

- Update native sdk dependencies: added new setUserLanguage method that allows users to manually set the language instead of relying on auto-detection.

## 1.2.1

- Added new methods sendInAppImpression and sendInAppClick to send impression or/and click for nativeAd
- Added new method openNativeAd to execute CTA action (open webview on browser or inapp)

## 1.2.0

- Android X migration
- iOS 14 optimized
- Fixed discrepancies between android and iOS with nativeAd format
- New method to update customer id whitout login or register user event
- Minor fixes and improves
