# Known issues

## Packages not on the FHIR package registry

Applies to: `nl.generiekefuncties.csd#1.0.0` and `nl.twiin.fhir.r4.notifications#0.1.0-draft`.

Neither package is on packages.fhir.org, so SUSHI and the publisher cannot download them. `.github/scripts/install-packages.sh` downloads each tarball, checks its pinned sha-256 and puts it in `~/.fhir/packages`; it fails on a download error or a different checksum. CI runs it before SUSHI (step "Install packages not on the registry"); run it once for a local build.

| Package | URL | sha-256 |
|---|---|---|
| `nl.generiekefuncties.csd#1.0.0` | https://minvws.github.io/generiekefuncties-docs/package.tgz | `847ea68d0ba5df6c0c2faa6a939d23f49e167401e338752d1ef72a3cf509c849` (determined 2026-10-09) |
| `nl.twiin.fhir.r4.notifications#0.1.0-draft` | https://fhir.twiin.nl/ig/notifications/0.1.0-draft/package.tgz | `bcf5baf254979caba62508179ec46739aca488adbbbfafae96f90def6a7b192c` |

The URL of `nl.generiekefuncties.csd` has no version: it serves whatever the publisher of GF Addressing last built. When that changes, the checksum fails and the build stops. Then check the new package and update the version and the checksum together.

## SUSHI does not load transitive dependencies

Applies to: SUSHI 3.x. SUSHI resolves profiles only from the packages listed in `sushi-config.yaml`. Two transitive dependencies are therefore listed explicitly:

- `hl7.fhir.eu.base#2.0.0`, a dependency of `nl.generiekefuncties.csd`. NL-GF-Location is based on its `location-eu-core`; without it SUSHI rejects `Reference(nl-gf-location)` on Task.location.
- `hl7.fhir.uv.subscriptions-backport.r4#1.1.0`, a dependency of COW IG and of Notifications. Twiin Workflow Subscription constrains its extensions. The version must equal the one in Notifications.

## Backport IG declares FHIR 4.0.0

Applies to: IG Publisher 3.0.0, `hl7.fhir.uv.subscriptions-backport.r4#1.1.0`. Allowlisted in [known-errors.txt](known-errors.txt). Same issue as in ig-notifications.

The Backport package declares FHIR 4.0.0 in `package.json` and in its ImplementationGuide. The publisher reports two errors on `ImplementationGuide/nl.twiin.fhir.r4.workflow`, with different wording (`This IG is version 4.0.1, while the IG ...` and `This IG is for FHIR version 4.0.1, while the package ...`), and a warning on `ImplementationGuide.dependsOn`. `fhirVersion` stays 4.0.1.

## Backport package has an empty index

Applies to: IG Publisher 3.0.0, `hl7.fhir.uv.subscriptions-backport.r4#1.1.0`. Worked around in CI, not allowlisted. Same issue as in ig-notifications.

The published package contains `package/.index.json` with `"files": []`, so the publisher finds none of its resources. The CI step "Work around empty index of Backport package" puts the package in the cache and removes `.index.json`. For a local build, remove `~/.fhir/packages/hl7.fhir.uv.subscriptions-backport.r4#1.1.0/package/.index.json` once.

## Requester of the Authorization Cancellation Request Task

Applies to: TA Workflow 0.3, table Authorization Cancellation Request Task. Not an error of a tool.

The TA describes Task.requester as the HealthcareService of the Fulfiller, by Reference.identifier from the AssignedId slice of NL-GF-HealthcareService. FHIR R4 does not allow HealthcareService as a target of Task.requester (Device, Organization, Patient, Practitioner, PractitionerRole, RelatedPerson). Decision: the requester is the Fulfiller as an organization, with `requester.identifier.system` fixed to `http://fhir.nl/fhir/NamingSystem/ura`, like owner. The TA text should be aligned with this.

## Several versions of `hl7.terminology.r4`

COW IG 1.0.0-ballot depends on `hl7.terminology.r4#6.2.0` and `hl7.fhir.uv.extensions.r4#5.2.0`; Notifications and GF Addressing on 7.4.0 and 5.3.0. The publisher uses 7.4.0 and 5.3.0, the versions in this IG's own `dependsOn`, and also loads the older versions that dependencies bring. This gives warnings such as `There are multiple different potential matches for the url 'http://terminology.hl7.org/ValueSet/v3-ServiceDeliveryLocationRoleType'`. Not allowlisted; warnings do not fail the build.

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


### Release label not shown in the page header

Without a workaround the header shows `<version> - ` without the `releaseLabel` from `sushi-config.yaml`. Cause: `includes/fragment-pagebegin.html:64` of the template reads `site.data.info.releaselabellang[include.lang]` (`include.lang` is `en` there), but `_data/info.json`, written by `scripts/onGenerate.genJson.xslt:71-83`, only has `releaselabel`. The script writes a fixed list of keys, so no IG parameter can supply `releaselabellang`. Fixed upstream in [HL7/ig-template-base2 6fc5321](https://github.com/HL7/ig-template-base2/commit/6fc5321) (2025-11-20, reads `site.data.fhir.releaseLabellang`), not in a published version.

Workaround: `input/includes/fragment-pagebegin.html` is the template file of 0.1.0 (sha-256 `431379c0d2dabaa855c2d57f051b08e9f0d00cb23bdf70447845bf63170996f9`), copied verbatim with only line 64 changed to `{% assign status = site.data.info.releaselabel %}`. The publisher puts `input/includes/` over the template's includes.

The CI step "Test release label" (`test/release-label.test.js`) checks that every page in `output/en/` with the template header (`<div id="ig-status">`) shows the label, and fails if `template/includes/fragment-pagebegin.html` is no longer the 0.1.0 file: then the override must be reviewed, because it would replace a newer template file. `searchform.html` has its own header from the template and never shows the label; it is not checked.

Remove the override and the CI step when `ig.ini` points to a template version that contains 6fc5321 and the label appears without the override.

### Two `<h2 id="root">` on the profile history pages

Applies to: `StructureDefinition-<id>.profile.history.html`, one error per profile. The template's `layouts/layout-profile-history.html` has two `<h2 id="root">` lines in a row, and the second is not closed. The publisher's WCAG check reports it as an error: `The page has more than one top level heading: <h2> (no text) is at the same level as the first heading on the page (<h2> '…' (id=root)). A page must have exactly one top level heading, with every other heading beneath it (WCAG compliance test)`.

Allowlisted in [known-errors.txt](known-errors.txt), one line per profile in the form `output/en/StructureDefinition-<id>.profile.history.html: <message>`. A new profile adds a line; remove the lines when the template is fixed.

### Warnings from `searchform.html`

The template's `searchform.html` gives 8 warnings (`The html source is not well formed: Found "</div>" expecting "</body>"` and `Found "</a>" expecting "</img>"`). They are warnings, so they do not fail the build and are not allowlisted. With `fhir.base.template#current` they did not occur.
