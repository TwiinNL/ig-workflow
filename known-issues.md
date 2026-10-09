# Known issues

## Template `fhir2.base.template#0.1.0`

Applies to: `fhir2.base.template#0.1.0` (the only version on packages2.fhir.org, 2026-10-09) with IG Publisher 3.0.0. Both bugs are fixed on the `main` branch of [HL7/ig-template-base2](https://github.com/HL7/ig-template-base2) (`lang-redirects.js`: commits 3c6dc8c9 and 28239381; `layout-profile-history.html`: commit 5b8c9667) but are not in a published version. `package.json` there still says 0.1.0.

Remove the workaround and the allowlist lines below when a template version containing these fixes is published and `ig.ini` points to it. The check in `test/lang-redirects.test.js` reports a notice when the template's own file changes.

### Redirect stops after the first language

The template builds every page into `output/en/` and leaves a stub page in the root of `output/` that loads `assets/js/lang-redirects.js`. In 0.1.0 the `return;` in the loop of `doRedirect()` sits outside the `if`:

```js
for (i=0;i<langs.length;i++) {
  if ((userLang == langs[i]) || userLang.startsWith(langs[i]+"-")) {
    window.location.replace(langs[i]+"/"+pageName);
  }
  return;
}
window.location.replace(langs[0]+"/"+pageName);   // never reached
```

A browser whose language is not `en` (for example `nl`, `nl-NL`, `de`) is not redirected and stays on the empty stub page. Workaround: `input/images/assets/js/lang-redirects.js` is the file from HL7/ig-template-base2 `main`, copied verbatim (sha-256 `8a4dec2d77c9dff3a2b67f3574f0aef17f69e68812833550519c9cb2857e527d`). Source commits: [3c6dc8c9](https://github.com/HL7/ig-template-base2/commit/3c6dc8c9) ("Fix redirect for non-EN browsers", the `return` fix) and [28239381](https://github.com/HL7/ig-template-base2/commit/28239381151925bb4794b69c1c5738fdcb4b3ef6) ("Update lang-redirects.js", keeps `search` and `hash` in the redirect), checked on `main` at 2c669969 (2026-10-09). The override can go as soon as a template release after 0.1.0 contains these commits and `ig.ini` uses it: delete `input/images/assets/js/lang-redirects.js` and the "Test language redirect" step if the template's own file passes `test/lang-redirects.test.js`.

The publisher copies `input/images/` over the template's `content/`, so both `output/assets/js/lang-redirects.js` and `output/en/assets/js/lang-redirects.js` are this file. `test/lang-redirects.test.js` checks that, and runs the redirect for `nl`, `nl-NL`, `de`, `en` and `en-US`, and with a query string and a fragment (CI step "Test language redirect"). This is observed behaviour of the publisher, not documented; the test fails if it stops working. The override is a source file of the IG, so every build from this repository applies it, including the publication build (`-go-publish`). That build has not been run for this change; run `node test/lang-redirects.test.js` on its output before publishing.

The sha-256 of the faulty template file is `7ea6ae46a27c877dc47cc7ac0df4cc05f01b8debcbeec66db372da7577e92383`.

### Two `<h2 id="root">` on the profile history pages

Applies to: `StructureDefinition-<id>.profile.history.html`, one error per profile. The template's `layouts/layout-profile-history.html` has two `<h2 id="root">` lines in a row, and the second is not closed. The publisher's WCAG check reports it as an error: `The page has more than one top level heading: <h2> (no text) is at the same level as the first heading on the page (<h2> '…' (id=root)). A page must have exactly one top level heading, with every other heading beneath it (WCAG compliance test)`.

This IG has no profiles yet, so the error does not occur and nothing is allowlisted. The first profile adds one error per profile, in the form `output/en/StructureDefinition-<id>.profile.history.html: <message>`, and fails the build. Add those lines to [known-errors.txt](known-errors.txt) (see ig-notifications for the exact text) and remove them when the template is fixed.

### Warnings from `searchform.html`

The template's `searchform.html` gives 8 warnings (`The html source is not well formed: Found "</div>" expecting "</body>"` and `Found "</a>" expecting "</img>"`). They are warnings, so they do not fail the build and are not allowlisted. With `fhir.base.template#current` they did not occur.
