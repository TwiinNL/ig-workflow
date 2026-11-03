// Scenario: a selected Fulfiller is deselected before the work starts, the Placer solicits again on
// the same Request, and another candidate is selected (see the page Example: reselection).
// Fulfillers A and B are those of examples.fsh; C is defined here.
// One instance exists per state. The IG holds one instance per id, so the same Coordination Task in
// two states has two ids and one Task.identifier.value.

RuleSet: OwnerC
* owner.type = "HealthcareService"
* insert AssignedId(owner.identifier, https://fulfiller-c.example.org/healthcareservice, thuiszorg-zuid, 55667788)

RuleSet: ReselectionTaskBase(focus)
* intent = #order
* focus = Reference(ServiceRequest/{focus})
* insert PlacerRequester
* insert TypeOfWork

// code fulfill, businessStatus selected and for are set in the same update (twiin-ct-3).
RuleSet: ReselectionSelected
* status = #accepted
* businessStatus = TAWorkflowCS#selected
* code = $task-code#fulfill
* for = Reference(Patient/3f6a2b8c-1d4e-4f7a-9b2c-5e8d1a7c4f90)

RuleSet: ReselectionNotSelected
* status = #cancelled
* statusReason = TAWorkflowCS#not-selected
* statusReason.text = "not selected"
* code = TAWorkflowCS#request-fulfillment

// The Request in the state after step 1, 3 and 4: performer unset.
Instance: 862e9389-15a3-4681-aa0c-1ebcd5bc17d0
InstanceOf: TwiinWorkflowServiceRequest
Usage: #example
Title: "ServiceRequest: reselection, performer unset"
Description: "The Request of the reselection scenario while solicitation is open: performer unset (TA section Multiple Fulfillers Pattern). This is its state at steps 1, 3 and 4, and the state to which the Coordination Tasks of the scenario refer. Same identifier as the other two variants: they are one resource in successive states."
* identifier.system = "https://placer.example.org/servicerequest"
* identifier.value = "7f9709d8-455e-432b-9ace-1cd1be7426d5"
* status = #active
* intent = #order
* instantiatesCanonical = "https://example.org/fhir/ActivityDefinition/transfer-of-care"
* code = $sct#308292007
* subject = Reference(Patient/3f6a2b8c-1d4e-4f7a-9b2c-5e8d1a7c4f90)
* authoredOn = "2026-10-14T08:50:00+02:00"

Instance: c6df56d1-5fc1-4abb-bc72-fb260f800832
InstanceOf: TwiinWorkflowServiceRequest
Usage: #example
Title: "ServiceRequest: reselection step 2, performer set to A"
Description: "The Request of the reselection scenario at step 2, after A was selected: performer refers to the HealthcareService of A (TA section Multiple Fulfillers Pattern). At step 3 the Placer clears performer again; that state is the Request with performer unset. Same identifier as the other variants."
* identifier.system = "https://placer.example.org/servicerequest"
* identifier.value = "7f9709d8-455e-432b-9ace-1cd1be7426d5"
* status = #active
* intent = #order
* instantiatesCanonical = "https://example.org/fhir/ActivityDefinition/transfer-of-care"
* code = $sct#308292007
* subject = Reference(Patient/3f6a2b8c-1d4e-4f7a-9b2c-5e8d1a7c4f90)
* authoredOn = "2026-10-14T08:50:00+02:00"
* performer.type = "HealthcareService"
* insert AssignedId(performer.identifier, https://fulfiller-a.example.org/healthcareservice, wondzorg-thuis, 87654321)

Instance: 5f9a3627-3c42-4f64-9ed4-b6526ea57f65
InstanceOf: TwiinWorkflowServiceRequest
Usage: #example
Title: "ServiceRequest: reselection step 5, performer set to C"
Description: "The Request of the reselection scenario at step 5, after C was selected: performer refers to the HealthcareService of C (TA section Multiple Fulfillers Pattern). Same identifier as the other two variants: they are one resource in successive states."
* identifier.system = "https://placer.example.org/servicerequest"
* identifier.value = "7f9709d8-455e-432b-9ace-1cd1be7426d5"
* status = #active
* intent = #order
* instantiatesCanonical = "https://example.org/fhir/ActivityDefinition/transfer-of-care"
* code = $sct#308292007
* subject = Reference(Patient/3f6a2b8c-1d4e-4f7a-9b2c-5e8d1a7c4f90)
* authoredOn = "2026-10-14T08:50:00+02:00"
* performer.type = "HealthcareService"
* insert AssignedId(performer.identifier, https://fulfiller-c.example.org/healthcareservice, thuiszorg-zuid, 55667788)

// Step 1: A and B invited, both accepted.
Instance: f8f11d4a-2339-4ef3-9414-b2743d3a5102
InstanceOf: TwiinCoordinationTask
Usage: #example
Title: "Coordination Task: reselection step 1, A accepted"
Description: "Step 1. The Coordination Task of candidate A after A accepted: code request-fulfillment, for empty, only the type of work in input (TA sections Multiple Fulfillers Pattern; Patient context and readability)."
* identifier.system = "https://placer.example.org/task"
* identifier.value = "30ebfbf0-5ef0-47ad-9074-c98ca310a5ce"
* status = #accepted
* code = TAWorkflowCS#request-fulfillment
* authoredOn = "2026-10-14T09:00:00+02:00"
* insert ReselectionTaskBase(862e9389-15a3-4681-aa0c-1ebcd5bc17d0)
* insert OwnerA
* lastModified = "2026-10-14T09:40:00+02:00"

Instance: e74fa5b7-7904-40f5-ba19-d1aed93134ba
InstanceOf: TwiinCoordinationTask
Usage: #example
Title: "Coordination Task: reselection step 1, B accepted"
Description: "Step 1. The Coordination Task of candidate B after B accepted: code request-fulfillment, for empty, only the type of work in input (TA sections Multiple Fulfillers Pattern; Patient context and readability)."
* identifier.system = "https://placer.example.org/task"
* identifier.value = "f49d7ad6-4e18-48b2-875f-3a97cdf119be"
* status = #accepted
* code = TAWorkflowCS#request-fulfillment
* authoredOn = "2026-10-14T09:00:00+02:00"
* insert ReselectionTaskBase(862e9389-15a3-4681-aa0c-1ebcd5bc17d0)
* insert OwnerB
* lastModified = "2026-10-14T09:55:00+02:00"

// Step 2: A selected, B not selected.
Instance: 18d1bd56-33f6-43e0-a3fa-8871a100df12
InstanceOf: TwiinCoordinationTask
Usage: #example
Title: "Coordination Task: reselection step 2, A selected"
Description: "Step 2. The Coordination Task of A when the Placer selects A: businessStatus selected, code fulfill and for set in the same update (TA sections Multiple Fulfillers Pattern; Patient context and readability). The Request has performer set to A."
* identifier.system = "https://placer.example.org/task"
* identifier.value = "30ebfbf0-5ef0-47ad-9074-c98ca310a5ce"
* insert ReselectionSelected
* authoredOn = "2026-10-14T09:00:00+02:00"
* insert ReselectionTaskBase(862e9389-15a3-4681-aa0c-1ebcd5bc17d0)
* insert OwnerA
* lastModified = "2026-10-14T11:00:00+02:00"

Instance: f0299832-a6c0-4517-a8af-0727fab92ee6
InstanceOf: TwiinCoordinationTask
Usage: #example
Title: "Coordination Task: reselection step 2, B not selected"
Description: "Step 2. The Coordination Task of B when A is selected: status cancelled with statusReason not-selected (TA section Reason for cancelling a non-selected candidate)."
* identifier.system = "https://placer.example.org/task"
* identifier.value = "f49d7ad6-4e18-48b2-875f-3a97cdf119be"
* insert ReselectionNotSelected
* authoredOn = "2026-10-14T09:00:00+02:00"
* insert ReselectionTaskBase(862e9389-15a3-4681-aa0c-1ebcd5bc17d0)
* insert OwnerB
* lastModified = "2026-10-14T11:00:00+02:00"

// Step 3: A deselected before in-progress. No not-selected: no other candidate is selected.
Instance: 4ae98e56-816c-4068-bdce-890a8a24b52f
InstanceOf: TwiinCoordinationTask
Usage: #example
Title: "Coordination Task: reselection step 3, A cancelled"
Description: "Step 3. The Placer cancels the Coordination Task of the selected A before in-progress, while the Request continues (TA section Cancellation (Before in-progress)). statusReason.text gives the reason; the code not-selected is not used, because no other candidate has been selected. The Request has performer unset again."
* identifier.system = "https://placer.example.org/task"
* identifier.value = "30ebfbf0-5ef0-47ad-9074-c98ca310a5ce"
* status = #cancelled
* statusReason.text = "The patient prefers another facility."
* code = $task-code#fulfill
* for = Reference(Patient/3f6a2b8c-1d4e-4f7a-9b2c-5e8d1a7c4f90)
* authoredOn = "2026-10-14T09:00:00+02:00"
* insert ReselectionTaskBase(862e9389-15a3-4681-aa0c-1ebcd5bc17d0)
* insert OwnerA
* lastModified = "2026-10-15T10:00:00+02:00"

// Step 4: B again (new Task) and C.
Instance: a5c02498-4399-4c8d-aa17-b17023396852
InstanceOf: TwiinCoordinationTask
Usage: #example
Title: "Coordination Task: reselection step 4, B invited again"
Description: "Step 4. A new Coordination Task for B on the same Request, after the earlier Task of B ended (TA sections Multiple Fulfillers Pattern; Handling the End of a Coordination Task). code request-fulfillment, for empty."
* identifier.system = "https://placer.example.org/task"
* identifier.value = "3c4f69f2-1091-4d50-8747-319b5c876215"
* status = #requested
* code = TAWorkflowCS#request-fulfillment
* authoredOn = "2026-10-15T10:05:00+02:00"
* insert ReselectionTaskBase(862e9389-15a3-4681-aa0c-1ebcd5bc17d0)
* insert OwnerB

Instance: d4f3456d-86b6-4429-b606-bf52a94ca749
InstanceOf: TwiinCoordinationTask
Usage: #example
Title: "Coordination Task: reselection step 4, C invited"
Description: "Step 4. A Coordination Task for the new candidate C on the same Request (TA sections Multiple Fulfillers Pattern; Patient context and readability). code request-fulfillment, for empty."
* identifier.system = "https://placer.example.org/task"
* identifier.value = "0140e816-86e8-44f1-a91d-c04e72b49ed2"
* status = #requested
* code = TAWorkflowCS#request-fulfillment
* authoredOn = "2026-10-15T10:05:00+02:00"
* insert ReselectionTaskBase(862e9389-15a3-4681-aa0c-1ebcd5bc17d0)
* insert OwnerC

// Step 5: C selected (it has accepted), B not selected.
Instance: 47ca5941-e107-4c70-bae9-bce09b69311d
InstanceOf: TwiinCoordinationTask
Usage: #example
Title: "Coordination Task: reselection step 5, C selected"
Description: "Step 5. The Coordination Task of C when the Placer selects C, after C accepted (TA section Multiple Fulfillers Pattern: the Placer selects only a candidate whose Task has status accepted). businessStatus selected, code fulfill and for set in the same update."
* identifier.system = "https://placer.example.org/task"
* identifier.value = "0140e816-86e8-44f1-a91d-c04e72b49ed2"
* insert ReselectionSelected
* authoredOn = "2026-10-15T10:05:00+02:00"
* insert ReselectionTaskBase(862e9389-15a3-4681-aa0c-1ebcd5bc17d0)
* insert OwnerC
* lastModified = "2026-10-16T09:30:00+02:00"

Instance: 5dede07b-28ae-4497-bd35-817f5bee9690
InstanceOf: TwiinCoordinationTask
Usage: #example
Title: "Coordination Task: reselection step 5, B not selected"
Description: "Step 5. The new Coordination Task of B when C is selected: status cancelled with statusReason not-selected (TA section Reason for cancelling a non-selected candidate)."
* identifier.system = "https://placer.example.org/task"
* identifier.value = "3c4f69f2-1091-4d50-8747-319b5c876215"
* insert ReselectionNotSelected
* authoredOn = "2026-10-15T10:05:00+02:00"
* insert ReselectionTaskBase(862e9389-15a3-4681-aa0c-1ebcd5bc17d0)
* insert OwnerB
* lastModified = "2026-10-16T09:30:00+02:00"
