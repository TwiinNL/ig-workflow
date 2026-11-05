// Scenarios of the page Example scenarios. Fulfillers A and B, the Patient, PlacerRequester,
// TypeOfWork and AssignedId are those of examples.fsh. One instance exists per state; instances with
// the same Task.identifier.value (or ServiceRequest.identifier.value) are one resource in successive
// states. The IG holds one instance per id, so the ids differ.

RuleSet: ScenarioTask(focus, identifier)
* intent = #order
* for = Reference(Patient/3f6a2b8c-1d4e-4f7a-9b2c-5e8d1a7c4f90)
* focus = Reference(ServiceRequest/{focus})
* identifier.system = "https://placer.example.org/task"
* identifier.value = "{identifier}"
* insert PlacerRequester
* insert TypeOfWork

RuleSet: ScenarioRequest(identifier, authoredOn)
* identifier.system = "https://placer.example.org/servicerequest"
* identifier.value = "{identifier}"
* intent = #order
* instantiatesCanonical = "https://example.org/fhir/ActivityDefinition/transfer-of-care"
* code = $sct#308292007
* subject = Reference(Patient/3f6a2b8c-1d4e-4f7a-9b2c-5e8d1a7c4f90)
* authoredOn = "{authoredOn}"

RuleSet: PerformerA
* performer.type = "HealthcareService"
* insert AssignedId(performer.identifier, https://fulfiller-a.example.org/healthcareservice, wondzorg-thuis, 87654321)

RuleSet: FulfillA
* code = $task-code#fulfill
* for = Reference(Patient/3f6a2b8c-1d4e-4f7a-9b2c-5e8d1a7c4f90)
* insert OwnerA

// The entries the Placer makes available, after the type of work.
RuleSet: AvailableEntries
* input[availableResource].type = TAWorkflowCS#available-resource
* input[availableResource].valueReference = Reference(Patient/3f6a2b8c-1d4e-4f7a-9b2c-5e8d1a7c4f90)
* input[availableQuery].type = TAWorkflowCS#available-query
* input[availableQuery].valueString = "Observation?patient=3f6a2b8c-1d4e-4f7a-9b2c-5e8d1a7c4f90&category=vital-signs"

// ---------------------------------------------------------------------------------------------
// Scenario 1: Single Fulfiller.

Instance: c682d130-33be-4bd5-a2b5-6677aead5ad9
InstanceOf: TwiinWorkflowServiceRequest
Usage: #example
Title: "Scenario 1: Request, single Fulfiller"
Description: "The Request of scenario 1. The Single Fulfiller Pattern applies: performer refers to the HealthcareService of A. priority is populated, as the Placer SHOULD do."
* status = #active
* priority = #urgent
* insert ScenarioRequest(1b9e0c5a-4f0e-4a8e-9d4c-2f7a1e6b3c58, 2026-11-02T08:50:00+01:00)
* insert PerformerA

Instance: 5fe23d95-5f8d-4f9d-9315-7d7979153e2a
InstanceOf: TwiinCoordinationTask
Usage: #example
Title: "Scenario 1, step 1: created"
Description: "The Placer creates the Coordination Task with code fulfill, and with the entries it makes available, since in the Single Fulfiller Pattern there is no selection."
* status = #requested
* authoredOn = "2026-11-02T09:00:00+01:00"
* insert ScenarioTask(c682d130-33be-4bd5-a2b5-6677aead5ad9, 12d4c5d1-e6cb-432f-b195-7a4dc2da47be)
* insert FulfillA
* insert LocationA
* insert AvailableEntries

Instance: f99620ae-3d81-4e74-915e-c9dc12771355
InstanceOf: TwiinCoordinationTask
Usage: #example
Title: "Scenario 1, step 2: accepted"
Description: "The Fulfiller accepts the Coordination Task."
* status = #accepted
* authoredOn = "2026-11-02T09:00:00+01:00"
* lastModified = "2026-11-02T10:15:00+01:00"
* insert ScenarioTask(c682d130-33be-4bd5-a2b5-6677aead5ad9, 12d4c5d1-e6cb-432f-b195-7a4dc2da47be)
* insert FulfillA
* insert LocationA
* insert AvailableEntries

Instance: fcf2352b-4027-45ea-8cd3-002dbebc3d7a
InstanceOf: TwiinCoordinationTask
Usage: #example
Title: "Scenario 1, step 3: in progress"
Description: "The Fulfiller starts the work: status in-progress and executionPeriod.start."
* status = #in-progress
* authoredOn = "2026-11-02T09:00:00+01:00"
* lastModified = "2026-11-03T08:00:00+01:00"
* executionPeriod.start = "2026-11-03T08:00:00+01:00"
* insert ScenarioTask(c682d130-33be-4bd5-a2b5-6677aead5ad9, 12d4c5d1-e6cb-432f-b195-7a4dc2da47be)
* insert FulfillA
* insert LocationA
* insert AvailableEntries

Instance: 7b4e4d93-be6d-4511-a2b0-0d141fa362e6
InstanceOf: TwiinCoordinationTask
Usage: #example
Title: "Scenario 1, step 4: completed"
Description: "The Fulfiller completes the work: status completed and executionPeriod.end set when the status moves from in-progress."
* status = #completed
* authoredOn = "2026-11-02T09:00:00+01:00"
* lastModified = "2026-11-03T16:30:00+01:00"
* executionPeriod.start = "2026-11-03T08:00:00+01:00"
* executionPeriod.end = "2026-11-03T16:30:00+01:00"
* insert ScenarioTask(c682d130-33be-4bd5-a2b5-6677aead5ad9, 12d4c5d1-e6cb-432f-b195-7a4dc2da47be)
* insert FulfillA
* insert LocationA
* insert AvailableEntries

// ---------------------------------------------------------------------------------------------
// Scenario 2: Multiple Fulfillers with bidding and selection.

Instance: 7e83a049-2267-4ca0-9d35-07216dfec2b6
InstanceOf: TwiinWorkflowServiceRequest
Usage: #example
Title: "Scenario 2: Request, multiple Fulfillers"
Description: "The Request of scenario 2. performer is unset: the Multiple Fulfillers Pattern applies. Candidates may read the Request from the creation of their Coordination Task; the Request contains no data that directly identifies the patient beyond the reference in subject."
* status = #active
* priority = #routine
* insert ScenarioRequest(9a4d7e21-6c3b-4f58-b0e2-7d1c5a8f3e96, 2026-11-02T10:50:00+01:00)

RuleSet: Scenario2A
* authoredOn = "2026-11-02T11:00:00+01:00"
* insert ScenarioTask(7e83a049-2267-4ca0-9d35-07216dfec2b6, aef0b40c-fa1e-4748-9b47-317d11c3de9c)
* insert OwnerA

RuleSet: Scenario2B
* authoredOn = "2026-11-02T11:00:00+01:00"
* insert ScenarioTask(7e83a049-2267-4ca0-9d35-07216dfec2b6, 44630c0f-e5e8-43b7-9ba3-20598cb2b36e)
* insert OwnerB

Instance: 12e3afcc-3979-476c-bc59-8e8e4e40afb9
InstanceOf: TwiinCoordinationTask
Usage: #example
Title: "Scenario 2, step 1: A accepted with a bid"
Description: "Candidate A accepts its Coordination Task (code request-fulfillment) and records a bid in output."
* status = #accepted
* code = TAWorkflowCS#request-fulfillment
* lastModified = "2026-11-02T12:00:00+01:00"
* insert Scenario2A
* output[0].type.text = "Bid"
* output[0].valueString = "First visit possible on 2026-11-04"

Instance: 66bb48ed-2053-4fa4-ae26-4aba6ad37e5d
InstanceOf: TwiinCoordinationTask
Usage: #example
Title: "Scenario 2, step 1: B accepted with a bid"
Description: "Candidate B accepts its Coordination Task (code request-fulfillment) and records a bid in output."
* status = #accepted
* code = TAWorkflowCS#request-fulfillment
* lastModified = "2026-11-02T12:20:00+01:00"
* insert Scenario2B
* output[0].type.text = "Bid"
* output[0].valueString = "First visit possible on 2026-11-06"

Instance: 5932fe26-950a-481f-8fc3-fa792e1d318f
InstanceOf: TwiinCoordinationTask
Usage: #example
Title: "Scenario 2, step 2: A selected"
Description: "The Placer selects A: businessStatus selected, code fulfill set in one update, together with the entries with type available-resource and available-query that it makes available."
* status = #accepted
* businessStatus = TAWorkflowCS#selected
* code = $task-code#fulfill
* for = Reference(Patient/3f6a2b8c-1d4e-4f7a-9b2c-5e8d1a7c4f90)
* lastModified = "2026-11-02T14:00:00+01:00"
* insert Scenario2A
* insert AvailableEntries
* output[0].type.text = "Bid"
* output[0].valueString = "First visit possible on 2026-11-04"

Instance: 4e1168c4-0d2d-434f-a44e-bd117d0780d2
InstanceOf: TwiinCoordinationTask
Usage: #example
Title: "Scenario 2, step 2: B not selected"
Description: "In the same step the Placer cancels the Coordination Task of B with statusReason not-selected."
* status = #cancelled
* statusReason = TAWorkflowCS#not-selected
* statusReason.text = "not selected"
* code = TAWorkflowCS#request-fulfillment
* lastModified = "2026-11-02T14:00:00+01:00"
* insert Scenario2B
* output[0].type.text = "Bid"
* output[0].valueString = "First visit possible on 2026-11-06"

// ---------------------------------------------------------------------------------------------
// Scenario 4: cancellation before in-progress by the Placer.

Instance: 57129653-f261-4841-9e42-e5b40b57f6fb
InstanceOf: TwiinWorkflowServiceRequest
Usage: #example
Title: "Scenario 4: Request"
Description: "The Request of scenario 4, Single Fulfiller Pattern."
* status = #active
* insert ScenarioRequest(3c8f1b6d-2e7a-4d95-8b40-6f1e9c2a7d53, 2026-11-03T08:50:00+01:00)
* insert PerformerA

Instance: 46ebdfdd-408a-4340-915d-980a14c75f36
InstanceOf: TwiinCoordinationTask
Usage: #example
Title: "Scenario 4, step 1: accepted"
Description: "The Fulfiller has accepted; the work has not started."
* status = #accepted
* authoredOn = "2026-11-03T09:00:00+01:00"
* lastModified = "2026-11-03T09:30:00+01:00"
* insert ScenarioTask(57129653-f261-4841-9e42-e5b40b57f6fb, cd23bb81-315c-4712-b5db-89a56caed447)
* insert FulfillA

Instance: cd47fb57-917b-4cd4-86d7-38ccb3bbeef9
InstanceOf: TwiinCoordinationTask
Usage: #example
Title: "Scenario 4, step 2: cancelled by the Placer"
Description: "Before in-progress the Placer cancels the Coordination Task itself, with its reason in statusReason.text."
* status = #cancelled
* statusReason.text = "The patient no longer needs the service."
* authoredOn = "2026-11-03T09:00:00+01:00"
* lastModified = "2026-11-03T11:00:00+01:00"
* insert ScenarioTask(57129653-f261-4841-9e42-e5b40b57f6fb, cd23bb81-315c-4712-b5db-89a56caed447)
* insert FulfillA

// ---------------------------------------------------------------------------------------------
// Scenario 5: Cancellation Request after in-progress.

Instance: e7e34041-dbd1-4413-be25-e08e2f85a7e4
InstanceOf: TwiinWorkflowServiceRequest
Usage: #example
Title: "Scenario 5, step 1: Request active"
Description: "The Request of scenario 5 while the work is in progress."
* status = #active
* insert ScenarioRequest(200a94a8-7f0d-450a-b9ad-45e5861c1c92, 2026-11-03T12:50:00+01:00)
* insert PerformerA

Instance: f3bdd83f-0914-4232-94e9-28a01b1d36af
InstanceOf: TwiinCoordinationTask
Usage: #example
Title: "Scenario 5, step 1: in progress"
Description: "The Fulfiller has started the work."
* status = #in-progress
* authoredOn = "2026-11-03T13:00:00+01:00"
* lastModified = "2026-11-04T08:00:00+01:00"
* executionPeriod.start = "2026-11-04T08:00:00+01:00"
* insert ScenarioTask(e7e34041-dbd1-4413-be25-e08e2f85a7e4, 7e85fd28-36fc-4b39-a0ca-822d7a1dea61)
* insert FulfillA

RuleSet: Scenario5CancellationRequest
* code = $task-code#abort
* focus = Reference(Task/f3bdd83f-0914-4232-94e9-28a01b1d36af)
* authoredOn = "2026-11-04T10:00:00+01:00"
* identifier.system = "https://placer.example.org/task"
* identifier.value = "72c37bd8-b443-4aad-a25b-684451a5b190"
* reasonCode.text = "The patient has been admitted to hospital."
* insert PlacerRequester
* insert OwnerA
* insert TypeOfWork

Instance: c2b03781-d9f7-40e2-ba3d-d68d47f055b5
InstanceOf: TwiinCancellationRequestTask
Usage: #example
Title: "Scenario 5, step 2: Cancellation Request Task requested"
Description: "The Placer asks the Fulfiller to stop the work, with its reason in reasonCode."
* status = #requested
* intent = #order
* insert Scenario5CancellationRequest

Instance: 444cd124-7855-43ab-85b6-87bede5a8c49
InstanceOf: TwiinCancellationRequestTask
Usage: #example
Title: "Scenario 5, step 3: Cancellation Request Task accepted"
Description: "The Fulfiller accepts the Cancellation Request Task."
* status = #accepted
* intent = #order
* lastModified = "2026-11-04T10:30:00+01:00"
* insert Scenario5CancellationRequest

Instance: 66689cbb-33d1-4159-8ce2-d5fa970577a9
InstanceOf: TwiinCoordinationTask
Usage: #example
Title: "Scenario 5, step 3: cancelled after the Cancellation Request"
Description: "After accepting the Cancellation Request Task the Fulfiller sets the Coordination Task to cancelled (not failed) and sets executionPeriod.end."
* status = #cancelled
* statusReason.text = "Stopped at the request of the Placer."
* authoredOn = "2026-11-03T13:00:00+01:00"
* lastModified = "2026-11-04T10:30:00+01:00"
* executionPeriod.start = "2026-11-04T08:00:00+01:00"
* executionPeriod.end = "2026-11-04T10:30:00+01:00"
* insert ScenarioTask(e7e34041-dbd1-4413-be25-e08e2f85a7e4, 7e85fd28-36fc-4b39-a0ca-822d7a1dea61)
* insert FulfillA

Instance: 462d6275-922e-434a-a379-96fd4a29548b
InstanceOf: TwiinWorkflowServiceRequest
Usage: #example
Title: "Scenario 5, step 4: Request revoked"
Description: "The Placer revokes the Request. Same identifier as step 1: one resource in successive states."
* status = #revoked
* insert ScenarioRequest(200a94a8-7f0d-450a-b9ad-45e5861c1c92, 2026-11-03T12:50:00+01:00)
* insert PerformerA

// ---------------------------------------------------------------------------------------------
// Scenario 6: Authorization Cancellation Request by the Fulfiller.

RuleSet: Scenario6
* intent = #proposal
* code = $task-code#abort
* focus = Reference(ServiceRequest/c682d130-33be-4bd5-a2b5-6677aead5ad9)
* authoredOn = "2026-11-03T12:00:00+01:00"
* reasonCode.text = "The wound requires specialist care that we cannot provide."
* requester.identifier.system = $ura
* requester.identifier.value = "87654321"
* owner.identifier.system = $ura
* owner.identifier.value = "12345678"

Instance: 5e2888cb-fd37-4328-bfa7-45a9e1a047ff
InstanceOf: TwiinAuthorizationCancellationRequestTask
Usage: #example
Title: "Scenario 6, step 1: Authorization Cancellation Request requested"
Description: "The Fulfiller asks the Placer to withdraw the Request: intent proposal, code abort, focus the Request, reason in reasonCode."
* status = #requested
* insert Scenario6

Instance: fb3a4ac7-3f98-45cf-acd6-95b18e688d6b
InstanceOf: TwiinAuthorizationCancellationRequestTask
Usage: #example
Title: "Scenario 6, step 2: Authorization Cancellation Request accepted"
Description: "The Placer accepts the request to withdraw the Request."
* status = #accepted
* lastModified = "2026-11-03T13:00:00+01:00"
* insert Scenario6

// ---------------------------------------------------------------------------------------------
// Scenario 7: information request.

RuleSet: Scenario7Base
* status = #accepted
* authoredOn = "2026-10-09T09:00:00+02:00"
* insert ScenarioTask(0b7c5d0e-6f3a-4c2b-9e1d-8a4f2c6b3d75, a3c1e5f2-7b94-4d2a-8e61-0f5c9b3d2a71)
* insert FulfillA
* insert LocationA
* insert AvailableEntries

RuleSet: Scenario7Request
* input[informationRequest].type = TAWorkflowCS#information-request
* input[informationRequest].valueString = "Date and result of the last wound assessment."

Instance: d5f9a2c1-3e68-4b7d-a4f0-2c9e8b1d6f43
InstanceOf: Observation
Usage: #example
Title: "Scenario 7: wound assessment"
Description: "The resource at the Placer with which the Placer answers the information request. The content is fictitious."
* status = #final
* code.text = "Wound assessment"
* subject = Reference(Patient/3f6a2b8c-1d4e-4f7a-9b2c-5e8d1a7c4f90)
* effectiveDateTime = "2026-10-08T15:00:00+02:00"
* performer.type = "Organization"
* performer.identifier.system = $ura
* performer.identifier.value = "12345678"
* valueString = "Wound on the lower leg, 3 cm, clean; no signs of infection."

Instance: 683af045-b470-4595-b80d-cd40c92da2f7
InstanceOf: TwiinCoordinationTask
Usage: #example
Title: "Scenario 7, step 1: Fulfiller requests information"
Description: "The Fulfiller sets businessStatus awaiting-information with statusReason.text, and adds an entry with type information-request to input."
* businessStatus = TAWorkflowCS#awaiting-information
* statusReason.text = "The date of the last wound assessment is missing."
* lastModified = "2026-10-10T09:00:00+02:00"
* insert Scenario7Base
* insert Scenario7Request

Instance: 71af91f0-f5ec-42cf-9b48-75b74d0036a0
InstanceOf: TwiinCoordinationTask
Usage: #example
Title: "Scenario 7, step 2: Placer answers"
Description: "The Placer answers with a further entry in input, with type available-resource, that refers to the wound assessment."
* businessStatus = TAWorkflowCS#awaiting-information
* statusReason.text = "The date of the last wound assessment is missing."
* lastModified = "2026-10-10T11:00:00+02:00"
* insert Scenario7Base
* insert Scenario7Request
* input[availableResource][1].type = TAWorkflowCS#available-resource
* input[availableResource][1].valueReference = Reference(Observation/d5f9a2c1-3e68-4b7d-a4f0-2c9e8b1d6f43)

Instance: b8d24f6e-1c37-4a59-9f02-6e1a7c4b8d35
InstanceOf: TwiinCoordinationTask
Usage: #example
Title: "Scenario 7, step 3: Fulfiller has the information"
Description: "The Fulfiller removes businessStatus, statusReason and its information-request entry."
* lastModified = "2026-10-10T11:30:00+02:00"
* insert Scenario7Base
* input[availableResource][1].type = TAWorkflowCS#available-resource
* input[availableResource][1].valueReference = Reference(Observation/d5f9a2c1-3e68-4b7d-a4f0-2c9e8b1d6f43)

// ---------------------------------------------------------------------------------------------
// Subscription for an organization.

Instance: e0a7c3b9-5d14-4f82-b6e9-8a2d4c7f1b06
InstanceOf: TwiinWorkflowSubscription
Usage: #example
Title: "Subscription for an organization"
Description: "Subscription for all HealthcareServices of Fulfiller A, also those registered later: filter owner-assigner with the URA of the organization; channel.endpoint begins with the address of an Endpoint in Organization.endpoint. The topic URL is an example."
* status = #active
* reason = "Coordination Tasks for all HealthcareServices of the organization with URA 87654321"
* criteria = "https://example.org/fhir/SubscriptionTopic/transfer-of-care"
* criteria.extension[filterCriteria].url = $filter
* criteria.extension[filterCriteria].valueString = "owner-assigner=http://fhir.nl/fhir/NamingSystem/ura|87654321"
* channel.type = #rest-hook
* channel.endpoint = "https://fulfiller-a.example.org/fhir/notifications/organization"
* channel.extension[heartbeatPeriod].url = $heartbeat
* channel.extension[heartbeatPeriod].valueUnsignedInt = 3600
* channel.payload = #application/fhir+json
* channel.payload.extension[content].url = $content
* channel.payload.extension[content].valueCode = #id-only
