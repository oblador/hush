import { convert } from "./src/convert.js";
import { flattenSelectors } from "./src/optimize.js";

const LISTS = [
  "../data/block-the-eu-cookie-shit-list.txt",
  "../data/dont-push-me.txt",
  "../data/hush.txt",
];

const stringify = (data) =>
  Deno.env.get("MINIFY") ? JSON.stringify(data) : JSON.stringify(data, null, 2);

const resolveRelative = (path) => new URL(path, import.meta.url).pathname;

const readTextFile = (path) =>
  new TextDecoder("utf-8").decode(Deno.readFileSync(path));

const decoder = new TextDecoder("utf-8");

const converted = LISTS
  .map(resolveRelative)
  .map(readTextFile)
  .map(convert)
  .flat();

const optimized = flattenSelectors(converted);

console.log(stringify(optimized));
