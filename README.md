# ig-workflow

FHIR R4 implementation guide for the technical specification of TA Workflow, part of the technical core of the Twiin Afsprakenstelsel.

- Package id: `nl.twiin.fhir.r4.workflow`
- Canonical: https://fhir.twiin.nl/ig/workflow
- FHIR version: 4.0.1
- Version: 0.1.0 (draft)
- Publisher: Twiin
- Dependencies: none

Built with [SUSHI](https://fshschool.org/docs/sushi/) and the HL7 IG Publisher.

## Dependency rules

- This IG may depend on `nl.twiin.fhir.r4.notifications`; that IG must never depend on this one.
- Once this IG depends on the Subscriptions R5 Backport IG (`hl7.fhir.uv.subscriptions-backport.r4`), the version must equal the one in `nl.twiin.fhir.r4.notifications`, as long as this IG does not depend on Notifications.
- Add a dependency only when an artifact refers to that package.

## TODO

- TODO: fill in the TA Workflow version in the IG once TA Workflow 0.3 is published. The IG refers to "TA Workflow" without version until then.
- Pin the template version in `ig.ini` (currently `fhir.base.template#current`).

## Build

```sh
./_updatePublisher.sh   # download/update the IG Publisher
sushi build .
./_genonce.sh -no-sushi # output in output/ (see output/qa.html)
```

Requires Java, Node (SUSHI) and Jekyll. The template is set in `ig.ini`, not in `sushi-config.yaml`.

## CI

`.github/workflows/build.yml` runs on pull requests and pushes to `main`: SUSHI, download of IG Publisher 3.0.0 (pinned), build, upload of `output/` (including `qa.html`) as artifact `ig-output`.

The build fails on every publisher error that is not listed in [known-errors.txt](known-errors.txt) (see [known-issues.md](known-issues.md)). The publisher exits with 0 on a build whose `qa.html` lists errors, so the exit code cannot be used. Warnings and hints do not fail the build. Errors cannot be suppressed via `input/ignoreWarnings.txt`.

`.github/scripts/check-qa.py` reads the individual errors from `output/qa.xml`, a FHIR Bundle of OperationOutcomes written by the publisher. Each error becomes one line `<location>: <message>`, with the issue's `expression` as location (file name if there is none), and must match a line in `known-errors.txt` exactly. As a cross-check the number of errors in `qa.xml` must equal `errs` in `output/qa.json`.

Neither file's layout is documented as far as verified; both were inspected with IG Publisher 3.0.0, which is why the CI pins that version (`PUBLISHER_VERSION` in the workflow). On every publisher update, re-check that `qa.xml` still lists the same errors as `qa.html`. Entries in `known-errors.txt` that no longer occur are reported as a notice.

## License

- IG content (everything in `input/`, including FSH): CC BY-SA 4.0 (SPDX: `CC-BY-SA-4.0`), see [LICENSE](LICENSE).
- Code (workflows, own scripts): TBD.
- `_updatePublisher.*` and `_genonce.*` are copied unmodified from [HL7/ig-publisher-scripts](https://github.com/HL7/ig-publisher-scripts). The license of that repository is unknown; clarify with HL7 before publishing.
