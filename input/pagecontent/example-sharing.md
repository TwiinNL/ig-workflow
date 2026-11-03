This page is informative. It shows how the Placer shares additional content in Task.input, before and after selection, and how a candidate asks for information. The requirements are in the TA: Sharing additional content; Business status; Patient context and readability.

One Placer, one [Patient](Patient-3f6a2b8c-1d4e-4f7a-9b2c-5e8d1a7c4f90.html), one [Request](ServiceRequest-3e358483-ec50-469b-94d0-54b6bc5ea7d8.html) and one candidate, the HealthcareService `wondzorg-thuis`. The type of work is SNOMED CT 308292007 (eOverdracht).

### Steps

| Step | What happens | Instance |
|---|---|---|
| 1 | Before selection the Placer invites the candidate and adds an entry to `input` with its content inline, not as a reference, since a candidate may not read resources at the Placer before selection. The content does not identify the patient. | [Content shared](Task-7dc145b2-78c9-45db-ab56-267c664be4c3.html) |
| 2 | The candidate accepts, sets `businessStatus` `awaiting-information` and states in `statusReason.text` what it needs. | [Awaits information](Task-c8ca1ec3-dd83-4900-9bfa-a05d6e93782c.html) |
| 3 | The Placer answers by updating `input`: it adds an entry, again with its content inline. | [Placer answers](Task-b5e65e9b-434f-445c-924d-ff772c25ae4d.html) |
| 4 | The candidate removes `businessStatus` and `statusReason`. | [Has the information](Task-e1e3f55f-c56e-4501-b409-ed05bb70cc87.html) |
| 5 | The Placer selects the candidate and, in the same update, adds an entry with type `supplemental-resource` that refers to a resource at the Placer, here an [updated wound assessment](Observation-8d97c695-4ece-45fb-96e0-a216398978fa.html). | [Selected](Task-66507516-150c-415f-9e88-7c1f24eef69c.html) |

### Reading the instances

- Instances with the same `Task.identifier` are the same Coordination Task in successive states. The TA requires ids to be stable (TA section Identifiers of Tasks and Subscriptions): in reality the id of the Task does not change. The ids differ here only because the IG holds one instance per id.
- The types `Dressing type` and `Dressing change interval` of the entries before selection are fictitious. They are not codes of the TA: the care domain defines the type of such entries, and the use case defines the type and states why the content is not identifying (TA section Patient context and readability). The TA defines only the types `supplemental-resource` and `supplemental-query`; these are added at selection, not before.
- Only the Placer sets and changes `Task.input`; the Fulfiller changes `businessStatus` and `statusReason` (TA section Write access).
- In step 5 the Placer sets `selected`, which is reserved for the Placer (TA section Write access).
