var exec = require('cordova/exec'),
    argscheck = require('cordova/argscheck');

let errors = Object.freeze({
    INVALID_ARGUMENT: "Invalid arguments"
});

let printError = function(message) {
    console.error(message);
};

let print = function(message) {
    console.debug(message);
};

exports.startSession = function(configuration) {
    argscheck.checkArgs('O', 'EMMAPlugin.startSession', arguments);
    exec(null, null, 'EMMAPlugin', 'startSession', [configuration]);    
};

exports.startPush = function(options) {
    argscheck.checkArgs('O', 'EMMAPlugin.startPush', arguments);
    exec(null, null, 'EMMAPlugin', 'startPush', [options]);
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

exports.checkForRichPush = function() {
    exec(null, null, 'EMMAPlugin', 'checkForRichPush', []);
}