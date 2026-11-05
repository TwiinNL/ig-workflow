This page is informative. It shows one scenario in the Multiple Fulfillers Pattern: a selected Fulfiller is deselected before the work starts, the Placer solicits again on the same Request, and another candidate is selected. The requirements are in the TA: Multiple Fulfillers Pattern; Cancellation (Before in-progress); Handling the End of a Coordination Task; Patient context and readability.

One Placer, one [Patient](Patient-3f6a2b8c-1d4e-4f7a-9b2c-5e8d1a7c4f90.html), one Request and three HealthcareServices of three Fulfillers: A (`wondzorg-thuis`), B (`wijkverpleging-noord`) and C (`thuiszorg-zuid`). The type of work is SNOMED CT 308292007 (eOverdracht).

### Steps

| Step | What happens | Instances |
|---|---|---|
| 1 | The Placer invites A and B: one Coordination Task each, code `request-fulfillment`, `for` set at creation, only the type of work in `input`. Both accept. | [A accepted](Task-f8f11d4a-2339-4ef3-9414-b2743d3a5102.html), [B accepted](Task-e74fa5b7-7904-40f5-ba19-d1aed93134ba.html), [Request](ServiceRequest-862e9389-15a3-4681-aa0c-1ebcd5bc17d0.html) |
| 2 | The Placer selects A: `businessStatus` `selected` and code `fulfill` set in one update. The Task of B is cancelled with `statusReason` `not-selected`. `ServiceRequest.performer` is set to A. | [A selected](Task-18d1bd56-33f6-43e0-a3fa-8871a100df12.html), [B not selected](Task-f0299832-a6c0-4517-a8af-0727fab92ee6.html), [Request with performer](ServiceRequest-c6df56d1-5fc1-4abb-bc72-fb260f800832.html) |
| 3 | The patient prefers another facility. The Placer cancels the Task of A before `in-progress`: `status` `cancelled`, the reason in `statusReason.text`, no `not-selected`, because no other candidate has been selected. The Placer clears `ServiceRequest.performer`. The Request stays active. | [A cancelled](Task-4ae98e56-816c-4068-bdce-890a8a24b52f.html), [Request](ServiceRequest-862e9389-15a3-4681-aa0c-1ebcd5bc17d0.html) |
| 4 | The Placer solicits again on the same Request: a new Coordination Task for B, whose earlier Task has ended, and one for C. Both have code `request-fulfillment` and `for` set at creation. | [B invited again](Task-a5c02498-4399-4c8d-aa17-b17023396852.html), [C invited](Task-d4f3456d-86b6-4429-b606-bf52a94ca749.html) |
| 5 | C accepts and the Placer selects C, as in step 2. The new Task of B is cancelled with `not-selected`. `ServiceRequest.performer` is set to C. | [C selected](Task-47ca5941-e107-4c70-bae9-bce09b69311d.html), [B not selected](Task-5dede07b-28ae-4497-bd35-817f5bee9690.html), [Request with performer C](ServiceRequest-5f9a3627-3c42-4f64-9ed4-b6526ea57f65.html) |

### Reading the instances

- **Successive states of one resource.** Instances with the same `Task.identifier` are the same Coordination Task in successive states; the three ServiceRequests with the same `ServiceRequest.identifier` are the same Request in successive states. The TA requires ids to be stable (TA section Identifiers of Tasks and Subscriptions): in reality the id of a Task or a Request does not change, only its content and version. The ids differ here only because the IG holds one instance per id.
- The Request is shown with `performer` unset (steps 1, 3 and 4), set to A (step 2) and set to C (step 5). The Tasks refer to the first variant.
- B has two Coordination Tasks for the same Request, one per solicitation: the first ended at step 2, the second is created at step 4. The Placer may then create new Coordination Tasks for the same Request, also for a Fulfiller whose earlier Coordination Task for that Request has ended (TA section Cancellation (Before in-progress)).
- Between steps 3 and 4 no open Coordination Task refers to the active Request, because the Placer is about to create new ones (TA section Handling the End of a Coordination Task).
- In step 3 the Task of A keeps code `fulfill` and `for`, and `businessStatus` is no longer set: `selected` belongs to status `accepted` (TA section Business status), and the Placer removes it when it cancels the Task of the selected Fulfiller.
- The Task of C in step 5 follows the requirement that the Placer selects only a candidate whose Task has status `accepted`; the instance shows the state after selection.

### Not visible in the instances

When a Coordination Task is cancelled, the Placer ends the read access of its owner to the Request and the Patient resource, also after selection. In step 2 this concerns B, in step 3 A, in step 5 B. This is access control and is not expressed in the instances.
