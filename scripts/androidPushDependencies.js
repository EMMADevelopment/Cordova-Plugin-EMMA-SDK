var fs = require("fs");
var path = require("path");

var FIREBASE_VERSION = "17.4.0";
var GSERVICES_PLUGIN_VERSION = "4.2.0";


function readPluginGradle() {
  var target = path.join("plugins", "cordova-plugin-emma-sdk", "src", "android", "build.gradle");
  return fs.readFileSync(target, "utf-8");
}

function addPushClassPath(gradleFile) {
  var match = gradleFile.match(/^(\s*)classpath 'com.android.tools.build(.*)/m);
  var whitespace = match[1];
  
  var googlePlayDependency = whitespace + "classpath 'com.google.gms:google-services:" + GSERVICES_PLUGIN_VERSION + "'";
  var modifiedLine = match[0] + "\n" + googlePlayDependency;

  return gradleFile.replace(/^(\s*)classpath 'com.android.tools.build(.*)/m, modifiedLine);
}

function addRepos(gradleFile) {
  var match = gradleFile.match(/^(\s*)jcenter\(\)/m);
  var whitespace = match[1];

  var emmaRepo = whitespace + "maven { url 'https://repo.emma.io/emma' }";
  var modifiedLine = match[0] + "\n" + emmaRepo;

  return gradleFile.replace(/^(\s*)jcenter\(\)/m, modifiedLine);
}

function addFirebaseDependency(gradleFile) {
  var match = gradleFile.match(/^(\s*)implementation 'io.emma:eMMaSDK:(.*)/m);
  var whitespace = match[1];
  var firebaseDependency =
    whitespace +
    "implementation 'com.google.firebase:firebase-messaging:" + FIREBASE_VERSION + "'";
  var modifiedLine = firebaseDependency + "\n" + match[0];
  return gradleFile.replace(
    /^(\s*)implementation 'io.emma:eMMaSDK:(.*)/m,
    modifiedLine
  );
}

function addApplyGoogleServicePlugin(gradleFile) {
  return gradleFile 
  + "\n\n" + 
  "ext.postBuildExtras = {" + "\n" +
  "  if (project.extensions.findByName('googleServices') == null) {\n" +
  "      apply plugin: com.google.gms.googleservices.GoogleServicesPlugin\n" +
  "  }\n" +
  "}\n" ;
}

function writeRootGradleFile(contents) {
  var target = path.join("plugins", "cordova-plugin-emma-sdk", "src", "android", "build.gradle");
  fs.writeFileSync(target, contents);
}

function addPushDependencies() {
    var gradleFile = readPluginGradle();
    gradleFile = addPushClassPath(gradleFile);
    gradleFile = addRepos(gradleFile);
    gradleFile = addFirebaseDependency(gradleFile);
    gradleFile = addApplyGoogleServicePlugin(gradleFile);
    writeRootGradleFile(gradleFile);
}

function isPushToEnable(addPush) {
    return addPush && (addPush === "true" || addPush === "1");
}

module.exports = function(context) {
    var variables = context.opts.cli_variables;
    FIREBASE_VERSION = variables.FIREBASE_VERSION || FIREBASE_VERSION;
    GSERVICES_PLUGIN_VERSION = variables.GSERVICES_PLUGIN_VERSION || GSERVICES_PLUGIN_VERSION;
    if (isPushToEnable(variables.ADD_PUSH)) {
        addPushDependencies();
        console.log("Android: Added push dependencies");
        return;
    }
    console.log("Android: Discarted push dependencies");
};