import {
  assertArrayIncludes,
  assertEquals,
} from "https://deno.land/std@0.81.0/testing/asserts.ts";
import { transformLine } from "./convert.js";

Deno.test("Hide by id", () => {
  assertEquals(transformLine("###gdpr"), {
    action: {
      selector: "#gdpr",
      type: "css-display-none",
    },
    trigger: {
      "url-filter": ".*",
    },
  });
});

Deno.test("Hide by class", () => {
  assertEquals(transformLine("##.cookie-consent"), {
    action: {
      selector: ".cookie-consent",
      type: "css-display-none",
    },
    trigger: {
      "url-filter": ".*",
    },
  });
});

Deno.test("Hide by id and domain", () => {
  assertEquals(transformLine("microsoft.com,office.com###uhfCookieAlert"), {
    action: {
      selector: "#uhfCookieAlert",
      type: "css-display-none",
    },
    trigger: {
      "if-domain": [
        "*microsoft.com",
        "*office.com",
      ],
      "url-filter": ".*",
    },
  });
});

Deno.test("Hide by html attribute", () => {
  assertEquals(transformLine('##div[class$="UpdatePanelCookie"]'), {
    action: {
      selector: 'div[class$="UpdatePanelCookie"]',
      type: "css-display-none",
    },
    trigger: {
      "url-filter": ".*",
    },
  });
});

Deno.test("Block filter escapes special characters", () => {
  assertEquals(transformLine("/wa_lib.js"), {
    action: {
      type: "block",
    },
    trigger: {
      "url-filter": "\\/wa_lib\\.js",
    },
  });
  assertEquals(transformLine("/we_use_cookies?"), {
    action: {
      type: "block",
    },
    trigger: {
      "url-filter": "\\/we_use_cookies\\?",
    },
  });
});

Deno.test("Block filter allows multiple options with domain exempts", () => {
  assertEquals(
    transformLine(
      "||ws.audioscrobbler.com^$third-party,domain=~last.fm|~lastfm.de|~lastfm.ru",
    ),
    {
      action: {
        type: "block",
      },
      trigger: {
        "unless-domain": [
          "*last.fm",
          "*lastfm.de",
          "*lastfm.ru",
        ],
        "load-type": [
          "third-party",
        ],
        "url-filter": "ws\\.audioscrobbler\\.com([?/].*)?$",
      },
    },
  );
});

Deno.test("Block filter with ^ in the middle of the pattern", () => {
  assertEquals(
    transformLine(
      "||thscore.co^*/backTop.",
    ),
    {
      action: {
        type: "block",
      },
      trigger: {
        "url-filter": "thscore\\.co[?/].*\\/backTop\\.",
      },
    },
  );
});

Deno.test("Block filter with wildcard", () => {
  assertEquals(transformLine("/v1/gdpr/*$domain=~11freunde.de"), {
    action: {
      type: "block",
    },
    trigger: {
      "unless-domain": [
        "*11freunde.de",
      ],
      "url-filter": "\\/v1\\/gdpr\\/.*",
    },
  });
});

Deno.test("Block filter exempt", () => {
  assertEquals(transformLine("@@||consent.truste.com^$domain=economist.com"), {
    action: {
      type: "ignore-previous-rules",
    },
    trigger: {
      "if-domain": [
        "*economist.com",
      ],
      "url-filter": "consent\\.truste\\.com([?/].*)?$",
    },
  });
  assertEquals(
    transformLine("@@/wp-content/*/1x1.trans.gif$image,~third-party"),
    {
      action: {
        type: "ignore-previous-rules",
      },
      trigger: {
        "load-type": [
          "first-party",
        ],
        "resource-type": [
          "image",
        ],
        "url-filter": "\\/wp\\-content\\/.*\\/1x1\\.trans\\.gif",
      },
    },
  );
});

Deno.test("Block filter for third party", () => {
  assertEquals(transformLine("||aimtell.com$third-party"), {
    action: {
      type: "block",
    },
    trigger: {
      "load-type": [
        "third-party",
      ],
      "url-filter": "aimtell\\.com",
    },
  });
});

Deno.test("Block filter for negative resource types", () => {
  assertEquals(transformLine("/arscode-ninja-popups/*$~stylesheet"), {
    action: {
      type: "block",
    },
    trigger: {
      "resource-type": [
        "document",
        "image",
        "script",
        "font",
        "raw",
        "svg-document",
        "media",
        "popup",
      ],
      "url-filter": "\\/arscode\\-ninja\\-popups\\/.*",
    },
  });

  assertEquals(
    transformLine("||privacy-mgmt.com^$third-party,domain=~11freunde.de"),
    {
      action: {
        type: "block",
      },
      trigger: {
        "load-type": [
          "third-party",
        ],
        "unless-domain": [
          "*11freunde.de",
        ],
        "url-filter": "privacy\\-mgmt\\.com([?/].*)?$",
      },
    },
  );
});

Deno.test("Block filter for raw resource types", () => {
  assertEquals(transformLine("lol$other"), {
    action: {
      type: "block",
    },
    trigger: {
      "resource-type": [
        "raw",
      ],
      "url-filter": "lol",
    },
  });
});

Deno.test("Converts IDNs to ASCII", () => {
  assertEquals(transformLine("bafög.de###privacy-note"), {
    action: {
      selector: "#privacy-note",
      type: "css-display-none",
    },
    trigger: {
      "if-domain": [
        "*xn--bafg-7qa.de",
      ],
      "url-filter": ".*",
    },
  });

  assertEquals(transformLine("@@||allestörungen.ch^$generichide"), {
    action: {
      type: "ignore-previous-rules",
    },
    trigger: {
      "url-filter": "xn\\-\\-allestrungen\\-9ib\\.ch([?/].*)?$",
    },
  });
});
