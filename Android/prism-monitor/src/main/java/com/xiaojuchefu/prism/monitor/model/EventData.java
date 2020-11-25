package com.xiaojuchefu.prism.monitor.model;

import com.google.gson.annotations.SerializedName;
import com.xiaojuchefu.prism.monitor.PrismConstants;

import java.util.HashMap;

public class EventData {

    @SerializedName("eventTime")
    public long eventTime;
    @SerializedName("eventType")
    public int eventType;
    @SerializedName("eventId")
    public String eventId;
    @SerializedName("data")
    public HashMap<String, Object> data;

    public EventData(int eventType) {
        this.eventType = eventType;
        this.eventTime = System.currentTimeMillis();
    }

    public String getUnionId() {
        return "e" + PrismConstants.Symbol.DIVIDER_INNER + eventType + (eventId != null ? (PrismConstants.Symbol.DIVIDER + eventId) : "");
    }

}
