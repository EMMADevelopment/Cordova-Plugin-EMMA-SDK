var exec = require('cordova/exec'),
  argscheck = require('cordova/argscheck');

/* Stores the device Id once it has been obtained */
var deviceId = null;

/**
 * Method used to notify when the device is ready. Internal use.
 */
document.addEventListener('deviceready', onDeviceReady, false);
/**
 * Method used to notify when the device Id is obtained and return it syncronously
 */
document.addEventListener(
  'syncDeviceId',
  function (event) {
    if ('deviceId' in event) {
      deviceId = event.deviceId;
    }
  },
  false
);
function onDeviceReady() {
  exec(null, null, 'EMMAPlugin', 'onDeviceReady', []);
}

/**
 * Inapp types object used for call a inAppMessage type.
 */
exports.inAppTypes = Object.freeze({
  STARTVIEW: 'startview',
  ADBALL: 'adball',
  STRIP: 'strip',
  BANNER: 'banner', //only Android
  NATIVEAD: 'nativeAd'
});

/**
 * Method to init SDK. Starts session. This is the first method that has to be called.
 */
exports.startSession = function (configuration) {
  argscheck.checkArgs('O', 'EMMAPlugin.startSession', arguments);
  exec(null, null, 'EMMAPlugin', 'startSession', [configuration]);
};

/**
 * Method to init push system.
 * @param options Object that contains push options. Note that options
 * is only used for Android.
 */
exports.startPush = function (options) {
  argscheck.checkArgs('O', 'EMMAPlugin.startPush', arguments);
  exec(null, null, 'EMMAPlugin', 'startPush', [options]);
};

/**
 * Method to init location tracking.
 */

exports.trackLocation = function () {
  exec(null, null, 'EMMAPlugin', 'trackLocation', []);
};

/**
 * Method to track events.
 * @param eventRequest Object that contains token and attributes.
 * The attributes are not supported yet.
 */

exports.trackEvent = function (eventRequest) {
  argscheck.checkArgs('O', 'EMMAPlugin.trackEvent', arguments);
  exec(null, null, 'EMMAPlugin', 'trackEvent', [eventRequest]);
};

/**
 * Method to track user tags
 * @param extras key-value object with user extras.
 */

exports.trackUserExtraInfo = function (extras) {
  argscheck.checkArgs('O', 'EMMAPlugin.trackUserExtraInfo', arguments);
  exec(null, null, 'EMMAPlugin', 'trackUserExtraInfo', [extras]);
};

/**
 * Method to track login event.
 * @param login Object with login params userId and/or email.
 */

exports.loginUser = function (login) {
  argscheck.checkArgs('O', 'EMMAPlugin.loginUser', arguments);
  exec(null, null, 'EMMAPlugin', 'loginUser', [login]);
};

/**
 * Method to track register event.
 * @param login Object with register params userId and/or email.
 */

exports.registerUser = function (register) {
  argscheck.checkArgs('O', 'EMMAPlugin.registerUser', arguments);
  exec(null, null, 'EMMAPlugin', 'registerUser', [register]);
};

/**
 * Method to start order.
 * @param order Object with register params userId and/or email.
 */

exports.startOrder = function (order) {
  argscheck.checkArgs('O', 'EMMAPlugin.startOrder', arguments);
  exec(null, null, 'EMMAPlugin', 'startOrder', [order]);
};

/**
 * Method to add products to the order.
 * @param product Object product to add to the order.
 */

exports.addProduct = function (product) {
  argscheck.checkArgs('O', 'EMMAPlugin.addProduct', arguments);
  exec(null, null, 'EMMAPlugin', 'addProduct', [product]);
};

/**
 * Method to send the order.
 */

exports.trackOrder = function () {
  exec(null, null, 'EMMAPlugin', 'trackOrder', []);
};

/**
 * Method to cancel order.
 * @param orderId of order to cancel.
 */

exports.cancelOrder = function (orderId) {
  argscheck.checkArgs('S', 'EMMAPlugin.cancelOrder', arguments);
  exec(null, null, 'EMMAPlugin', 'cancelOrder', [orderId]);
};

/**
 * Method to check active communications.
 * @param message Object that contains message params.
 */
exports.inAppMessage = function (message) {
  exec(message.inAppResponse, null, 'EMMAPlugin', 'inAppMessage', [message]);
};

/**
 * Method to enable user tracking.
 */
exports.enableUserTracking = function () {
  exec(null, null, 'EMMAPlugin', 'enableUserTracking', []);
};

/**
 * Method to disable user tracking.
 * @param deleteUser Boolean if true delete user in DDBB.
 */
exports.disableUserTracking = function (deleteUser) {
  exec(null, null, 'EMMAPlugin', 'disableUserTracking', [deleteUser]);
};

/**
 * Method to check if user tracking is enable
 * 
 * Callback returns true or false.
 */
exports.isUserTrackingEnabled = function (cb) {
  exec(cb, null, 'EMMAPlugin', 'isUserTrackingEnabled', []);
};

// Methods for Android Push only. Use this when the app has already installed another push service.

/**
 * Method to refresh token.
 * @param token
 */
exports.onTokenRefresh = function (token) {
  argscheck.checkArgs('S', 'EMMAPlugin.onTokenRefresh', arguments);
  exec(null, null, 'EMMAPlugin', 'onTokenRefresh', [token]);
};

/**
 * Method to send token.
 * @param token
 */
exports.sendPushToken = function (token) {
  argscheck.checkArgs('S', 'EMMAPlugin.onTokenRefresh', arguments);
  exec(null, null, 'EMMAPlugin', 'onTokenRefresh', [token]);
};

/**
 * Method to show notification from EMMA push service.
 * @param notification Object that contains notification data.
 */
exports.handleNotification = function (notification) {
  argscheck.checkArgs('O', 'EMMAPlugin.handleNotification', arguments);
  exec(null, null, 'EMMAPlugin', 'handleNotification', [notification]);
};

/**
 * Method to obtain device Id synchronously.
 *
 * NOTE: Internaly device Id is obtained asynchronously, this method can
 * return null value if it is done soon after start session.
 * To obtain the deviceId async, you can use the event "onDeviceId".
 *
 * @return The device Id or null.
 */
exports.getSyncDeviceId = function () {
  return deviceId;
};

/**
 * This method allows add client id without use login and register event.
 * Method added in version 4.8.0.
 * @param customerId
 */
exports.setCustomerId = function (customerId) {
  argscheck.checkArgs('S', 'EMMAPlugin.setCustomerId', arguments);
  exec(null, null, 'EMMAPlugin', 'setCustomerId', [customerId]);
};

/**
 * ONLY IOS.
 *
 * This method allows request permissions to obtain idfa identifier
 * Method added in version 4.8.0.
 */
exports.requestTrackingWithIdfa = function () {
  exec(null, null, 'EMMAPlugin', 'requestTrackingWithIdfa', []);
};

/**
 * Sends impression associated with inapp campaign. This method is mainly used to send native Ad impressions.
 * Formats startview, banner, adball send impression automatically
 *
 * @param inAppType The inapp type
 * @param campaignId The campaign identifier
 */
exports.sendInAppImpression = function (inAppType, campaignId) {
  argscheck.checkArgs('SN', 'EMMAPlugin.sendInAppImpression', arguments);
  exec(null, null, 'EMMAPlugin', 'sendInAppImpression', [
    { type: inAppType, campaignId }
  ]);
};

/**
 * Sends click associated with inapp campaign. This method is mainly used to send native Ad impressions.
 * Formats startview, banner, adball send impression automatically
 *
 * @param inAppType The inapp type
 * @param campaignId The campaign identifier
 */
exports.sendInAppClick = function (inAppType, campaignId) {
  argscheck.checkArgs('SN', 'EMMAPlugin.sendInAppClick', arguments);
  exec(null, null, 'EMMAPlugin', 'sendInAppClick', [
    { type: inAppType, campaignId }
  ]);
};

/**
 * Opens native ad CTA inapp or outapp. This method track native ad click automatically. It is not necessary call to sendInAppClick method.
 *
 * @param id The native ad id
 * @param cta The native ad cta
 * @param showOn Open the cta on browser or inapp
 */
exports.openNativeAd = function (id, cta, showOn) {
  argscheck.checkArgs('NSS', 'EMMAPlugin.openNativeAd', arguments);
  exec(null, null, 'EMMAPlugin', 'openNativeAd', [{ id, cta, showOn }]);
};

/**
 * Process the link and sends the click event to EMMA.
 *
 * @param link The powlink that opened the app.
 */
exports.handleLink = function (link) {
  argscheck.checkArgs('S', 'EMMAPlugin.handleLink', arguments);
  exec(null, null, 'EMMAPlugin', 'handleLink', [link]);
};


/**
 * ONLY ANDROID.
 * 
 * Method for checking if Android notifications are enabled.
 *
 * Callback returns true or false.
 */
exports.areNotificationsEnabled = function (cb) {
  argscheck.checkArgs('F', 'EMMAPlugin.areNotificationsEnabled', arguments);
  exec(cb, null, 'EMMAPlugin', 'areNotificationsEnabled', []);
};


/**
 * ONLY ANDROID.
 * 
 * Method for requesting Android 13 notifications permissions.
 * 
 * Callback returns permissions status.
 * 
 * 0 = Granted, 1 = Denied, 2 = ShouldPermissionRationale, 3 = Unsupported.
 */
exports.requestNotificationsPermission = function(cb) {
  argscheck.checkArgs('F', 'EMMAPlugin.requestNotificationsPermission', arguments);
  exec(cb, null, 'EMMAPlugin', 'requestNotificationsPermission', []);
};
