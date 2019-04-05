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
    argscheck.checkArgs('O', 'startSession', arguments);
    exec(null, null, 'EMMAPlugin', 'startSession', [configuration]);    
};

exports.startPush = function(classToOpen, notificationIcon, color, customAlert) {
    argscheck.checkArgs('*', 'startPush', arguments);
    exec(null, null, 'EMMAPlugin', 'startPush', [classToOpen, notificationIcon, color, customAlert]);
}

exports.trackEvent = function(classToOpen, notificationIcon, color, customAlert) {
    argscheck.checkArgs('*', 'trackEvent', arguments);
    exec(null, null, 'EMMAPlugin', 'trackEvent', [classToOpen, notificationIcon, color, customAlert]);
}

