# Known issues

## Milestone publication fails in IG Publisher 3.0.0

Applies to: IG Publisher 3.0.0, `-go-publish` with `mode: milestone` (or `technical-correction`). Same issue as in ig-notifications.

After both publication builds succeed, the run stops with `java.lang.Error: The folder <temp>/ig-builds/<package>#<version>-milestone/output is not inside the website root folder <temp>/web-root/run-<date>` (`IGReleaseRedirectionBuilder.java:158`, called from `PublicationProcess.java:748`). Observed for ig-notifications in a trial run on 2026-10-09; not reproduced for this IG.

Fixed upstream in [HL7/fhir-ig-publisher d64c08c](https://github.com/HL7/fhir-ig-publisher/commit/d64c08c) ("Fix publication crash when building redirects for the milestone build output", 8 October 2026), not yet in a release. This is why versions 0.1.0-draft and 0.1.1-draft are published with `mode: working`; `0.1.0-draft` is removed from the site after `0.1.1-draft` is published. Publish a milestone with the same content once a publisher release contains the fix, and pin that version in CI.

## Packages not on the FHIR package registry

Applies to: `nl.generiekefuncties.csd#1.0.0` and `nl.twiin.fhir.r4.notifications#0.1.1-draft`.

Neither package is on packages.fhir.org, so SUSHI and the publisher cannot download them. `.github/scripts/install-packages.sh` downloads each tarball, checks its pinned sha-256 and puts it in `~/.fhir/packages`; it fails on a download error or a different checksum. CI runs it before SUSHI (step "Install packages not on the registry"); run it once for a local build.

| Package | URL | sha-256 |
|---|---|---|
| `nl.generiekefuncties.csd#1.0.0` | https://minvws.github.io/generiekefuncties-docs/package.tgz | `847ea68d0ba5df6c0c2faa6a939d23f49e167401e338752d1ef72a3cf509c849` (determined 2026-10-09) |
| `nl.twiin.fhir.r4.notifications#0.1.1-draft` | https://fhir.twiin.nl/ig/notifications/0.1.1-draft/package.tgz | `cec58f60184740ec51994b44c5ae4ddc42b870576ff20cfc831f9a47a183f2fd` |

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

## Several versions of `hl7.terminology.r4`

COW IG 1.0.0-ballot depends on `hl7.terminology.r4#6.2.0` and `hl7.fhir.uv.extensions.r4#5.2.0`; Notifications and GF Addressing on 7.4.0 and 5.3.0. The publisher uses 7.4.0 and 5.3.0, the versions in this IG's own `dependsOn`, and also loads the older versions that dependencies bring. This gives warnings such as `There are multiple different potential matches for the url 'http://terminology.hl7.org/ValueSet/v3-ServiceDeliveryLocationRoleType'`. Not allowlisted; warnings do not fail the build.

## Not fixed by `twiin.base.template#0.1.1`

Applies to: `twiin.base.template#0.1.1` (based on `fhir2.base.template#0.1.0`) with IG Publisher 3.0.0. The template fixes the redirect to `en/` for non-English browsers, the empty release label, the doubled `<h2 id="root">` on profile history pages and the not well formed profile pages (see its [README](https://github.com/TwiinNL/ig-template)); this repository has no workarounds for those any more. What remains, the same with `fhir2.base.template#0.1.0` alone and also listed in the template README:

- `searchform.html` has its own markup that the publisher reports as not well formed: 8 warnings for `output/searchform.html` and 8 for `output/en/searchform.html` (16 in total, not allowlisted, warnings do not fail the build).
- Profile history pages are not in the page list of the publisher, so their breadcrumb bar is empty and the heading has no section number.

## HTML fragment `cross-version-analysis` is not included anywhere

Applies to: IG Publisher 3.0.0, base template `fhir2.base.template#0.1.0`. The publisher always generates `cross-version-analysis` and `cross-version-analysis-inline` and warns ("An HTML fragment from the set [cross-version-analysis.xhtml, cross-version-analysis-inline.xhtml] is not included anywhere"). Not relevant for this IG: it targets one FHIR version (4.0.1), so there is no cross-version analysis to show. Not allowlisted; warnings do not fail the build.
