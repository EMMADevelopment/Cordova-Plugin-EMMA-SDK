package io.emma.cordova.plugin;

public class EMMAPluginConstants {

    enum ActionTypes {
        REGISTER,
        LOGIN
    }

    enum PermissionStatus {
        GRANTED(0),
        DENIED(1),
        SHOULD_REQUEST_RATIONALE(2),
        UNSUPPORTED(3);

        private final int value;

        PermissionStatus(int value) {
            this.value = value;
        }

        public int getValue() {
            return value;
        }
    }

    /* ERROR MESSAGES */
    static final String INVALID_METHOD_OR_ARGUMENTS =
            "Check if method exists or arguments are correct";
    static final String PUSH_CLASS_MANDATORY = "Cannot init push. Class to open not exists";
    static final String PUSH_NOTIFICATION_DRAWABLE_MANDATORY = "Not found notification icon drawable";
    static final String PUSH_NOTIFICATION_COLOR_MANDATORY = "Introduced color for push notification not valid";
    static final String MANDATORY_NOT_EMPTY = " can not be empty";
    static final String MANDATORY_NOT_ZERO = " can not be zero";
    static final String KEY_VALUE_MAPPING_ERROR = " key-value attributes invalid";
    static final String MAPPING_VALUE_ERROR = "Only allowed property value in string type";
    static final String INAPP_TYPE_INVALID = "Invalid in-app type. Types are referred in JS class InAppTypes";

    /* START SESSION */
    static final String SESSION_KEY = "sessionKey";
    static final String DEBUG = "debug";
    static final String API_URL = "apiUrl";
    static final String QUEUE_TIME = "queueTime";
    static final String TRACK_SCREEN_EVENTS = "trackScreenEvents";
    static final String CUSTOM_POWLINK_DOMAINS = "powlinkDomains";
    static final String CUSTOM_SHORT_POWLINK_DOMAINS = "customShortPowlinkDomains";
    static final int MIN_QUEUE_TIME = 10;

    /* PUSH */
    static final String PUSH_CLASS_TO_OPEN = "classToOpen";
    static final String PUSH_ICON_RESOURCE = "iconResource";
    static final String PUSH_NOTIFICATION_COLOR = "notificationColor";
    static final String PUSH_NOTIFICATION_CHANNEL_NAME= "notificationChannelName";
    static final String PUSH_NOTIFICATION_CHANNEL_ID= "notificationChannelId";

    /* EVENT */
    static final String EVENT_TOKEN = "token";
    static final String EVENT_ATTRIBUTES = "attributes";

    /* GLOBAL */
    static final String EXTRAS = "extras";

    /* LOGIN - REGISTER */
    static final String USER_ID = "userId";
    static final String EMAIL = "email";

    /* ORDER */
    static final String ORDER_ID = "orderId";
    static final String ORDER_TOTAL_PRICE = "totalPrice";
    static final String ORDER_CUSTOMER_ID = "customerId";
    static final String ORDER_COUPON = "coupon";

    static final String ORDER_PRODUCT_PRICE = "price";
    static final String ORDER_PRODUCT_ID = "productId";
    static final String ORDER_PRODUCT_NAME = "productName";
    static final String ORDER_PRODUCT_QUANTITY = "quantity";

    /* INAPP */
    static final String INAPP_TYPE = "type";
    static final String INAPP_TEMPLATE_ID = "templateId";
    static final String INAPP_BATCH = "batch";
    static final String INAPP_CAMPAIGN_ID = "campaignId";

    static final String INAPP_STARTVIEW = "startview";
    static final String INAPP_BANNER = "banner";
    static final String INAPP_STRIP = "strip";
    static final String INAPP_ADBALL = "adball";
    static final String INAPP_NATIVEAD = "nativeAd";

    static final String NATIVE_AD_ID = "id";
    static final String NATIVE_AD_CTA = "cta";
    static final String NATIVE_AD_SHOW_ON = "showOn";
}
