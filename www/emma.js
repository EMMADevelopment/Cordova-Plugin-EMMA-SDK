var exec = require('cordova/exec'),
    argscheck = require('cordova/argscheck');

document.addEventListener("deviceready", onDeviceReady, false);

function onDeviceReady() {
    exec(null, null, 'EMMAPlugin', 'onDeviceReady', []); 
}

exports.inAppTypes = Object.freeze({
    STARTVIEW: 'startview',
    ADBALL: 'adball',
    STRIP: 'strip',
    BANNER: 'banner', //only Android
    NATIVEAD: 'nativeAd'
});

exports.startSession = function(configuration) {
    argscheck.checkArgs('O', 'EMMAPlugin.startSession', arguments);
    exec(null, null, 'EMMAPlugin', 'startSession', [configuration]);    
};

exports.startPush = function(options) {
    argscheck.checkArgs('O', 'EMMAPlugin.startPush', arguments);
    exec(null, null, 'EMMAPlugin', 'startPush', [options]);
}

exports.trackLocation = function() {
    exec(null, null, 'EMMAPlugin', 'trackLocation', []);
}

exports.trackEvent = function(eventRequest) {
    argscheck.checkArgs('O', 'EMMAPlugin.trackEvent', arguments);
    exec(null, null, 'EMMAPlugin', 'trackEvent', [eventRequest]);
}

exports.trackUserExtraInfo = function(extras) {
    argscheck.checkArgs('O', 'EMMAPlugin.trackUserExtraInfo', arguments);
    exec(null, null, 'EMMAPlugin', 'trackUserExtraInfo', [extras]);
}

exports.loginUser = function(login) {
    argscheck.checkArgs('O', 'EMMAPlugin.loginUser', arguments);
    exec(null, null, 'EMMAPlugin', 'loginUser', [login]);
}

exports.registerUser = function(register) {
    argscheck.checkArgs('O', 'EMMAPlugin.registerUser', arguments);
    exec(null, null, 'EMMAPlugin', 'registerUser', [register]);
}

exports.startOrder = function(order) {
    argscheck.checkArgs('O', 'EMMAPlugin.startOrder', arguments);
    exec(null, null, 'EMMAPlugin', 'startOrder', [order]);
}

exports.addProduct = function(product) {
    argscheck.checkArgs('O', 'EMMAPlugin.addProduct', arguments);
    exec(null, null, 'EMMAPlugin', 'addProduct', [product]);
}

exports.trackOrder = function() {
    exec(null, null, 'EMMAPlugin', 'trackOrder', []);
}

exports.cancelOrder = function(orderId) {
    argscheck.checkArgs('S', 'EMMAPlugin.cancelOrder', arguments);
    exec(null, null, 'EMMAPlugin', 'cancelOrder', [orderId]);
}

exports.inAppMessage = function(message) {
    exec(message.inAppResponse, null, 'EMMAPlugin', 'inAppMessage', [message]);
}

exports.enableUserTracking = function() {
    exec(null, null, 'EMMAPlugin', 'enableUserTracking', []);
}

exports.disableUserTracking = function(deleteUser) {
    exec(null, null, 'EMMAPlugin', 'disableUserTracking', [deleteUser]);
}

exports.isUserTrackingEnabled = function(cb) {
    exec(cb, null, 'EMMAPlugin', 'isUserTrackingEnabled', [])
}