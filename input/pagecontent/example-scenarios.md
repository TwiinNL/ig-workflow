This page is informative. It shows the main scenarios of TA Workflow with their own instances. The requirements are in the TA. Instances with the same `Task.identifier` (or `ServiceRequest.identifier`) are one resource in successive states; the ids differ only because the IG holds one instance per id (TA section Identifiers of Tasks and Subscriptions). The type of work is SNOMED CT 308292007 (eOverdracht); hosts, identifiers and the topic URL are invented.

### Standard dataset and available entries

A standard dataset, described by the Library of the ActivityDefinition or PlanDefinition in `ServiceRequest.instantiatesCanonical`, is a guideline for what a Fulfiller expects, not a requirement. The Placer states for each Request what it makes available, in `Task.input` entries with type `available-resource` (a reference in `valueReference`) or `available-query` (a search in `valueString`, relative to the Placer's FHIR base). It adds them when it selects the candidate, at creation in the Single Fulfiller Pattern, or where the use case makes the Patient readable before selection. The Fulfiller retrieves what these entries refer to, and may ask for missing information with an `information-request` entry (scenario 7). The Placer's server supports the reads and searches behind the entries it puts in `Task.input`; it is not required to support the searches of the dataset itself.

### 1. Single Fulfiller

| Step | What happens | Instances |
|---|---|---|
| 1 | The Placer creates the Coordination Task with code `fulfill`, `for` set and the available entries. `ServiceRequest.performer` refers to A; `priority` is populated. | [Request](ServiceRequest-c682d130-33be-4bd5-a2b5-6677aead5ad9.html), [created](Task-5fe23d95-5f8d-4f9d-9315-7d7979153e2a.html) |
| 2 | The Fulfiller accepts. | [accepted](Task-f99620ae-3d81-4e74-915e-c9dc12771355.html) |
| 3 | The Fulfiller starts the work: `in-progress`, `executionPeriod.start`. | [in progress](Task-fcf2352b-4027-45ea-8cd3-002dbebc3d7a.html) |
| 4 | The Fulfiller completes the work: `completed`, `executionPeriod.end`. | [completed](Task-7b4e4d93-be6d-4511-a2b0-0d141fa362e6.html) |

### 2. Multiple Fulfillers with bidding and selection

| Step | What happens | Instances |
|---|---|---|
| 1 | One Request, two candidates A and B, each with a Coordination Task with code `request-fulfillment` and `for` empty. Each candidate may read the Request from the creation of its Coordination Task; until selection the Placer keeps data that directly identifies the patient out of the Request. Both accept and record a bid in `output`. | [Request](ServiceRequest-7e83a049-2267-4ca0-9d35-07216dfec2b6.html), [A accepted](Task-12e3afcc-3979-476c-bc59-8e8e4e40afb9.html), [B accepted](Task-66bb48ed-2053-4fa4-ae26-4aba6ad37e5d.html) |
| 2 | The Placer selects A: code `fulfill`, `businessStatus` `selected` and `for` in one update, with the available entries. From code `fulfill` on, A may read the Patient. The Task of B is cancelled with `statusReason` `not-selected`. | [A selected](Task-5932fe26-950a-481f-8fc3-fa792e1d318f.html), [B not selected](Task-4e1168c4-0d2d-434f-a44e-bd117d0780d2.html) |

### 3. Deselection and renewed solicitation

See [Example: reselection](example-reselection.html): the Coordination Task of the selected Fulfiller is cancelled before `in-progress` while the Request stays active, and a new Coordination Task is created for the same Request.

### 4. Cancellation before in-progress by the Placer

| Step | What happens | Instances |
|---|---|---|
| 1 | The Fulfiller has accepted; the work has not started. | [Request](ServiceRequest-57129653-f261-4841-9e42-e5b40b57f6fb.html), [accepted](Task-46ebdfdd-408a-4340-915d-980a14c75f36.html) |
| 2 | The Placer sets the Coordination Task to `cancelled`, with its reason in `statusReason.text`. | [cancelled](Task-cd47fb57-917b-4cd4-86d7-38ccb3bbeef9.html) |

### 5. Cancellation Request after in-progress

| Step | What happens | Instances |
|---|---|---|
| 1 | The work is in progress. | [Request active](ServiceRequest-e7e34041-dbd1-4413-be25-e08e2f85a7e4.html), [in progress](Task-f3bdd83f-0914-4232-94e9-28a01b1d36af.html) |
| 2 | The Placer creates a Cancellation Request Task: code `abort`, `focus` the Coordination Task, reason in `reasonCode`. | [requested](Task-c2b03781-d9f7-40e2-ba3d-d68d47f055b5.html) |
| 3 | The Fulfiller accepts it and sets the Coordination Task to `cancelled` (not `failed`), with `executionPeriod.end`. | [accepted](Task-444cd124-7855-43ab-85b6-87bede5a8c49.html), [Coordination Task cancelled](Task-66689cbb-33d1-4159-8ce2-d5fa970577a9.html) |
| 4 | The Placer revokes the Request. | [Request revoked](ServiceRequest-462d6275-922e-434a-a379-96fd4a29548b.html) |

### 6. Authorization Cancellation Request by the Fulfiller

| Step | What happens | Instances |
|---|---|---|
| 1 | The Fulfiller of scenario 1 asks the Placer to withdraw the Request: `intent` `proposal`, code `abort`, `focus` the Request, reason in `reasonCode`. | [requested](Task-5e2888cb-fd37-4328-bfa7-45a9e1a047ff.html) |
| 2 | The Placer accepts. | [accepted](Task-fb3a4ac7-3f98-45cf-acd6-95b18e688d6b.html) |

### 7. Information request

| Step | What happens | Instances |
|---|---|---|
| 1 | The Fulfiller sets `businessStatus` `awaiting-information` with `statusReason.text`, and adds an entry with type `information-request` to `input`. | [requests information](Task-683af045-b470-4595-b80d-cd40c92da2f7.html) |
| 2 | The Placer answers with a further entry with type `available-resource`, referring to a [wound assessment](Observation-d5f9a2c1-3e68-4b7d-a4f0-2c9e8b1d6f43.html). | [Placer answers](Task-71af91f0-f5ec-42cf-9b48-75b74d0036a0.html) |
| 3 | The Fulfiller removes `businessStatus`, `statusReason` and its `information-request` entry. | [has the information](Task-b8d24f6e-1c37-4a59-9f02-6e1a7c4b8d35.html) |

The Fulfiller may change only `status`, `businessStatus`, `statusReason`, `executionPeriod`, `lastModified` and `output`, and may add and remove entries with type `information-request` in `input`; the type `information-request` is reserved for the Fulfiller. All other `input` entries are set by the Placer (TA section Write access).

### Subscriptions

| Filter | Instance |
|---|---|
| `owner:identifier=[system]|[value]`, one HealthcareService | [Subscription for a HealthcareService](Subscription-1e8b4c6d-3f7a-4b2e-9d5c-8a1f6e3b7c29.html) |
| `owner-assigner=[system]|[value]`, all HealthcareServices of one organization, also those registered later | [Subscription for an organization](Subscription-e0a7c3b9-5d14-4f82-b6e9-8a2d4c7f1b06.html) |

Per organization, topic and base URL, a Fulfiller has either one Subscription per HealthcareService or one Subscription for the organization, not both. For a Subscription on `owner-assigner`, `channel.endpoint` begins with the address of an Endpoint with payloadType Notification in `Organization.endpoint`.
