package com.xiaojuchefu.prism.behavior.model;

import com.google.gson.annotations.SerializedName;

public class RuleProperty {

    @SerializedName("operator")
    public String operator;
    @SerializedName("value")
    public String[] value;

}
