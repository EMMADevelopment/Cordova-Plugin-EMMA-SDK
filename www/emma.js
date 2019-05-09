var exec = require('cordova/exec'),
    argscheck = require('cordova/argscheck');

/**
 * Method used to notify when the device is ready. Internal use.
 */
document.addEventListener("deviceready", onDeviceReady, false);
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
exports.startSession = function(configuration) {
    argscheck.checkArgs('O', 'EMMAPlugin.startSession', arguments);
    exec(null, null, 'EMMAPlugin', 'startSession', [configuration]);    
};

/**
 * Method to init push system.
 * @param options Object that contains push options. Note that options 
 * is only used for Android.
 */
exports.startPush = function(options) {
    argscheck.checkArgs('O', 'EMMAPlugin.startPush', arguments);
    exec(null, null, 'EMMAPlugin', 'startPush', [options]);
};

/**
 * Method to init location tracking.
 */ 
exports.trackLocation = function() {
    exec(null, null, 'EMMAPlugin', 'trackLocation', []);
};

/**
 * Method to track events.
 * @param eventRequest Object that contains token and attributes. 
 * The attributes are not supported yet. 
 */ 
exports.trackEvent = function(eventRequest) {
    argscheck.checkArgs('O', 'EMMAPlugin.trackEvent', arguments);
    exec(null, null, 'EMMAPlugin', 'trackEvent', [eventRequest]);
};

/**
 * Method to track user tags
 * @param extras key-value object with user extras.
 */ 
exports.trackUserExtraInfo = function(extras) {
    argscheck.checkArgs('O', 'EMMAPlugin.trackUserExtraInfo', arguments);
    exec(null, null, 'EMMAPlugin', 'trackUserExtraInfo', [extras]);
};

/**
 * Method to track login event. 
 * @param login Object with login params userId and/or email.
 */ 
exports.loginUser = function(login) {
    argscheck.checkArgs('O', 'EMMAPlugin.loginUser', arguments);
    exec(null, null, 'EMMAPlugin', 'loginUser', [login]);
};

/**
 * Method to track register event. 
 * @param login Object with register params userId and/or email.
 */ 
exports.registerUser = function(register) {
    argscheck.checkArgs('O', 'EMMAPlugin.registerUser', arguments);
    exec(null, null, 'EMMAPlugin', 'registerUser', [register]);
};

/**
 * Method to start order. 
 * @param order Object with register params userId and/or email.
 */ 
exports.startOrder = function(order) {
    argscheck.checkArgs('O', 'EMMAPlugin.startOrder', arguments);
    exec(null, null, 'EMMAPlugin', 'startOrder', [order]);
};

/**
 * Method to add products to the order. 
 * @param product Object product to add to the order.
 */ 
exports.addProduct = function(product) {
    argscheck.checkArgs('O', 'EMMAPlugin.addProduct', arguments);
    exec(null, null, 'EMMAPlugin', 'addProduct', [product]);
};

/**
 * Method to send the order. 
 */ 
exports.trackOrder = function() {
    exec(null, null, 'EMMAPlugin', 'trackOrder', []);
};

/**
 * Method to cancel order. 
 * @param orderId of order to cancel. 
 */ 
exports.cancelOrder = function(orderId) {
    argscheck.checkArgs('S', 'EMMAPlugin.cancelOrder', arguments);
    exec(null, null, 'EMMAPlugin', 'cancelOrder', [orderId]);
};

/**
 * Method to check active communications.
 * @param message Object that contains message params.
 */
exports.inAppMessage = function(message) {
    exec(message.inAppResponse, null, 'EMMAPlugin', 'inAppMessage', [message]);
};

/**
 * Method to enable user tracking.
 */
exports.enableUserTracking = function() {
    exec(null, null, 'EMMAPlugin', 'enableUserTracking', []);
};

/**
 * Method to disable user tracking.
 * @param deleteUser Boolean if true delete user in DDBB.
 */
exports.disableUserTracking = function(deleteUser) {
    exec(null, null, 'EMMAPlugin', 'disableUserTracking', [deleteUser]);
};

/**
 * Method to check if user tracking is enable
 */
exports.isUserTrackingEnabled = function(cb) {
    exec(cb, null, 'EMMAPlugin', 'isUserTrackingEnabled', []);
};


// Methods for Android Push only. Use this when the app has already installed another push service.

/**
 * Method to refresh token.
 * @param token
 */
exports.onTokenRefresh = function(token) {
    argscheck.checkArgs('S', 'EMMAPlugin.onTokenRefresh', arguments);
    exec(null, null, 'EMMAPlugin', 'onTokenRefresh', [token]);
}

/**
 * Method to send token.
 * @param token
 */
exports.sendPushToken = function(token) {
    argscheck.checkArgs('S', 'EMMAPlugin.onTokenRefresh', arguments);
    exec(null, null, 'EMMAPlugin', 'onTokenRefresh', [token]);
}

/**
 * Method to show notification from EMMA push service.
 * @param notification Object that contains notification data.
 */
exports.handleNotification = function(notification) {
    argscheck.checkArgs('O', 'EMMAPlugin.handleNotification', arguments);
    exec(null, null, 'EMMAPlugin', 'handleNotification', [notification]);
}

