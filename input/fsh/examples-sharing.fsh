// Scenario: sharing additional content through Task.input, before and after selection (see the page
// Example: sharing additional content). One candidate, Fulfiller A of examples.fsh. The input type of
// the entries before selection is fictitious: the care domain defines it.
// One instance per state; the Coordination Task of the states has one Task.identifier.value.

RuleSet: SharingTaskBase
* intent = #order
* focus = Reference(ServiceRequest/3e358483-ec50-469b-94d0-54b6bc5ea7d8)
* authoredOn = "2026-10-20T09:00:00+02:00"
* identifier.system = "https://placer.example.org/task"
* identifier.value = "853df82f-91b5-4d26-8663-c472b5899a38"
* insert PlacerRequester
* insert OwnerA
* insert TypeOfWork

RuleSet: SharingDressingInput
* input[1].type.text = "Dressing type"
* input[1].valueString = "Hydrocolloid dressing; the interval of the changes is to be confirmed."

Instance: 3e358483-ec50-469b-94d0-54b6bc5ea7d8
InstanceOf: TwiinWorkflowServiceRequest
Usage: #example
Title: "ServiceRequest: sharing additional content"
Description: "The Request of the scenario sharing additional content. performer is unset: the Multiple Fulfillers Pattern applies."
* status = #active
* intent = #order
* code = $sct#308292007
* subject = Reference(Patient/3f6a2b8c-1d4e-4f7a-9b2c-5e8d1a7c4f90)
* authoredOn = "2026-10-20T08:50:00+02:00"

Instance: 8d97c695-4ece-45fb-96e0-a216398978fa
InstanceOf: Observation
Usage: #example
Title: "Observation: updated wound assessment"
Description: "A resource at the Placer to which the Coordination Task refers after selection, in an entry with type available-resource (TA section Sharing additional content). The content is fictitious."
* status = #final
* code.text = "Wound assessment"
* subject = Reference(Patient/3f6a2b8c-1d4e-4f7a-9b2c-5e8d1a7c4f90)
* effectiveDateTime = "2026-10-22T10:00:00+02:00"
* performer.type = "Organization"
* performer.identifier.system = $ura
* performer.identifier.value = "12345678"
* valueString = "Wound on the lower leg is clean and dry; no signs of infection."

// Step 1: before selection, with content inline.
Instance: 7dc145b2-78c9-45db-ab56-267c664be4c3
InstanceOf: TwiinCoordinationTask
Usage: #example
Title: "Coordination Task: sharing step 1, content shared before selection"
Description: "Step 1. The Placer invites the candidate and adds an entry to input with its content inline, without a reference, since before selection a candidate may read the Request but not the Patient or other resources at the Placer. The entry does not identify the patient (TA sections Sharing additional content; Patient context and readability). The type Dressing type is fictitious: the use case defines the type and states why the content is not identifying."
* status = #requested
* code = TAWorkflowCS#request-fulfillment
* insert SharingTaskBase
* insert SharingDressingInput

// Step 2: the candidate awaits information.
Instance: c8ca1ec3-dd83-4900-9bfa-a05d6e93782c
InstanceOf: TwiinCoordinationTask
Usage: #example
Title: "Coordination Task: sharing step 2, candidate awaits information"
Description: "Step 2. The candidate accepted, sets businessStatus awaiting-information and states in statusReason.text what it needs (TA section Business status)."
* status = #accepted
* businessStatus = TAWorkflowCS#awaiting-information
* statusReason.text = "The interval of the dressing changes is missing; it is needed to plan the visits."
* code = TAWorkflowCS#request-fulfillment
* insert SharingTaskBase
* insert SharingDressingInput
* lastModified = "2026-10-20T10:00:00+02:00"

// Step 3: the Placer answers in Task.input.
Instance: b5e65e9b-434f-445c-924d-ff772c25ae4d
InstanceOf: TwiinCoordinationTask
Usage: #example
Title: "Coordination Task: sharing step 3, Placer answers in input"
Description: "Step 3. The Placer provides the information by adding an entry to input, again with its content inline (TA sections Business status; Sharing additional content). The Fulfiller then sets another value or removes businessStatus."
* status = #accepted
* businessStatus = TAWorkflowCS#awaiting-information
* statusReason.text = "The interval of the dressing changes is missing; it is needed to plan the visits."
* code = TAWorkflowCS#request-fulfillment
* insert SharingTaskBase
* insert SharingDressingInput
* input[2].type.text = "Dressing change interval"
* input[2].valueString = "Every 3 days."
* lastModified = "2026-10-20T11:00:00+02:00"

// Step 4: the candidate removes awaiting-information.
Instance: e1e3f55f-c56e-4501-b409-ed05bb70cc87
InstanceOf: TwiinCoordinationTask
Usage: #example
Title: "Coordination Task: sharing step 4, candidate has the information"
Description: "Step 4. The candidate removes businessStatus and statusReason (TA section Business status)."
* status = #accepted
* code = TAWorkflowCS#request-fulfillment
* insert SharingTaskBase
* insert SharingDressingInput
* input[2].type.text = "Dressing change interval"
* input[2].valueString = "Every 3 days."
* lastModified = "2026-10-20T11:30:00+02:00"

// Step 5: after selection.
Instance: 66507516-150c-415f-9e88-7c1f24eef69c
InstanceOf: TwiinCoordinationTask
Usage: #example
Title: "Coordination Task: sharing step 5, available resource after selection"
Description: "Step 5. The Placer selects the candidate: businessStatus selected, code fulfill and for set in the same update, together with an entry with type available-resource that refers to a resource at the Placer (TA sections Sharing additional content; Patient context and readability)."
* status = #accepted
* businessStatus = TAWorkflowCS#selected
* code = $task-code#fulfill
* for = Reference(Patient/3f6a2b8c-1d4e-4f7a-9b2c-5e8d1a7c4f90)
* insert SharingTaskBase
* insert SharingDressingInput
* input[2].type.text = "Dressing change interval"
* input[2].valueString = "Every 3 days."
* input[3].type = TAWorkflowCS#available-resource
* input[3].valueReference = Reference(Observation/8d97c695-4ece-45fb-96e0-a216398978fa)
* lastModified = "2026-10-22T11:00:00+02:00"
