package com.xiaojuchefu.prism.behavior;

import android.text.TextUtils;

import com.google.gson.annotations.SerializedName;
import com.xiaojuchefu.prism.monitor.PrismConstants;
import com.xiaojuchefu.prism.monitor.model.EventData;

import java.util.HashMap;
import java.util.Map;

public class BehaviorData {

    @SerializedName("eventTime")
    public long eventTime;
    @SerializedName("eventType")
    public int eventType;
    @SerializedName("eventId")
    public String eventId;

    public transient Map<String, String> data;

    public BehaviorData(EventData eventData) {
        this.eventTime = eventData.eventTime;
        this.eventType = eventData.eventType;
        this.eventId = eventData.getUnionId();
        if (eventData.data != null && eventData.data.containsKey("itemName")) {
            this.eventId = this.eventId + PrismConstants.Symbol.DIVIDER + "itemName" + PrismConstants.Symbol.DIVIDER_INNER + eventData.data.get("itemName");
        }
        this.data = parseEventData();
    }

    public BehaviorData(String eventId) {
        this.eventId = eventId;
        this.data = parseEventData();
    }

    public Map<String, String> parseEventData() {
        String[] result = this.eventId.split("_\\^_");
        HashMap<String, String> data = new HashMap<>(result.length);
        for (int i = 0; i < result.length; i++) {
            if (TextUtils.isEmpty(result[i])) {
                continue;
            }
            int index = result[i].indexOf("_&_");
            if (index == -1) {
                continue;
            }
            String key = result[i].substring(0, index);
            String value = result[i].substring(index + 3);
            data.put(key, value);
        }
        return data;
    }

}
