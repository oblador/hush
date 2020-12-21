import { convert } from "./src/convert.js";

const LISTS = [
  "../data/vendor/fanboy-cookiemonster.txt",
  "../data/generic.txt",
  "../data/third-party.txt",
  "../data/site-specific.txt",
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

console.log(stringify(converted));
