# ig-workflow

FHIR R4 implementation guide for the technical specification of TA Workflow, part of the technical core of the Twiin Afsprakenstelsel.

- Package id: `nl.twiin.fhir.r4.workflow`
- Canonical: https://fhir.twiin.nl/ig/workflow
- FHIR version: 4.0.1
- Version: 0.1.0 (draft)
- Publisher: Twiin
- Dependencies: `hl7.fhir.uv.cow#1.0.0-ballot`, `nl.generiekefuncties.csd#1.0.0`, `nl.twiin.fhir.r4.notifications#0.1.0-draft`, and, because SUSHI needs them, `hl7.fhir.eu.base#2.0.0` and `hl7.fhir.uv.subscriptions-backport.r4#1.1.0` (see [known-issues.md](known-issues.md))

Built with [SUSHI](https://fshschool.org/docs/sushi/) and the HL7 IG Publisher.

## Dependency rules

- This IG may depend on `nl.twiin.fhir.r4.notifications`; that IG must never depend on this one.
- Once this IG depends on the Subscriptions R5 Backport IG (`hl7.fhir.uv.subscriptions-backport.r4`), the version must equal the one in `nl.twiin.fhir.r4.notifications`, as long as this IG does not depend on Notifications.
- Add a dependency only when an artifact refers to that package.

## TODO

- TODO: fill in the TA Workflow version in the IG once TA Workflow 0.3 is published. The IG refers to "TA Workflow" without version until then.

## Build

```sh
.github/scripts/install-packages.sh   # packages not on the registry, checksum-verified
./_updatePublisher.sh   # download/update the IG Publisher
sushi build .
./_genonce.sh -no-sushi # output in output/ (see output/qa.html)
```

Requires Java, Node (SUSHI) and Jekyll. The template is set in `ig.ini`, not in `sushi-config.yaml`.

The template is pinned to `fhir2.base.template#0.1.0`. `fhir.base.template` is no longer supported and the IG Publisher will refuse IGs that depend on it, see the [FHIR security notice of 17 March 2026](https://fhir.org/guides/security-notices/2026-03-npm-dependencies.html). `fhir2.base.template` builds all pages into `output/en/`; the pages in the root of `output/` are redirect stubs. This template version has two bugs, worked around in this repository: see [known-issues.md](known-issues.md).

## CI

`.github/workflows/build.yml` runs on pull requests and pushes to `main`: SUSHI, download of IG Publisher 3.0.0 (pinned), build, upload of `output/` (including `qa.html`) as artifact `ig-output`.

The runner is pinned to `ubuntu-24.04` (not `ubuntu-latest`), so a change of the GitHub-hosted image does not alter the build unnoticed. Moving to a newer Ubuntu gets its own PR.

The build fails on every publisher error that is not listed in [known-errors.txt](known-errors.txt) (see [known-issues.md](known-issues.md)). The publisher exits with 0 on a build whose `qa.html` lists errors, so the exit code cannot be used. Warnings and hints do not fail the build. Errors cannot be suppressed via `input/ignoreWarnings.txt`.

`.github/scripts/check-qa.py` reads the errors from two files. `output/qa.xml` is a FHIR Bundle of OperationOutcomes written by the publisher; it is structured (severity, message and expression as separate elements), and each error becomes one line `<location>: <message>`, with the issue's `expression` as location (file name if there is none). `output/qa.txt` also lists the errors of the HTML check (for example the WCAG heading check on the generated pages), which `qa.xml` does not contain (`qa.json` only counts them); each `ERROR:` line becomes one line `<location>: <message>`, with the absolute path of `output/` replaced by `output/`. Every line must match a line in `known-errors.txt` exactly. Matching is on text and location, not on count. As a cross-check the script requires the errors of both files, counted once when both list them, to equal `errs` in `output/qa.json`, and fails otherwise.

The step "Test language redirect" runs `node test/lang-redirects.test.js` after the build: it checks that the redirect script in `output/` is our override of the template file and that browsers with language `nl`, `nl-NL`, `de`, `en` and `en-US` are all sent to `en/<page>`, with query string and fragment kept. The override (`input/images/assets/js/lang-redirects.js`) is a source file of the IG, so every build from this repository applies it, including the build for publication with `-go-publish`; that build has not been run for this change, so check `output/assets/js/lang-redirects.js` (and the copy in `output/en/`) before publishing. See [known-issues.md](known-issues.md).

Neither file's layout is documented as far as verified; both were inspected with IG Publisher 3.0.0, which is why the CI pins that version (`PUBLISHER_VERSION` in the workflow). On every publisher update, re-check that `qa.xml` and `qa.txt` together still list the same errors as `qa.html`. Entries in `known-errors.txt` that no longer occur are reported as a notice.

## Invalid examples

`test/invalid/` holds one instance per invariant (and per profile where an invariant is shared), each violating only that invariant. After a build:

```sh
test/validate-invalid.sh path/to/validator_cli.jar
```

The script validates each file against `output/package.tgz` and fails if the validator does not report the invariant named in the file name. It is not run in CI.

## License

- IG content (everything in `input/`, including FSH): CC BY-SA 4.0 (SPDX: `CC-BY-SA-4.0`), see [LICENSE](LICENSE).
- Code (workflows, own scripts): TBD.
- `_updatePublisher.*` and `_genonce.*` are copied unmodified from [HL7/ig-publisher-scripts](https://github.com/HL7/ig-publisher-scripts). The license of that repository is unknown; clarify with HL7 before publishing.
