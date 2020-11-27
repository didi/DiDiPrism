package com.xiaojuchefu.prism.behavior;

import com.xiaojuchefu.prism.behavior.model.Rule;
import com.xiaojuchefu.prism.behavior.rule.RuleHandler;
import com.xiaojuchefu.prism.behavior.rule.SameClickRule;
import com.xiaojuchefu.prism.behavior.rule.SameDateRule;
import com.xiaojuchefu.prism.behavior.rule.SimilarCategoryRule;
import com.xiaojuchefu.prism.behavior.rule.SimilarClickRule;
import com.xiaojuchefu.prism.behavior.rule.SimilarDateRule;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BehaviorRuleManager {

    private static BehaviorRuleManager sBehaviorRuleManager;
    private List<Rule> mRules;
    private List<BehaviorHandler> mBehaviorHandlers = new ArrayList<>();
    private Map<String, RuleHandler> mRuleHandlerMap = new HashMap<>();

    private BehaviorRuleManager() {
        mRuleHandlerMap.put(SameClickRule.TYPE, new SameClickRule());
        mRuleHandlerMap.put(SameDateRule.TYPE, new SameDateRule());
        mRuleHandlerMap.put(SimilarClickRule.TYPE, new SimilarClickRule());
        mRuleHandlerMap.put(SimilarDateRule.TYPE, new SimilarDateRule());
        mRuleHandlerMap.put(SimilarCategoryRule.TYPE, new SimilarCategoryRule());
    }

    public static BehaviorRuleManager getInstance() {
        if (sBehaviorRuleManager == null) {
            synchronized (BehaviorRuleManager.class) {
                if (sBehaviorRuleManager == null) {
                    sBehaviorRuleManager = new BehaviorRuleManager();
                }
            }
        }
        return sBehaviorRuleManager;
    }

    public void onEvent(BehaviorData behaviorData) {
        if (mRules == null || mBehaviorHandlers == null) {
            return;
        }

        for (int i = 0; i < mBehaviorHandlers.size(); i++) {
            mBehaviorHandlers.get(i).handleEvent(behaviorData);
        }
    }

    public RuleHandler getRuleHandler(String type) {
        return mRuleHandlerMap.get(type);
    }

    public void setRules(List<Rule> rules) {
        mRules = rules;
        notifyChanged();
    }

    public void notifyChanged() {
        if (mRules == null) return;

        mBehaviorHandlers = new ArrayList<>();
        for (int i = 0; i < mRules.size(); i++) {
            Rule rule = mRules.get(i);
            mBehaviorHandlers.add(new BehaviorHandler(rule));
        }
    }

}
