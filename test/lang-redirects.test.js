#!/usr/bin/env node
// Checks the language redirect of the published stub pages: every browser language ends up on
// en/<page>, and query string and fragment are kept. After a build, run from the repo root:
//   node test/lang-redirects.test.js
// The script comes from twiin.base.template; whether it is the right file is checked in the
// template repository, here only what the build delivers.
const fs = require("fs");

const OUTPUT_COPIES = ["output/assets/js/lang-redirects.js", "output/en/assets/js/lang-redirects.js"];

let failed = false;
const fail = (msg) => { console.log(`::error::${msg}`); failed = true; };

for (const copy of OUTPUT_COPIES) {
  if (!fs.existsSync(copy)) { fail(`${copy} is missing`); continue; }
  const src = fs.readFileSync(copy, "utf8");
  // [language, pathname, search, hash, expected]
  const cases = [
    ["nl", "/ig/workflow/index.html", "", "", "en/index.html"],
    ["nl-NL", "/ig/workflow/artifacts.html", "", "", "en/artifacts.html"],
    ["de", "/ig/workflow/index.html", "", "", "en/index.html"],
    ["en", "/ig/workflow/StructureDefinition-twiin-coordination-task.html", "", "", "en/StructureDefinition-twiin-coordination-task.html"],
    ["en-US", "/ig/workflow/index.html", "", "", "en/index.html"],
    ["nl", "/ig/workflow/index.html", "?a=1&b=2", "#section", "en/index.html?a=1&b=2#section"],
    ["en-US", "/ig/workflow/artifacts.html", "", "#table", "en/artifacts.html#table"],
    ["de", "/ig/workflow/artifacts.html", "?q=x", "", "en/artifacts.html?q=x"],
  ];
  for (const [language, pathname, search, hash, expected] of cases) {
    const targets = [];
    const window = { location: { pathname, search, hash, replace: (url) => targets.push(url) } };
    new Function("langs", "navigator", "window", src)(["en"], { language }, window);
    const ok = targets.length === 1 && targets[0] === expected;
    console.log(`${ok ? "ok  " : "FAIL"} ${copy} ${language} ${pathname}${search}${hash} -> ${targets.join(", ") || "(no redirect)"}`);
    if (!ok) failed = true;
  }
}
process.exit(failed ? 1 : 0);
