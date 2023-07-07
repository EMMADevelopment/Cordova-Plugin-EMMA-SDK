<img src="https://emma.io/wp-content/uploads/2019/06/Logotipo-EMMA-Medium.png">

# Cordova EMMA plugin for Android and iOS

[![npm version](https://badge.fury.io/js/cordova-plugin-emma-sdk.svg)](https://badge.fury.io/js/cordova-plugin-emma-sdk)
[![Build Status](https://travis-ci.org/EMMADevelopment/Cordova-Plugin-EMMA-SDK.svg?branch=master)](https://travis-ci.org/EMMADevelopment/Cordova-Plugin-EMMA-SDK)

For any question related to support, you can write to support@emma.io, we will answer as soon as possible.

EMMA website: https://emma.io <br/>
Documentation: https://docs.emma.io <br/>
Developer Documentation: https://developer.emma.io <br />

❗️**Important** Native SDK documentation is conceptually equals to cordova plugin.

## Table of content

- [Native SDK equivalences](#native-sdk-equivalences)
- [Installation](#installation)
- [Setup](#setup)
- [Docs](#docs)
- [Example](#example)

### <a id="native-sdk-equivalences"> Native SDK equivalences

- iOS SDK **v4.12.1**
- Android SDK **v4.12.1**

## <a id="installation">📲Installation

```
$ cordova plugin add cordova-plugin-emma-sdk --variable ADD_PUSH=1
```

## <a id="setup"> 🚀 Setup

**❗️Important**
This setup is focused on an Ionic app.

#### Session key.

> To obtain the key you have to create an EMMA account and create an app. In My account section you will find the key. For more information contact [support](support@emma.io).

First, add to config.xml file:

```xml
<platform  name="android">
	<resource-file src="resources/android/notification/drawable-mdpi-notification.png" target="app/src/main/res/drawable-mdpi/notification.png" />
	<resource-file src="resources/android/notification/drawable-hdpi-notification.png" target="app/src/main/res/drawable-hdpi/notification.png" />
	<resource-file src="resources/android/notification/drawable-xhdpi-notification.png" target="app/src/main/res/drawable-xhdpi/notification.png" />
	<resource-file src="resources/android/notification/drawable-xxhdpi-notification.png" target="app/src/main/res/drawable-xxhdpi/notification.png" />
	<resource-file src="resources/android/notification/drawable-xxxhdpi-notification.png" target="app/src/main/res/drawable-xxxhdpi/notification.png" />

	<resource-file src="google-services.json" target="app/google-services.json" />

	<!-- Optional permissions for location -->
	<config-file parent="/manifest" target="AndroidManifest.xml" xmlns:android="http://schemas.android.com/apk/res/android">
		<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
		<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
	</config-file>

	<config-file parent="/manifest/application" target="AndroidManifest.xml" xmlns:android="http://schemas.android.com/apk/res/android">

		<service android:enabled="true" android:exported="false" android:name="io.emma.android.push.EMMAFcmMessagingService">
			<intent-filter>
				<action android:name="com.google.firebase.MESSAGING_EVENT" />
			</intent-filter>
		</service>

		<activity android:name="io.emma.android.activities.EMMADeepLinkActivity" android:noHistory="true" android:theme="@android:style/Theme.NoDisplay">
			<intent-filter>
				<action android:name="android.intent.action.VIEW" />
				<category android:name="android.intent.category.DEFAULT" />
				<category android:name="android.intent.category.BROWSABLE" />
				<data android:scheme="${scheme}" />
			</intent-filter>
		</activity>

		<meta-data android:name="io.emma.DEEPLINK_OPEN_ACTIVITY" android:value="${config_id}.MainActivity" />

	</config-file>
<platform>
```

Remember replace:

- \${config_id} for id in config.xml file.
- \${scheme} for your app scheme (eg. ionicapp). In iOS is necessary configure URL types in Xcode.
- Add the google-services.json explained in [push](#push)

Declare window at the top of component where plugin is used:

```javascript
declare var window: any;
```

Initialize the plugin:

```javascript
this.platform.ready().then(() => {
  document.addEventListener('onDeepLink', (event) => {
    //process deeplink(eg. added in rich push)
  });
  document.addEventListener('onDeviceId', (event) => {
    //event.deviceId
  });

  const EMMA = window.plugins.EMMA; // gets EMMA plugin instance

  const configuration = {
    sessionKey: '<session_key>', //session key from EMMA Dashboard
    debug: true
  };

  EMMA.startSession(configuration);

  // Start push with options. Options are only used for Android. iOS use default app icon and open default controller
  const pushOptions = {
    classToOpen: '${config_id}.MainActivity', //replace ${config_id} for id in config.xml file
    iconResource: 'notification' // icon added in config.xml file
  };

  EMMA.startPush(pushOptions);

  this.statusBar.styleDefault();
  this.splashScreen.hide();
});
```

### <a id="push"> Push

- The file google-services.json is mandatory for android push notification configuration. [Android push dependencies](https://developer.emma.io/es/cordova/ionic-plugin#dependencias).
- To enable iOS notification check [iOS Push Dependencies](https://developer.emma.io/es/cordova/ionic-plugin#dependencias-1).

## <a id="docs"> 📑 Docs

[English](https://developer.emma.io/en/cordova/ionic-plugin) <br/>
[Spanish](https://developer.emma.io/es/cordova/ionic-plugin)

## <a id="example"> 📱 Example

See example project [here](https://github.com/EMMADevelopment/EMMAIonicExample/tree/master).
