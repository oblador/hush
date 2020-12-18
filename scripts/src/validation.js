export const hasUnsupportedSelectors = (selector) =>
  selector.includes(":has-text") ||
  selector.includes(":xpath") ||
  selector.includes(":-abp");
