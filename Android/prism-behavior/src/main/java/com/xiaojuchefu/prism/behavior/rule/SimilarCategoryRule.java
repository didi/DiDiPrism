package com.xiaojuchefu.prism.behavior.rule;

import com.xiaojuchefu.prism.behavior.BehaviorData;
import com.xiaojuchefu.prism.behavior.model.Rule;
import com.xiaojuchefu.prism.behavior.model.RuleContent;
import com.xiaojuchefu.prism.behavior.model.RuleState;

import java.util.ArrayList;
import java.util.List;

public class SimilarCategoryRule implements RuleHandler {

    public static final String TYPE = "same_person_category";

    @Override
    public boolean handleRule(Rule rule, RuleContent ruleContent, BehaviorData parsedData) {
        if (ruleContent.ruleState == null) {
            ruleContent.ruleState = new RuleState();
        }

        List<String> categoryCount = (List<String>) ruleContent.ruleState.stateData;
        if (categoryCount == null) {
            categoryCount = new ArrayList<>();
            ruleContent.ruleState.stateData = categoryCount;
        }

        String key = "";
        if (parsedData.data.containsKey("vr")) {
            key += parsedData.data.get("vr");
        }
        if (parsedData.data.containsKey("itemName")) {
            key += parsedData.data.get("itemName");
        }

        if (categoryCount.contains(key)) {
            return false;
        }
        categoryCount.add(key);

        if (ruleContent.typeValue.length > 0) {
            int count = Integer.parseInt(ruleContent.typeValue[0]);
            if (ruleContent.operator.equals("gte")) {
                if (categoryCount.size() >= count) {
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
