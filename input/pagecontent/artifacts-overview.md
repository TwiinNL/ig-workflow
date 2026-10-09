This page is informative. It lists the artifacts in this guide and the section of TA Workflow each one belongs to. The requirements themselves are in the TA.

### Profiles

| Artifact | Based on | TA section |
|---|---|---|
| [Twiin Coordination Task](StructureDefinition-twiin-coordination-task.html) | `coordination-task` (COW IG 1.0.0-ballot) | Preliminary description of the profiles → Coordination Task; Coordination Task; Status of the Coordination Task; Patient context and readability; Type of work on the Task; Sharing additional content; Search parameters |
| [Twiin Cancellation Request Task](StructureDefinition-twiin-cancellation-request-task.html) | `cancellation-request-task` (COW IG 1.0.0-ballot) | Preliminary description of the profiles → Cancellation Request Task; Cancellation Request Task |
| [Twiin Authorization Cancellation Request Task](StructureDefinition-twiin-authorization-cancellation-request-task.html) | `Task` (FHIR R4) | Preliminary description of the profiles → Authorization Cancellation Request Task; Cancellation by the Fulfiller |
| [Twiin Workflow ServiceRequest](StructureDefinition-twiin-workflow-servicerequest.html) | `ServiceRequest` (FHIR R4) | Preliminary description of the profiles → ServiceRequest; Request; Patient context and readability |
| [Twiin Workflow Subscription](StructureDefinition-twiin-workflow-subscription.html) | `twiin-subscription` (Twiin Notifications 0.1.0-draft) | Subscription |

Task.owner and Task.location refer to NL-GF-HealthcareService and NL-GF-Location of GF Addressing (`nl.generiekefuncties.csd` 1.0.0). Their identifier has the type `nl-gf-custodianassignedidentifier`, the profile of the AssignedId slice in those profiles. The invariant `twiin-aid-1` excludes an assigner identified by a KvK number; the URA system of the assigner is the one GF Addressing prescribes and is not fixed in this guide.

COW IG defines no profile for the Authorization Cancellation Request Task. FHIR R4 does not allow HealthcareService as a target of Task.requester, so the requester of this Task identifies the HealthcareService by Reference.identifier only.

Some constraints interpret the TA:

- Task.code of the Authorization Cancellation Request Task ("fixed to abort") and Task.input.type are expressed as patterns, as COW IG does for the Cancellation Request Task.
- The entries with type `supplemental-resource` and `supplemental-query` on the Coordination Task are optional slices that fix the value type (TA section Sharing additional content).
- `twiin-wsub-1` checks the form `owner:identifier=<system>|<value>` of the filter; it cannot check that the identifier is that of a HealthcareService.
- `twiin-task-1` (statusReason.text when statusReason is populated) applies to all three Task profiles, as in the three tables of the TA.

### Invariants

| Key | Severity | Profile | Rule |
|---|---|---|---|
| `twiin-ct-1` | error | Coordination Task | The statuses draft, ready and on-hold are not used |
| `twiin-ct-2` | error | Coordination Task | statusReason not-selected only when the status is cancelled |
| `twiin-ct-3` | error | Coordination Task | businessStatus selected implies code fulfill and for populated |
| `twiin-ct-4` | error | Coordination Task | code request-fulfillment implies for empty |
| `twiin-ct-5` | warning | Coordination Task | statusReason when the status is rejected or cancelled |
| `twiin-ct-6` | warning | Coordination Task | for.identifier does not carry the BSN |
| `twiin-crt-1` | error | Cancellation Request Task | status requested, accepted, rejected, cancelled or entered-in-error |
| `twiin-acrt-1` | error | Authorization Cancellation Request Task | status requested, accepted or rejected |
| `twiin-task-1` | warning | all Task profiles | statusReason.text when statusReason is populated |
| `twiin-aid-1` | error | all Task profiles | The assigner of the identifier of a HealthcareService or Location is not a KvK number |
| `twiin-sr-1` | error | ServiceRequest | subject is not masked with data-absent-reason |
| `twiin-wsub-1` | error | Subscription | Filter of the form `owner:identifier=<system>|<value>` |

### Terminology

| Artifact | TA section |
|---|---|
| [TA Workflow Codes](CodeSystem-ta-workflow.html) | Codes of this TA |
| [TA Workflow Task Code](ValueSet-ta-workflow-task-code.html) | Codes of this TA |

### Capability statement

| Artifact | TA section |
|---|---|
| [Twiin Workflow Placer Server](CapabilityStatement-twiin-workflow-placer-server.html) | Placer server capabilities; Concurrent writes; Search parameters |

The capability statement imports the Twiin Subscription Server of TA Notifications for Subscription. Support for the modifier `:identifier`, and that create on Task is only for the Authorization Cancellation Request Task, are stated in documentation, because a CapabilityStatement has no element for them.

### Examples

| Example | TA section |
|---|---|
| [ServiceRequest: transfer of care](ServiceRequest-0b7c5d0e-6f3a-4c2b-9e1d-8a4f2c6b3d75.html) | Request; Patient context and readability |
| [Patient](Patient-3f6a2b8c-1d4e-4f7a-9b2c-5e8d1a7c4f90.html) | Patient context and readability |
| [Coordination Task: candidate invited](Task-6d2e9f41-8b3c-4a7d-b5e2-1c9f7a3d8e64.html) | Multiple Fulfillers Pattern |
| [Coordination Task: candidate selected](Task-a41c7e2b-5f9d-4e3a-8c6b-2d7f1e9a5b38.html) | Multiple Fulfillers Pattern; Bidding |
| [Coordination Task: candidate not selected](Task-c8e3d5a7-2b4f-4d9e-a1c6-7f3b8e2d4a91.html) | Reason for cancelling a non-selected candidate |
| [Coordination Task: single Fulfiller, in progress](Task-e2f7a9c1-4d6b-4b8e-9a3f-6c1d5e8b2a47.html) | Single Fulfiller Pattern; Sharing additional content |
| [Cancellation Request Task](Task-5b9d3e7f-1a2c-4f6e-8d4b-9e2a7c1f3b56.html) | Cancellation Request (After in-progress) |
| [Authorization Cancellation Request Task](Task-9c4a1f8e-7d3b-4e2a-b6f9-3a8e5d2c7b14.html) | Cancellation by the Fulfiller |
| [Subscription for a HealthcareService](Subscription-1e8b4c6d-3f7a-4b2e-9d5c-8a1f6e3b7c29.html) | Subscription |

The examples are not taken from the TA, which contains none. Hosts, identifiers, the topic URL and the ActivityDefinition URL are invented; the type of work uses SNOMED CT 308292007, which the TA names as the code of eOverdracht.
