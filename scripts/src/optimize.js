// This changes the order of rules, so it's possible that it
// would break some exceptions, but hoisting hide rules
// should minimize that

const isHideSelectorRule = (rule) => rule.action.type === "css-display-none";

export const flattenSelectors = (rules) =>
  rules.reduce((acc, rule) => {
    if (isHideSelectorRule(rule)) {
      // Yes this is slow, sue me
      const mergableRule = acc.find((r) =>
        isHideSelectorRule(r) &&
        JSON.stringify(r.trigger) === JSON.stringify(rule.trigger)
      );
      if (mergableRule) {
        acc[acc.indexOf(mergableRule)] = {
          trigger: mergableRule.trigger,
          action: {
            ...mergableRule.action,
            selector: `${mergableRule.action.selector},${rule.action.selector}`,
          },
        };
        return acc;
      }
    }
    acc.push(rule);
    return acc;
  }, []);
