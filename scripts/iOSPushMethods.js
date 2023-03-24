var fs = require("fs");
var path = require("path");

function getPushDefineValue(addPush) {
   return isPushToEnable(addPush)?  1 : 0; 
} 

function addPushStatusDefine(pluginHeaderFile, addPush) {
    var currentDefine = /^(\s*)#define PUSH_ENABLED(.*)/m;
    var match = pluginHeaderFile.match(currentDefine);
    var whitespace = match[1];
    var modifiedLine =
      whitespace +
      "#define PUSH_ENABLED " + getPushDefineValue(addPush);
      
    return pluginHeaderFile.replace(
      currentDefine,
      modifiedLine
    );
  }

function readPluginHeaderFile() {
    var target = path.join("plugins", "cordova-plugin-emma-sdk", "src", "ios", "EMMAPlugin.h");
    return fs.readFileSync(target, "utf-8");
}

function getAppName() {
  var config = fs.readFileSync('config.xml').toString();
  var value = config.match(new RegExp('<name(.*?)>(.*?)</name(.*?)>', 'i'));
  if (value && value[2]) {
    return value[2]
  } else {
    return null
  }
}

function writePluginHeaderFile(pluginHeaderFile) {
    var targetRootPlugin = path.join("plugins", "cordova-plugin-emma-sdk", "src", "ios", "EMMAPlugin.h");
    fs.writeFileSync(targetRootPlugin, pluginHeaderFile);
    var appName = getAppName();
    if (!appName) {
      console.log('iOS: Warning: Cannot modify plugin on iOS platform folder');
      return;
    }
    var targetRootPlatform = path.join("platforms", "ios", appName, "Plugins", "cordova-plugin-emma-sdk", "EMMAPlugin.h");
    if (fs.existsSync(targetRootPlatform)) {
      fs.writeFileSync(targetRootPlatform, pluginHeaderFile);
    }
  }

function enableDisablePushMethods(addPush) { 
    var pluginHeaderFile = readPluginHeaderFile();
    pluginHeaderFile = addPushStatusDefine(pluginHeaderFile, addPush);
    writePluginHeaderFile(pluginHeaderFile);
}

function isPushToEnable(addPush) {
    return addPush && (addPush === "true" || addPush === "1" || addPush === "ios");
}

module.exports = function(context) {
    var variables = context.opts.cli_variables;
    var addPush = variables.ADD_PUSH;
    enableDisablePushMethods(addPush);
    console.log("iOS: " + (isPushToEnable(addPush)? "Added": "Discarted") + " push methods");
};