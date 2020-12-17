import punycode from '../vendor/punycode.js'

const COMMENT_PREFIX = "!";
const ELEMENT_HIDE_SEPARATOR = "##";
const ELEMENT_HIDE_EXCEPTION_SEPARATOR = "#@#";
const BLOCK_PREFIX = "||";
const BLOCK_EXCEPTION_PREFIX = "@@||";
const OPTION_SEPARATOR = "$";
const RESOURCE_TYPES = ['document', 'image', 'style-sheet', 'script', 'font', 'raw', 'svg-document', 'media', 'popup']

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
	  })

const mapResourceType = type => {
	switch (type) {
		case 'stylesheet':
			return 'style-sheet';
		// Not perfect match, but probably good enough
		case 'subdocument':
		case 'xmlhttprequest':
		case 'other':
			return 'raw';
		default:
			return type;
	}
}

const isResourceTypeOption = ([option, value]) => typeof value === 'boolean' && option !== 'third-party' && !option.startsWith('generic')


const mapOptionsToTrigger = (options) =>
  parseOptions(options)
    .reduce((acc, optionTuple, index, array) => {
    	const [option, value] = optionTuple
	  	if (isResourceTypeOption(optionTuple)) {
		  	const firstResourceType = array.find(isResourceTypeOption)
		  	if (value !== firstResourceType[1]) {
		  		throw new Error(`Resource type options might not mix includes and excludes, got "${options}"`)
		  	}
	  	}

      switch (option) {
        case "domain": {
          const isExcemptedDomains = isDomainExemption(value);
          const domains = value
            .split(/\|/g)
            .filter(Boolean)
            .map((domain) => {
              const isExemption = isDomainExemption(domain);
              if (
                !isExcemptedDomains && isExemption ||
                isExcemptedDomains && !isExemption
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
          acc[isExcemptedDomains ? "unless-domain" : "if-domain"] = domains;
          break;
        }
        case "third-party": {
          acc["load-type"] = [value ? "third-party" : "first-party"];
          break;
        }
				case 'font':
				case 'media':
				case 'other':
				case 'subdocument':
				case 'xmlhttprequest':
        case "document":
        case "image":
        case "popup":
        case "script":
        case "stylesheet": {
          const resourceType = mapResourceType(option)
          if (value === false) {
	          acc["resource-type"] = (acc["resource-type"] || RESOURCE_TYPES).filter(t => t !== resourceType)
          } else {
	          acc["resource-type"] = (acc["resource-type"] || []).concat(option);
          }
          break;
        }
        case 'generichide':
        case 'genericblock': {
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
  filter
    .replace(/[-\/\\$+?.()|[\]{}]/g, "\\$&")
    .replace(/\*/g, ".*")
    .replace(/\^$/, "([?/].*)?$")
    .replace(/\^/, "[?/]")

export const transformLine = (line) => {
  if (isElementHide(line) || isElementHideException(line)) {
    const separator = isElementHideException(line)
      ? ELEMENT_HIDE_EXCEPTION_SEPARATOR
      : ELEMENT_HIDE_SEPARATOR;
    const [domains, selector] = line.split(separator);
    if (
      selector.includes(":has-text") || selector.includes(":xpath") ||
      selector.includes(":-abp")
    ) {
      throw new Error(`Custom CSS extensions not supported, got "${line}"`);
    }
    return {
      trigger: {
        "url-filter": ".*",
        ...(domains
          ? {
            "if-domain": domains.split(",").map((domain) => `*${punycode.toASCII(domain)}`),
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

  if (isBlock(line) || isBlockException(line)) {
    const prefix = isBlock(line) ? BLOCK_PREFIX : BLOCK_EXCEPTION_PREFIX;
    const [filter, options] = line.substr(prefix.length).split(
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
