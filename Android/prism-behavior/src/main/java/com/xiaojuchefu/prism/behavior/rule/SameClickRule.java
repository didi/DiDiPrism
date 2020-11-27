package com.xiaojuchefu.prism.behavior.rule;

import com.xiaojuchefu.prism.behavior.BehaviorData;
import com.xiaojuchefu.prism.behavior.model.Rule;
import com.xiaojuchefu.prism.behavior.model.RuleContent;
import com.xiaojuchefu.prism.behavior.model.RuleState;

import java.util.HashMap;

public class SameClickRule implements RuleHandler {

    public static final String TYPE = "same_item_number";

    @Override
    public boolean handleRule(Rule rule, RuleContent ruleContent, BehaviorData parsedData) {
        if (ruleContent.ruleState == null) {
            ruleContent.ruleState = new RuleState();
        }
        if (ruleContent.ruleState.stateData == null) {
            ruleContent.ruleState.stateData = new HashMap<>();
        }

        HashMap<String, Integer> sameClickCount = (HashMap<String, Integer>) ruleContent.ruleState.stateData;

        String key = "";
        if (parsedData.data.containsKey("vr")) {
            key += parsedData.data.get("vr");
        }
        if (parsedData.data.containsKey("itemName")) {
            key += parsedData.data.get("itemName");
        }

        Integer clickCount = sameClickCount.get(key);
        if (clickCount == null) {
            clickCount = 1;
        } else {
            clickCount = clickCount + 1;
        }
        sameClickCount.put(key, clickCount);
        if (ruleContent.typeValue.length > 0) {
            int count = Integer.parseInt(ruleContent.typeValue[0]);
            if (ruleContent.operator.equals("gte")) {
                if (clickCount >= count) {
                    if (ruleContent.consultBasePoint == 0) {
                        ruleContent.ruleState.triggered = true;
                        return true;
                    } else if (ruleContent.consultBasePoint == 1) {
                        if (rule.basePoint != null && rule.basePoint.ruleState != null && rule.basePoint.ruleState.triggered) {
                            ruleContent.ruleState.triggered = true;
                            return true;
                        }
                    }
                }
            }
        }
        return false;
    }

}
