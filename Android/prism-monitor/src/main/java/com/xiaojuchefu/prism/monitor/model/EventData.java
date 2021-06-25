package com.xiaojuchefu.prism.monitor.model;

import android.app.Activity;
import android.view.View;

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

    @SerializedName("w")
    public String w;
    @SerializedName("vi")
    public String vi;
    @SerializedName("vr")
    public String vr;
    @SerializedName("vq")
    public String vq;
    @SerializedName("vl")
    public String vl;
    @SerializedName("vp")
    public String vp;
    @SerializedName("wu")
    public String wu;
    @SerializedName("vf")
    public String vf;
    @SerializedName("an")
    public String an;

    public Activity activity;
    public View view;

    public EventData(int eventType) {
        this.eventType = eventType;
        this.eventTime = System.currentTimeMillis();
    }

    public String getUnionId() {
        return "e" + PrismConstants.Symbol.DIVIDER_INNER + eventType + (eventId != null ? (PrismConstants.Symbol.DIVIDER + eventId) : "");
    }

}
