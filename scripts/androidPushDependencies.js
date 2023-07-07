var fs = require('fs');
var path = require('path');

var FIREBASE_VERSION = '20.3.0';
var GSERVICES_PLUGIN_VERSION = '4.3.15';

function readPluginGradleFile() {
  var target = path.join(
    'plugins',
    'cordova-plugin-emma-sdk',
    'src',
    'android',
    'build.gradle'
  );
  return fs.readFileSync(target, 'utf-8');
}

function readPlatformPluginGradleFile(pluginIdLastToken) {
  var target = path.join(
    'platforms',
    'android',
    'cordova-plugin-emma-sdk',
    pluginIdLastToken + '-build.gradle'
  );
  return fs.readFileSync(target, 'utf-8');
}

function addPushClassPath(gradleFile) {
  var match = gradleFile.match(/^(\s*)buildscript {(.*)/m);

  var googlesServicesDependency =
    "    dependencies { \n" +
    "        classpath 'com.google.gms:google-services:" +
    GSERVICES_PLUGIN_VERSION +
    "' \n" + 
    "    }";
  var modifiedLine = match[0] + '\n' + googlesServicesDependency;

  return gradleFile.replace(
    /^(\s*)buildscript {(.*)/m,
    modifiedLine
  );
}

function addRepos(gradleFile) {
  var match = gradleFile.match(/^(\s*)mavenCentral\(\)/m);
  var whitespace = match[1];

  var emmaRepo = whitespace + "maven { url 'https://repo.emma.io/emma' }";
  var modifiedLine = match[0] + '\n' + emmaRepo;

  return gradleFile.replace(/^(\s*)mavenCentral\(\)/m, modifiedLine);
}

function addFirebaseDependency(gradleFile) {
  var match = gradleFile.match(/^(\s*)implementation 'io.emma:eMMaSDK:(.*)/m);
  var whitespace = match[1];
  var firebaseDependency =
    whitespace +
    "implementation 'com.google.firebase:firebase-messaging:" +
    FIREBASE_VERSION +
    "'";
  var modifiedLine = firebaseDependency + '\n' + match[0];
  return gradleFile.replace(
    /^(\s*)implementation 'io.emma:eMMaSDK:(.*)/m,
    modifiedLine
  );
}

function addApplyGoogleServicePlugin(gradleFile) {
  return (
    gradleFile +
    '\n\n' +
    'ext.postBuildExtras = {' +
    '\n' +
    "  if (project.extensions.findByName('googleServices') == null) {\n" +
    '      apply plugin: com.google.gms.googleservices.GoogleServicesPlugin\n' +
    '  }\n' +
    '}\n'
  );
}

function writeRootGradleFile(contents) {
  var target = path.join(
    'plugins',
    'cordova-plugin-emma-sdk',
    'src',
    'android',
    'build.gradle'
  );
  fs.writeFileSync(target, contents);
}

function writeRootPlatformGradleFile(pluginIdLastToken, contents) {
  var target = path.join(
    'platforms',
    'android',
    'cordova-plugin-emma-sdk',
    pluginIdLastToken + '-build.gradle'
  );
  fs.writeFileSync(target, contents);
}

function addPushDependencies(gradleFile) {
  gradleFile = addPushClassPath(gradleFile);
  gradleFile = addRepos(gradleFile);
  gradleFile = addFirebaseDependency(gradleFile);
  return addApplyGoogleServicePlugin(gradleFile);
}

function isPushToEnable(addPush) {
  return addPush && (addPush === 'true' || addPush === '1' || addPush === 'android');
}

function getPluginId(context) {
  var configXml = path.join(context.opts.projectRoot, 'config.xml');
  var rawConfig = fs.readFileSync(configXml, 'utf-8');
  var match = /^<widget.+id="([a-zA-Z0-9_\.]+)".+?>$/gm.exec(rawConfig);
  if (!match || match.length != 2) throw new Error('cannot obtain plugin id');
  return match[1];
}

function addPushDependenciesToPlugin() {
  var pluginGradleFile = readPluginGradleFile();
  pluginGradleFile = addPushDependencies(pluginGradleFile);
  writeRootGradleFile(pluginGradleFile);
}

function addPushDependenciesToPlatformGradleFile(pluginIdLastToken) {
  var pluginGradleFile = readPlatformPluginGradleFile(pluginIdLastToken);
  pluginGradleFile = addPushDependencies(pluginGradleFile);
  writeRootPlatformGradleFile(pluginIdLastToken, pluginGradleFile);
}

function areAddedPushDependenciesToPlatformGradleFile(pluginIdLastToken) {
  try {
    var gradleFile = readPlatformPluginGradleFile(pluginIdLastToken);
    return (
      gradleFile.match(
        /^(\s*)implementation 'com.google.firebase:firebase-messaging:(.*)/m
      ) !== null
    );
  } catch (e) {
    return false;
  }
}

function directoryExists(dirPath) {
  try {
    return fs.statSync(path.resolve(dirPath)).isDirectory();
  } catch (e) {
    return false;
  }
}

module.exports = function (context) {
  var variables = context.opts.cli_variables;
  FIREBASE_VERSION = variables.FIREBASE_VERSION || FIREBASE_VERSION;
  GSERVICES_PLUGIN_VERSION =
    variables.GSERVICES_PLUGIN_VERSION || GSERVICES_PLUGIN_VERSION;
  if (isPushToEnable(variables.ADD_PUSH)) {
    addPushDependenciesToPlugin();
    var platforms = context.opts.cordova.platforms;
    if (
      platforms.indexOf('android') !== -1 &&
      directoryExists('platforms/android')
    ) {
      var pluginIdLastParts = getPluginId(context).split('.');
      var pluginIdLastToken = pluginIdLastParts[pluginIdLastParts.length - 1];
      if (!areAddedPushDependenciesToPlatformGradleFile(pluginIdLastToken)) {
        addPushDependenciesToPlatformGradleFile(pluginIdLastToken);
      } else {
        console.log('Android: Dependencies in platform already added.');
      }
    } else {
      console.log(
        'Android: Platform not added. Skip platform plugin dependencies.'
      );
    }
    console.log('Android: Added push dependencies');
    return;
  }
  console.log('Android: Discarted push dependencies');
};
