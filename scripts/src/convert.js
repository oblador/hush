import punycode from "https://deno.land/x/punycode/punycode.js";
import { hasUnsupportedSelectors } from "./validation.js";

const COMMENT_PREFIX = "!";
const ELEMENT_HIDE_SEPARATOR = "##";
const ELEMENT_HIDE_EXCEPTION_SEPARATOR = "#@#";
const BLOCK_PREFIX = "||";
const EXCEPTION_PREFIX = "@@";
const OPTION_SEPARATOR = "$";
const RESOURCE_TYPES = [
  "document",
  "image",
  "style-sheet",
  "script",
  "font",
  "raw",
  "svg-document",
  "media",
  "popup",
];

// Unsupported
const ANCHOR = "|";
const EXTENDED_SELECTOR_SEPARATOR = "#?#";
const SNIPPET_SEPARATOR = "#$#";

const isRule = (line) =>
  Boolean(line) && !line.startsWith(COMMENT_PREFIX) &&
  !line.startsWith("[Adblock");
const isBlock = (line) => line.startsWith(BLOCK_PREFIX);
const isExactAddressBlock = (line) => line.startsWith(ANCHOR) && !isBlock(line);
const isException = (line) => line.startsWith(EXCEPTION_PREFIX);
const isElementHide = (line) => line.includes(ELEMENT_HIDE_SEPARATOR);
const isElementHideException = (line) =>
  line.includes(ELEMENT_HIDE_EXCEPTION_SEPARATOR);
const isExtendedSelector = (line) => line.includes(EXTENDED_SELECTOR_SEPARATOR);
const isSnippet = (line) => line.includes(SNIPPET_SEPARATOR);

const isDomainExemption = (domain) => domain[0] === "~";

const parseOptions = (options) =>
  (options || "")
    .split(",")
    .filter(Boolean)
    .map((option) => {
      if (option.includes("=")) {
        return option.split("=");
      }
      if (option.startsWith("~")) {
        return [option.substr(1), false];
      }
      return [option, true];
    });

const mapResourceType = (type) => {
  switch (type) {
    case "stylesheet":
      return "style-sheet";
    case "subdocument":
      return "document";
    // Not perfect match, but probably good enough
    case "xmlhttprequest":
    case "other":
      return "raw";
    default:
      return type;
  }
};

const isResourceTypeOption = ([option, value]) =>
  typeof value === "boolean" && option !== "third-party" &&
  !option.startsWith("generic");

const mapOptionsToTrigger = (options) =>
  parseOptions(options)
    .reduce((acc, optionTuple, index, array) => {
      const [option, value] = optionTuple;
      if (isResourceTypeOption(optionTuple)) {
        const firstResourceType = array.find(isResourceTypeOption);
        if (value !== firstResourceType[1]) {
          throw new Error(
            `Resource type options might not mix includes and excludes, got "${options}"`,
          );
        }
      }

      switch (option) {
        case "domain": {
          const isExemptedDomains = isDomainExemption(value);
          const domains = value
            .split(/\|/g)
            .filter(Boolean)
            .map((domain) => {
              const isExemption = isDomainExemption(domain);
              if (
                !isExemptedDomains && isExemption ||
                isExemptedDomains && !isExemption
              ) {
                throw new Error(
                  `Domain option might not mix includes and excludes, got "${value}"`,
                );
              }
              return `*${punycode.toASCII(domain.substr(isExemption ? 1 : 0))}`;
            });
          if (!domains.length) {
            break;
          }
          acc[isExemptedDomains ? "unless-domain" : "if-domain"] = domains;
          break;
        }
        case "third-party": {
          acc["load-type"] = [value ? "third-party" : "first-party"];
          break;
        }
        case "font":
        case "media":
        case "other":
        case "subdocument":
        case "xmlhttprequest":
        case "document":
        case "image":
        case "popup":
        case "script":
        case "stylesheet": {
          const resourceType = mapResourceType(option);
          if (value === false) {
            acc["resource-type"] = (acc["resource-type"] || RESOURCE_TYPES)
              .filter((t) => t !== resourceType);
          } else {
            acc["resource-type"] = (acc["resource-type"] || []).concat(
              resourceType,
            );
          }
          break;
        }
        case "generichide":
        case "genericblock": {
          // This will cause the exemption to be applied to all previous rules,
          // while not perfect, it's safer than ignoring it
          break;
        }
        default: {
          throw new Error(`Unsupported option "${option}"`);
        }
      }
      return acc;
    }, {});

const mapFilterToRegExp = (filter) =>
  punycode.toASCII(filter)
    .replace(/[-\/\\$+?.()|[\]{}]/g, "\\$&")
    .replace(/\*/g, ".*")
    .replace(/\^$/, "([?/].*)?$")
    .replace(/\^/, "[?/]");

const mapBlockLineToFilter = (line) => {
  const [filter, options] = line.split(
    OPTION_SEPARATOR,
  );
  return {
    "url-filter": mapFilterToRegExp(filter),
    ...mapOptionsToTrigger(options),
  };
};

export const transformLine = (line) => {
  if (isExactAddressBlock(line)) {
    throw new Error(`Exact address block parsing not supported, got "${line}"`);
  }
  if (isExtendedSelector(line)) {
    throw new Error(`Extended selector parsing not supported, got "${line}"`);
  }
  if (isSnippet(line)) {
    throw new Error(`Snippet block parsing not supported, got "${line}"`);
  }

  if (isElementHide(line) || isElementHideException(line)) {
    const separator = isElementHideException(line)
      ? ELEMENT_HIDE_EXCEPTION_SEPARATOR
      : ELEMENT_HIDE_SEPARATOR;
    const [domains, selector] = line.split(separator);
    if (hasUnsupportedSelectors(selector)) {
      throw new Error(`Custom CSS extensions not supported, got "${line}"`);
    }
    return {
      trigger: {
        "url-filter": ".*",
        ...(domains
          ? {
            "if-domain": domains.split(",").map((domain) =>
              `*${punycode.toASCII(domain)}`
            ),
          }
          : {}),
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

  // This is a block filter since we excluded all other possible types

  // TODO: I don't understand the difference between || rules and
  // those without. I think || will also match domain name and the others
  // only path name, however currently we match the whole URL for both.
  return {
    trigger: mapBlockLineToFilter(
      line
        .replace(/^@@/, "")
        .replace(/^[|]{2}/, ""),
    ),
    action: {
      type: isException(line) ? "ignore-previous-rules" : "block",
    },
  };
};

const trim = (s) => s.trim();

export function convert(data) {
  return data
    .split("\n")
    .map(trim)
    .filter(isRule)
    .map(transformLine);
}
