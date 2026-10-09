Alias: $sct = http://snomed.info/sct
Alias: $filter = http://hl7.org/fhir/uv/subscriptions-backport/StructureDefinition/backport-filter-criteria
Alias: $content = http://hl7.org/fhir/uv/subscriptions-backport/StructureDefinition/backport-payload-content
Alias: $heartbeat = http://hl7.org/fhir/uv/subscriptions-backport/StructureDefinition/backport-heartbeat-period

// Identifier from the AssignedId slice of NL-GF-HealthcareService or NL-GF-Location, with a URA
// assigner as GF Addressing prescribes (system urn:oid:2.16.528.1.1007.3.3).
RuleSet: AssignedId(path, system, value, ura)
* {path}.use = #official
* {path}.system = "{system}"
* {path}.value = "{value}"
* {path}.assigner.identifier.type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#custodian
* {path}.assigner.identifier.system = "urn:oid:2.16.528.1.1007.3.3"
* {path}.assigner.identifier.value = "{ura}"

RuleSet: PlacerRequester
* requester.identifier.system = $ura
* requester.identifier.value = "12345678"

RuleSet: OwnerA
* owner.type = "HealthcareService"
* insert AssignedId(owner.identifier, https://fulfiller-a.example.org/healthcareservice, wondzorg-thuis, 87654321)

RuleSet: OwnerB
* owner.type = "HealthcareService"
* insert AssignedId(owner.identifier, https://fulfiller-b.example.org/healthcareservice, wijkverpleging-noord, 11223344)

RuleSet: LocationA
* insert AssignedId(location.identifier, https://fulfiller-a.example.org/location, vestiging-centrum, 87654321)

RuleSet: TypeOfWork
* input[typeOfWork].type = TAWorkflowCS#type-of-work
* input[typeOfWork].valueCodeableConcept = $sct#308292007

RuleSet: CoordinationTaskBase
* intent = #order
* focus = Reference(ServiceRequest/0b7c5d0e-6f3a-4c2b-9e1d-8a4f2c6b3d75)
* authoredOn = "2026-10-09T09:00:00+02:00"
* insert PlacerRequester
* insert TypeOfWork

Instance: 3f6a2b8c-1d4e-4f7a-9b2c-5e8d1a7c4f90
InstanceOf: Patient
Usage: #example
Title: "Patient"
Description: "The Patient to which the Request refers. Carries the BSN in Patient.identifier (TA section Patient context and readability)."
* identifier.system = "http://fhir.nl/fhir/NamingSystem/bsn"
* identifier.value = "999999151"
* name.family = "Jansen"
* name.given = "Anna"

Instance: 0b7c5d0e-6f3a-4c2b-9e1d-8a4f2c6b3d75
InstanceOf: TwiinWorkflowServiceRequest
Usage: #example
Title: "ServiceRequest: transfer of care"
Description: "The Request, with subject a Patient and instantiatesCanonical referring to the definition of the requested service (TA sections Request; Patient context and readability). performer is unset: the Multiple Fulfillers Pattern applies."
* status = #active
* intent = #order
* instantiatesCanonical = "https://example.org/fhir/ActivityDefinition/transfer-of-care"
* code = $sct#308292007
* subject = Reference(Patient/3f6a2b8c-1d4e-4f7a-9b2c-5e8d1a7c4f90)
* authoredOn = "2026-10-09T08:55:00+02:00"

Instance: 6d2e9f41-8b3c-4a7d-b5e2-1c9f7a3d8e64
InstanceOf: TwiinCoordinationTask
Usage: #example
Title: "Coordination Task: candidate invited"
Description: "A bidding task in the Multiple Fulfillers Pattern before selection: code request-fulfillment, for empty (TA sections Multiple Fulfillers Pattern; Patient context and readability)."
* identifier.system = "https://placer.example.org/task"
* identifier.value = "6d2e9f41-8b3c-4a7d-b5e2-1c9f7a3d8e64"
* status = #requested
* code = TAWorkflowCS#request-fulfillment
* insert CoordinationTaskBase
* insert OwnerA
* insert LocationA

Instance: a41c7e2b-5f9d-4e3a-8c6b-2d7f1e9a5b38
InstanceOf: TwiinCoordinationTask
Usage: #example
Title: "Coordination Task: candidate selected"
Description: "The Coordination Task of the selected candidate: businessStatus selected, code fulfill and for set in the same update (TA sections Multiple Fulfillers Pattern; Patient context and readability). The candidate had accepted and recorded a bid in output."
* identifier.system = "https://placer.example.org/task"
* identifier.value = "a41c7e2b-5f9d-4e3a-8c6b-2d7f1e9a5b38"
* status = #accepted
* businessStatus = TAWorkflowCS#selected
* code = $task-code#fulfill
* for = Reference(Patient/3f6a2b8c-1d4e-4f7a-9b2c-5e8d1a7c4f90)
* insert CoordinationTaskBase
* insert OwnerA
* insert LocationA
* lastModified = "2026-10-09T11:30:00+02:00"
* output[0].type.text = "Bid"
* output[0].valueString = "Available from 2026-10-12"

Instance: c8e3d5a7-2b4f-4d9e-a1c6-7f3b8e2d4a91
InstanceOf: TwiinCoordinationTask
Usage: #example
Title: "Coordination Task: candidate not selected"
Description: "The Coordination Task of a candidate that was not selected: status cancelled with statusReason not-selected and the text not selected (TA section Reason for cancelling a non-selected candidate)."
* identifier.system = "https://placer.example.org/task"
* identifier.value = "c8e3d5a7-2b4f-4d9e-a1c6-7f3b8e2d4a91"
* status = #cancelled
* statusReason = TAWorkflowCS#not-selected
* statusReason.text = "not selected"
* code = TAWorkflowCS#request-fulfillment
* insert CoordinationTaskBase
* insert OwnerB

Instance: e2f7a9c1-4d6b-4b8e-9a3f-6c1d5e8b2a47
InstanceOf: TwiinCoordinationTask
Usage: #example
Title: "Coordination Task: single Fulfiller, in progress"
Description: "Single Fulfiller Pattern: code fulfill and for set from creation; the Fulfiller has started the work. Task.input also carries a supplemental-resource and a supplemental-query entry (TA sections Single Fulfiller Pattern; Sharing additional content)."
* identifier.system = "https://placer.example.org/task"
* identifier.value = "e2f7a9c1-4d6b-4b8e-9a3f-6c1d5e8b2a47"
* status = #in-progress
* code = $task-code#fulfill
* for = Reference(Patient/3f6a2b8c-1d4e-4f7a-9b2c-5e8d1a7c4f90)
* insert CoordinationTaskBase
* insert OwnerA
* insert LocationA
* executionPeriod.start = "2026-10-12T08:00:00+02:00"
* input[supplementalResource].type = TAWorkflowCS#supplemental-resource
* input[supplementalResource].valueReference = Reference(Patient/3f6a2b8c-1d4e-4f7a-9b2c-5e8d1a7c4f90)
* input[supplementalQuery].type = TAWorkflowCS#supplemental-query
* input[supplementalQuery].valueString = "Observation?patient=3f6a2b8c-1d4e-4f7a-9b2c-5e8d1a7c4f90&code=http://loinc.org|8302-2"

Instance: 5b9d3e7f-1a2c-4f6e-8d4b-9e2a7c1f3b56
InstanceOf: TwiinCancellationRequestTask
Usage: #example
Title: "Cancellation Request Task"
Description: "The Placer asks the Fulfiller to stop work that has started. focus refers to the Coordination Task, owner and the type of work are the same as on that Task (TA sections Cancellation Request Task; Cancellation Request (After in-progress))."
* identifier.system = "https://placer.example.org/task"
* identifier.value = "5b9d3e7f-1a2c-4f6e-8d4b-9e2a7c1f3b56"
* status = #requested
* intent = #order
* code = $task-code#abort
* focus = Reference(Task/e2f7a9c1-4d6b-4b8e-9a3f-6c1d5e8b2a47)
* authoredOn = "2026-10-13T10:00:00+02:00"
* insert PlacerRequester
* insert OwnerA
* insert TypeOfWork

Instance: 9c4a1f8e-7d3b-4e2a-b6f9-3a8e5d2c7b14
InstanceOf: TwiinAuthorizationCancellationRequestTask
Usage: #example
Title: "Authorization Cancellation Request Task"
Description: "A Fulfiller asks the Placer to withdraw the Request (TA section Cancellation by the Fulfiller). requester identifies the Fulfiller and owner the Placer, each by its URA."
* status = #requested
* statusReason.text = "Contraindication found for the requested service"
* intent = #proposal
* code = $task-code#abort
* focus = Reference(ServiceRequest/0b7c5d0e-6f3a-4c2b-9e1d-8a4f2c6b3d75)
* authoredOn = "2026-10-12T14:00:00+02:00"
* requester.identifier.system = $ura
* requester.identifier.value = "87654321"
* owner.identifier.system = $ura
* owner.identifier.value = "12345678"

Instance: 1e8b4c6d-3f7a-4b2e-9d5c-8a1f6e3b7c29
InstanceOf: TwiinWorkflowSubscription
Usage: #example
Title: "Subscription for a HealthcareService"
Description: "Subscription for one HealthcareService and one topic at the base URL of the Placer: filter owner:identifier, id-only, heartbeat period (TA section Subscription). The topic URL is an example; topics are defined per use case."
* status = #active
* reason = "Coordination Tasks for HealthcareService wondzorg-thuis"
* criteria = "https://example.org/fhir/SubscriptionTopic/transfer-of-care"
* criteria.extension[filterCriteria].url = $filter
* criteria.extension[filterCriteria].valueString = "owner:identifier=https://fulfiller-a.example.org/healthcareservice|wondzorg-thuis"
* channel.type = #rest-hook
* channel.endpoint = "https://fulfiller-a.example.org/fhir/notifications"
* channel.extension[heartbeatPeriod].url = $heartbeat
* channel.extension[heartbeatPeriod].valueUnsignedInt = 3600
* channel.payload = #application/fhir+json
* channel.payload.extension[content].url = $content
* channel.payload.extension[content].valueCode = #id-only
