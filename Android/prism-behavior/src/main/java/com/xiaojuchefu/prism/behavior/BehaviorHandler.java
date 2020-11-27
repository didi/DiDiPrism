package com.xiaojuchefu.prism.behavior;

import android.text.TextUtils;

import com.xiaojuchefu.prism.behavior.model.Rule;
import com.xiaojuchefu.prism.behavior.model.RuleContent;
import com.xiaojuchefu.prism.behavior.model.RuleProperty;
import com.xiaojuchefu.prism.behavior.rule.RuleHandler;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class BehaviorHandler {

    private Rule mRule;

    public BehaviorHandler(Rule rule) {
        mRule = rule;
        hasBasePoint(rule.ruleContent);

        long earliestDayTime;
        if (rule.containHistory == 1) {
            earliestDayTime = EventDataManager.getInstance().getEarliestDayTime();
        } else {
            earliestDayTime = rule.effectiveTime * 1000L;
        }

        List<String> eventDataList = null;
        if (rule.period > 1) {
            long todayTime = EventDataManager.getInstance().getDayTime(System.currentTimeMillis());
            long fromDayTime = todayTime - (rule.period - 1) * 86400000L;
            if (fromDayTime < earliestDayTime) {
                fromDayTime = earliestDayTime;
            }
            eventDataList = EventDataManager.getInstance().getEventDataList(fromDayTime);
        } else if (rule.period == 1) {
            long fromDayTime = EventDataManager.getInstance().getDayTime(System.currentTimeMillis());
            if(fromDayTime < earliestDayTime) {
                fromDayTime = earliestDayTime;
            }
            eventDataList = EventDataManager.getInstance().getEventDataList(fromDayTime);
        } else {
            // 当次访问
        }

        if (eventDataList != null) {
            for (String eventData : eventDataList) {
                BehaviorData behaviorData = new BehaviorData(eventData);
                handleEvent(behaviorData, true);
            }
        }
    }

    private void hasBasePoint(RuleContent ruleContent) {
        if (ruleContent.rules != null) {
            for (int i = 0; i < ruleContent.rules.size(); i++) {
                hasBasePoint(ruleContent.rules.get(i));
            }
        } else {
            if (ruleContent.basePoint == 1) {
                mRule.basePoint = ruleContent;
            }
        }
    }

    public void handleEvent(BehaviorData behaviorData) {
        handleEvent(behaviorData, false);
    }

    public void handleEvent(BehaviorData behaviorData, boolean history) {
        if (mRule.triggered) {
            if (!history && mRule.triggerMoment == 1) {
                if (mRule.basePointTriggered) {
                    return;
                }
                if (handleEvent(behaviorData, mRule.basePoint, true)) {
                    mRule.basePointTriggered = true;
                    PrismBehavior.getInstance().onBehaviorHit(mRule);
                    if (mRule.cycleTrigger == 1) {
                        clearRuleState();
                    }
                }
            }
            return;
        }

        boolean result = handleEvent(behaviorData, mRule.ruleContent, false);
        if (result) {
            mRule.triggered = true;
            if (mRule.triggerMoment == 0) {
                PrismBehavior.getInstance().onBehaviorHit(mRule);
                if (mRule.cycleTrigger == 1) {
                    clearRuleState();
                }
            }
        }
    }

    private boolean handleEvent(BehaviorData behaviorData, RuleContent ruleContent, boolean basePoint) {
        if (ruleContent == null) return false;

        if (ruleContent.relation != null) {
            if ("and".equals(ruleContent.relation)) {
                int count = 0;
                for (int i = 0; i < ruleContent.rules.size(); i++) {
                    boolean result = handleEvent(behaviorData, ruleContent.rules.get(i), basePoint);
                    if (result) {
                        count++;
                    }
                }
                return count == ruleContent.rules.size();
            } else if ("or".equals(ruleContent.relation)) {
                int count = 0;
                for (int i = 0; i < ruleContent.rules.size(); i++) {
                    boolean result = handleEvent(behaviorData, ruleContent.rules.get(i), basePoint);
                    if (result) {
                        count++;
                    }
                }
                return count > 0;
            } else {
                return false;
            }
        } else {
            if (!basePoint && ruleContent.ruleState != null && ruleContent.ruleState.triggered) {
                return true;
            }
            boolean instruction = handleInstruction(behaviorData.data, ruleContent);
            if (instruction) {
                RuleHandler ruleHandler = BehaviorRuleManager.getInstance().getRuleHandler(ruleContent.type);
                if (ruleHandler != null && ruleHandler.handleRule(mRule, ruleContent, behaviorData)) {
                    return true;
                }
            }
            return false;
        }
    }

    private boolean handleInstruction(Map<String, String> data, RuleContent ruleContent) {
        List<HashMap<String, RuleProperty>> instruction = ruleContent.instruction;
        HashMap<String, RuleProperty> extra = null;
        if (!TextUtils.isEmpty(ruleContent.itemName)) {
            extra = new HashMap<>(1);
            RuleProperty ruleProperty = new RuleProperty();
            ruleProperty.operator = "=";
            ruleProperty.value = new String[]{ruleContent.itemName};
            extra.put("itemName", ruleProperty);
        }

        boolean result = false;
        for (int i = 0; i < instruction.size(); i++) {
            HashMap<String, RuleProperty> rulePropertyMap = instruction.get(i);
            if (handleRuleProperty(data, rulePropertyMap, extra)) {
                result = true;
                break;
            }
        }
        return result;
    }

    private boolean handleRuleProperty(Map<String, String> data, HashMap<String, RuleProperty> ruleProperties, HashMap<String, RuleProperty> extra) {
        HashMap<String, RuleProperty> rulePropertyMap = ruleProperties;
        if (extra != null) {
            rulePropertyMap = new HashMap<>(ruleProperties);
            rulePropertyMap.putAll(extra);
        }
        Set<String> keySet = rulePropertyMap.keySet();
        for (String property : keySet) {
            String value = data.get(property);
            if (value == null) {
                return false;
            }

            RuleProperty ruleProperty = rulePropertyMap.get(property);
            if (ruleProperty == null) return false;
            if (ruleProperty.operator.equals("=")) {
                if (ruleProperty.value.length > 0) {
                    if (!value.equals(ruleProperty.value[0])) {
                        return false;
                    }
                } else {
                    return false;
                }
            } else if (ruleProperty.operator.equals("%")) {
                boolean contain = false;
                for (String ruleValue : ruleProperty.value) {
                    if (value.contains(ruleValue)) {
                        contain = true;
                        break;
                    }
                }
                if (!contain) {
                    return false;
                }
            } else {
                return false;
            }
        }
        return true;
    }

    private void clearRuleState() {
        mRule.triggered = false;
        mRule.basePointTriggered = false;
        clearRuleContentState(mRule.ruleContent);
    }

    private void clearRuleContentState(RuleContent ruleContent) {
        if (ruleContent.rules != null) {
            for (int i = 0; i < ruleContent.rules.size(); i++) {
                clearRuleContentState(ruleContent.rules.get(i));
            }
        } else {
            ruleContent.ruleState = null;
        }
    }

}
