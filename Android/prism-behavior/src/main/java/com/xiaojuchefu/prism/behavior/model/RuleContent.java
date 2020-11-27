package com.xiaojuchefu.prism.behavior.model;

import com.google.gson.annotations.SerializedName;

import java.util.HashMap;
import java.util.List;

public class RuleContent {
    @SerializedName("relation")
    public String relation;
    @SerializedName("rules")
    public List<RuleContent> rules;

    @SerializedName("itemName")
    public String itemName;
    @SerializedName("type")
    public String type;
    @SerializedName("operator")
    public String operator;
    @SerializedName("instruction")
    public List<HashMap<String, RuleProperty>> instruction;
    @SerializedName("typeValue")
    public String[] typeValue;

    @SerializedName("basePoint")
    public int basePoint;
    @SerializedName("consultBasePoint")
    public int consultBasePoint;

    public RuleState ruleState;

}
