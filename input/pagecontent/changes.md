This page lists the changes per published version, newest first. The requirements are in TA Workflow; where this guide and the TA differ, the TA applies.

### 0.4.0-draft

Technical specification of TA Workflow 0.4. Changes since 0.3.0-draft:

- Task.input types `supplemental-resource` and `supplemental-query` renamed to `available-resource` and `available-query` (slices `availableResource`, `availableQuery`). A standard dataset (the Library of the ActivityDefinition or PlanDefinition in `ServiceRequest.instantiatesCanonical`) is a guideline, not a requirement: the Placer states per Request what it makes available in these entries, and its server supports the reads and searches behind them, not the searches of the dataset itself.
- New code `information-request` (nine codes in `ta-workflow`) and slice `informationRequest` (0..*) on the Coordination Task. The Fulfiller may add and remove such entries; the type is reserved for the Fulfiller.
- New search parameter `owner-assigner` (Task.owner.identifier.assigner.identifier), in the CapabilityStatement of the Placer's server. Subscriptions per organization: filter `owner-assigner=[system]|[value]` next to `owner:identifier`, `channel.endpoint` 1..1 and from `Organization.endpoint` for such a Subscription; `twiin-wsub-1` accepts both forms.
- After an accepted Cancellation Request the Coordination Task ends as `cancelled` instead of `failed`; the Fulfiller sets it. The Placer sets `cancelled` only before `in-progress`.
- `statusReason`: new invariant `twiin-ct-9` (`statusReason.text` when `businessStatus` is `awaiting-information`), next to `twiin-ct-8` (rejected, failed) and `twiin-ct-5` (SHOULD on cancelled). `executionPeriod.end` is set when the status leaves `in-progress`.
- `ServiceRequest.priority` mustSupport with guidance; Task.priority is not used.
- A candidate may read the Request from the creation of its Coordination Task; read access to the Patient follows Task.code `fulfill`, not `businessStatus` `selected`.
- New page [Example scenarios](example-scenarios.html) with seven scenarios and a Subscription example per filter form.
- New examples: deselecting a selected Fulfiller before in-progress and soliciting again on the same Request ([Example: reselection](example-reselection.html)); sharing additional content before and after selection ([Example: sharing additional content](example-sharing.html)).
- Cancellation Request Task and Authorization Cancellation Request Task: `reasonCode` for the requesting party's reason (1..1 on the latter); `statusReason` carries only the answering party's reason. The existing Authorization Cancellation Request Task example moves the Fulfiller's reason to `reasonCode.text`.
- Coordination Task: invariant `twiin-ct-8` (`statusReason` required when the status is rejected or failed); `twiin-ct-5` now covers the status cancelled only.
- Template `twiin.base.template` 0.1.7 (was 0.1.6). `0.3.0-draft` is published unchanged and keeps its template.
- Package lock: `hl7.terminology` 7.5.0; `hl7.fhir.uv.extensions.r4` pinned to 5.3.0, as TA Workflow names it as a base specification (see known-issues.md in the source repository).
- Correction: the URA is identified with the system `http://fhir.nl/fhir/NamingSystem/ura` everywhere, also on the assigner of the identifiers of HealthcareService and Location (as GF Addressing does) and in the `owner-assigner` Subscription example. The examples and test fixtures used the OID `urn:oid:2.16.528.1.1007.3.3` for the assigner. Republished as 0.4.0-draft.

### 0.3.0-draft (2026-10-16)

Fourth draft publication, technical specification of TA Workflow 0.3.

- Business status: codes `awaiting-information` and `visit-scheduled` in the code system and the businessStatus value set; the Coordination Task and the page [Requirements not expressed in artifacts](requirements-not-in-artifacts.html) aligned with the TA sections Business status and Write access; an example added.

### 0.2.0-draft (2026-10-16)

Third draft publication, technical specification of TA Workflow 0.3.

- Aligned with TA Workflow 0.3. Twiin Notifications pinned to 0.2.0-draft; the dependency on GF Addressing removed. Invariant `twiin-ct-4` removed.

### 0.1.1-draft (2026-10-12)

Second draft publication, technical specification of TA Workflow 0.3, in the Twiin house style.

- Depends on Twiin Notifications 0.1.1-draft. The page [Installing dependencies](installing-dependencies.html) includes the dependency table.

### 0.1.0-draft (2026-10-12)

First draft publication, technical specification of TA Workflow 0.3. Removed from the site after 0.1.1-draft was published.
