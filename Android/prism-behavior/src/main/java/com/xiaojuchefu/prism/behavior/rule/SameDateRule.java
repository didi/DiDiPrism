package com.xiaojuchefu.prism.behavior.rule;

import com.xiaojuchefu.prism.behavior.BehaviorData;
import com.xiaojuchefu.prism.behavior.EventDataManager;
import com.xiaojuchefu.prism.behavior.model.Rule;
import com.xiaojuchefu.prism.behavior.model.RuleContent;
import com.xiaojuchefu.prism.behavior.model.RuleState;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class SameDateRule implements RuleHandler {

    public static final String TYPE = "same_item_date";

    @Override
    public boolean handleRule(Rule rule, RuleContent ruleContent, BehaviorData parsedData) {
        if (ruleContent.ruleState == null) {
            ruleContent.ruleState = new RuleState();
        }
        if (ruleContent.ruleState.stateData == null) {
            ruleContent.ruleState.stateData = new HashMap<>();
        }

        HashMap<String, List<Long>> sameDateCount = (HashMap<String, List<Long>>) ruleContent.ruleState.stateData;

        String key = "";
        if (parsedData.data.containsKey("vr")) {
            key += parsedData.data.get("vr");
        }
        if (parsedData.data.containsKey("itemName")) {
            key += parsedData.data.get("itemName");
        }

        List<Long> dateCount = sameDateCount.get(key);
        if (dateCount == null) {
            dateCount = new ArrayList<>();
        }

        long dayTime = EventDataManager.getDayTime(parsedData.eventTime);
        if (dateCount.contains(dayTime)) {
            return false;
        }

        dateCount.add(dayTime);
        sameDateCount.put(key, dateCount);
        if (ruleContent.typeValue.length > 0) {
            int count = Integer.parseInt(ruleContent.typeValue[0]);
            if (ruleContent.operator.equals("gte")) {
                if (dateCount.size() >= count) {
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
