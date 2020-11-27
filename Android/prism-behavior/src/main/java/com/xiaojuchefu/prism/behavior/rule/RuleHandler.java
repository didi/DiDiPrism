package com.xiaojuchefu.prism.behavior.rule;

import com.xiaojuchefu.prism.behavior.BehaviorData;
import com.xiaojuchefu.prism.behavior.model.Rule;
import com.xiaojuchefu.prism.behavior.model.RuleContent;

public interface RuleHandler {

    boolean handleRule(Rule rule, RuleContent ruleContent, BehaviorData parsedData);

}
