package com.xiaojuchefu.prism.behavior.rule;

import com.xiaojuchefu.prism.behavior.BehaviorData;
import com.xiaojuchefu.prism.behavior.model.Rule;
import com.xiaojuchefu.prism.behavior.model.RuleContent;
import com.xiaojuchefu.prism.behavior.model.RuleState;

public class SimilarClickRule implements RuleHandler {

    public static final String TYPE = "same_person_number";

    @Override
    public boolean handleRule(Rule rule, RuleContent ruleContent, BehaviorData parsedData) {
        if (ruleContent.ruleState == null) {
            ruleContent.ruleState = new RuleState();
        }

        Integer clickCount = (Integer) ruleContent.ruleState.stateData;
        if (clickCount == null) {
            clickCount = 0;
        }
        clickCount++;
        ruleContent.ruleState.stateData = clickCount;

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
