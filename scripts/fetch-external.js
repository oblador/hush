import { hasUnsupportedSelectors } from "./src/validation.js";

const resolveRelative = (path) => new URL(path, import.meta.url).pathname;

const DESTINATION_DIR = resolveRelative("../data/vendor");
const SOURCES = {
  "fanboy-cookiemonster":
    "https://secure.fanboy.co.nz/fanboy-cookiemonster.txt",
};

await Promise.all(
  Object.entries(SOURCES).map(async ([name, url]) => {
    const response = await fetch(url);
    if (!response.ok) {
      throw new Error(`Fetching ${url} failed with status ${response.status}`);
    }
    const data = (await response.text())
      .split("\n")
      .filter((line) => !hasUnsupportedSelectors(line))
      .join("\n");
    const destination = `${DESTINATION_DIR}/${name}.txt`;
    await Deno.writeTextFile(destination, data);
    console.info(`Saved ${url} to ${destination}`);
  }),
);
