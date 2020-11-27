package com.xiaojuchefu.prism.behavior.rule;

import com.xiaojuchefu.prism.behavior.BehaviorData;
import com.xiaojuchefu.prism.behavior.EventDataManager;
import com.xiaojuchefu.prism.behavior.model.Rule;
import com.xiaojuchefu.prism.behavior.model.RuleContent;
import com.xiaojuchefu.prism.behavior.model.RuleState;

import java.util.ArrayList;
import java.util.List;

public class SimilarDateRule implements RuleHandler {

    public static final String TYPE = "same_person_date";

    @Override
    public boolean handleRule(Rule rule, RuleContent ruleContent, BehaviorData parsedData) {
        if (ruleContent.ruleState == null) {
            ruleContent.ruleState = new RuleState();
        }

        List<Long> dateCount = (ArrayList<Long>) ruleContent.ruleState.stateData;
        if (dateCount == null) {
            dateCount = new ArrayList<Long>();
            ruleContent.ruleState.stateData = dateCount;
        }

        long dayTime = EventDataManager.getDayTime(parsedData.eventTime);
        if (dateCount.contains(dayTime)) {
            return false;
        }
        dateCount.add(dayTime);

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
