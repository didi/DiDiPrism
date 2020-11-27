package com.xiaojuchefu.prism.behavior.model;

import com.google.gson.annotations.SerializedName;

public class Rule {

    @SerializedName("ruleId")
    public long ruleId;
    @SerializedName("cityId")
    public int cityId;
    @SerializedName("period")
    public int period;
    @SerializedName("effectiveTime")
    public long effectiveTime;
    @SerializedName("cycleTrigger")
    public int cycleTrigger;
    @SerializedName("containHistory")
    public int containHistory;

    @SerializedName("triggerMoment")
    public int triggerMoment;
    @SerializedName("triggerDelay")
    public int triggerDelay;

    @SerializedName("ruleContent")
    public RuleContent ruleContent;

    public RuleContent basePoint;
    public boolean basePointTriggered;

    public boolean triggered;


}
