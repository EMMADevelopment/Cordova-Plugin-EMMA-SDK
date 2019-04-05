package io.emma.cordova.plugin;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;
import android.graphics.Color;
import android.os.Bundle;
import android.support.annotation.ColorInt;
import android.support.annotation.DrawableRes;
import android.util.Log; 

import java.util.ArrayList;
import java.util.List;

import io.emma.android.EMMA;
import io.emma.android.model.EMMAPushOptions;
import io.emma.android.utils.EMMALog;
import io.emma.android.utils.ManifestInfo;


import static io.emma.cordova.plugin.EMMAPluginConstants.*;

public class EMMAPlugin extends CordovaPlugin {

    private boolean pushInitialized = false;

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
    }

    @Override
    public void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        if (pushInitialized) {
            EMMA.getInstance().onNewNotification(intent, true);
        }
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        EMMALog.d("Executed method: " + action);

        Log.d("EMMA", args.getJSONObject(0).toString());

        if (action.equals("startSession")) {

            if (args.length() == 1) {
                return startSession(args.getJSONObject(0), callbackContext);
            }

        } else if (action.equals("startPush")) {

            if (args.length() == 1) {
                return startPush(args.getJSONObject(0), callbackContext);
            }
        }

        EMMALog.d("Check if method exists or arguments are correct");

        return false;
    }

    private boolean startSession(JSONObject args, final CallbackContext callbackContext) {
        Context applicationContext = cordova.getActivity().getApplicationContext();

        String sessionKey = args.optString(SESSION_KEY);
        boolean debug = args.optBoolean(DEBUG);
        EMMALog.setLevel(debug? EMMALog.VERBOSE : EMMALog.NONE);
        boolean validSessionKey = !sessionKey.isEmpty() && !sessionKey.trim().equals("");

        if (!validSessionKey && !sessionKeyInMetadata(applicationContext)) {
            String msg = "Session key cannot be empty";
            EMMALog.e(msg);
            callbackContext.error(msg);
            return false;
        }

        EMMA.Configuration.Builder configuration =
                new EMMA.Configuration.Builder(applicationContext)
                        .setDebugActive(debug);

        if (validSessionKey) {
            configuration.setSessionKey(sessionKey);
        }

        int queueTime = args.optInt(QUEUE_TIME);
        if (queueTime >= MIN_QUEUE_TIME) {
            configuration.setQueueTime(queueTime);
        }

        String apiUrl = args.optString(API_URL);
        if (!apiUrl.trim().equals("")) {
            configuration.setWebServiceUrl(apiUrl);
        }

        JSONArray customPowlinkDomains = args.optJSONArray(CUSTOM_POWLINK_DOMAINS);
        if (customPowlinkDomains != null) {
            List<String> parsedDomains =
                    arrayToStringList(CUSTOM_POWLINK_DOMAINS, customPowlinkDomains);
            if (parsedDomains.size() > 0) {
                configuration.setPowlinkDomains((String[]) parsedDomains.toArray());
            }
        }

        JSONArray customShortPowlinkDomains = args.optJSONArray(CUSTOM_SHORT_POWLINK_DOMAINS);
        if (customShortPowlinkDomains != null) {
            List<String> parsedDomains =
                    arrayToStringList(CUSTOM_SHORT_POWLINK_DOMAINS, customShortPowlinkDomains);
            if (parsedDomains.size() > 0) {
                configuration.setPowlinkDomains((String[]) parsedDomains.toArray());
            }
        }

        configuration.trackScreenEvents(args.optBoolean(TRACK_SCREEN_EVENTS, true));

        EMMA.getInstance().startSession(configuration.build());
        callbackContext.success();

        return true;
    }

    private boolean startPush(JSONObject args, final CallbackContext callbackContext) {
        Context context = cordova.getContext().getApplicationContext();

        Class clazz;
        try {
            clazz = Class.forName(args.optString(PUSH_CLASS_TO_OPEN));
        } catch (ClassNotFoundException ex) {
            callbackContext.error("Cannot init push. Class to open not exists");
            return false;
        }

        int notificationIcon = 0;
        String notificationIconName = args.optString(PUSH_ICON_RESOURCE);
        if (!notificationIconName.trim().equals("")) {
            notificationIcon = getNotificationIcon(context, notificationIconName);
        }

        if (notificationIcon == 0) {
            callbackContext.error("Not found notification icon drawable");
            return false;
        }

        EMMAPushOptions.Builder pushOptions = new EMMAPushOptions.Builder(clazz, notificationIcon);

        String hexaColor = args.optString(PUSH_NOTIFICATION_COLOR);
        if (!hexaColor.trim().equals("")) {
            try {
                int colorInt = getNotificationColor(hexaColor);
                pushOptions.setNotificationColor(colorInt);
            } catch (IllegalArgumentException ex) {
                EMMALog.e("Introduced color for push notification not valid");
            }
        }

        String channelId = args.optString(PUSH_NOTIFICATION_CHANNEL_ID);
        if (!channelId.trim().equals("")) {
            pushOptions.setNotificationChannelId(channelId);
        }

        String channelName = args.optString(PUSH_NOTIFICATION_CHANNEL_NAME);
        if (!channelName.trim().equals("")) {
            pushOptions.setNotificationChannelName(channelName);
        }

        EMMA.getInstance().startPushSystem(pushOptions.build());

        pushInitialized = true;

        callbackContext.success();
        return true;
    }

    private List<String> arrayToStringList(String errorName, JSONArray array) {
        List<String> result = new ArrayList<>();
        for (int i = 0; i < array.length(); i++) {
            String candidate = array.optString(i);
            if (candidate.trim().equals("")) {
                EMMALog.w("Processing " + errorName + "at position "
                        + i + " parameter not valid must be string type");
                continue;
            }

            result.add(candidate);
        }

        return result;
    }

    private boolean sessionKeyInMetadata(Context applicationContext) {
        Bundle metaData = ManifestInfo.getApplicationMetadata(applicationContext);
        return metaData != null && metaData.getString("io.emma.SESSION_KEY") != null;
    }

    private @DrawableRes
    int getNotificationIcon(Context context, String imageName) {
        Resources res = context.getResources();
        return res.getIdentifier(imageName, "drawable", context.getPackageName());
    }

    private @ColorInt
    int getNotificationColor(String hexColor) {
        return Color.parseColor(hexColor);
    }

}