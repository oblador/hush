const COMMENT_PREFIX = "!";
const ELEMENT_HIDE_SEPARATOR = "##";
const ELEMENT_HIDE_EXCEPTION_SEPARATOR = "#@#";
const BLOCK_PREFIX = "||";
const BLOCK_EXCEPTION_PREFIX = "@@";
const OPTION_SEPARATOR = "$";

// Unsupported
const ANCHOR = "|";
const EXTENDED_SELECTOR_SEPARATOR = "#?#";
const SNIPPET_SEPARATOR = "#$#";

const isRule = (line) =>
  Boolean(line) && !line.startsWith(COMMENT_PREFIX) &&
  !line.startsWith("[Adblock");
const isBlock = (line) => line.startsWith(BLOCK_PREFIX);
const isExactAddressBlock = (line) => line.startsWith(ANCHOR) && !isBlock(line);
const isBlockException = (line) => line.startsWith(BLOCK_EXCEPTION_PREFIX);
const isElementHide = (line) => line.includes(ELEMENT_HIDE_SEPARATOR);
const isElementHideException = (line) =>
  line.includes(ELEMENT_HIDE_EXCEPTION_SEPARATOR);
const isExtendedSelector = (line) => line.includes(EXTENDED_SELECTOR_SEPARATOR);
const isSnippet = (line) => line.includes(SNIPPET_SEPARATOR);

const parseOptions = (options) =>
  (options || "").split(",").filter(Boolean).map((option) => {
    if (option.includes("=")) {
      return option.split("=");
    }
    if (option.startsWith("~")) {
      return [option.substr(1), false];
    }
    return [option, true];
  });

const mapOptionsToTrigger = (options) =>
  parseOptions(options)
    .reduce((acc, [option, value]) => {
      switch (option) {
        case "~domain": {
          acc["unless-domain"] = [`*${value}`];
          break;
        }
        case "domain": {
          acc["if-domain"] = [`*${value}`];
          break;
        }
        case "third-party": {
          acc["load-type"] = [value ? "third-party" : "first-party"];
          break;
        }
        case "document":
        case "script":
        case "image": {
          if (value === false) {
            throw new Error(`Negative options not supported`);
          }
          acc["resource-type"] = (acc["resource-type"] || []).concat(option);
          break;
        }
        default: {
          throw new Error(`Unsupported option "${option}"`);
        }
      }
      return acc;
    }, {});

const mapFilterToRegExp = (filter) =>
  `.*${
    filter.replace(/[-\/\\^$*+?.()|[\]{}]/g, "\\$&").replace(/\\\*/g, ".*")
  }.*`;

const transformLine = (line) => {
  if (isElementHide(line) || isElementHideException(line)) {
    const separator = isElementHideException(line)
      ? ELEMENT_HIDE_EXCEPTION_SEPARATOR
      : ELEMENT_HIDE_SEPARATOR;
    const [domains, selector] = line.split(separator);
    return {
      trigger: {
        "url-filter": ".*",
        "if-domain": domains
          ? domains.split(",").map((domain) => `*${domain}`)
          : undefined,
      },
      action: isElementHideException(line)
        ? {
          type: "ignore-previous-rules",
        }
        : {
          type: "css-display-none",
          selector: selector,
        },
    };
  }

  if (isBlock(line) || isBlockException(line)) {
    const [filter, options] = line.substr(BLOCK_PREFIX.length).split(
      OPTION_SEPARATOR,
    );
    return {
      trigger: {
        "url-filter": mapFilterToRegExp(filter),
        ...mapOptionsToTrigger(options),
      },
      action: {
        type: isBlockException(line) ? "ignore-previous-rules" : "block",
      },
    };
  }

  if (isExactAddressBlock(line)) {
    throw new Error(`Exact address block parsing not supported, got "${line}"`);
  }
  if (isExtendedSelector(line)) {
    throw new Error(`Extended selector parsing not supported, got "${line}"`);
  }
  if (isSnippet(line)) {
    throw new Error(`Snippet block parsing not supported, got "${line}"`);
  }

  const [filter, options] = line.split(OPTION_SEPARATOR);
  return {
    trigger: {
      "url-filter": mapFilterToRegExp(filter),
      ...mapOptionsToTrigger(options),
    },
    action: {
      type: "block",
    },
  };
};

export function convert(data) {
  return data
    .split("\n")
    .filter(isRule)
    .map(transformLine);
}
