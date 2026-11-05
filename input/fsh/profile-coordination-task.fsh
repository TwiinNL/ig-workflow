Profile: TwiinCoordinationTask
Parent: $cow-coordination-task
Id: twiin-coordination-task
Title: "Twiin Coordination Task"
Description: "Coordination Task under TA Workflow (TA sections Summary of the profiles → Coordination Task; Coordination Task; Status of the Coordination Task; Patient context and readability; Type of work on the Task; Sharing additional content; Search parameters; Codes of this TA)."
* ^status = #draft
* ^experimental = false
* obeys twiin-ct-1 and twiin-ct-2 and twiin-ct-3 and twiin-ct-5 and twiin-ct-6 and twiin-ct-7 and twiin-ct-8 and twiin-ct-9 and twiin-task-1
* intent = #order
* code from TAWorkflowTaskCodeVS (required)
* statusReason from TAWorkflowStatusReasonVS (extensible)
* businessStatus from TAWorkflowBusinessStatusVS (extensible)
* businessStatus ^short = "Progress within the status; selected is reserved for the Placer"
* businessStatus ^definition = "The Placer sets selected at selection. The Fulfiller MAY set a value to report progress within a status (TA sections Business status; Write access)."
* businessStatus ^comment = "selected is reserved for the Placer (TA section Write access). A use case MAY define further codes."
* focus only Reference(TwiinWorkflowServiceRequest)
* authoredOn 1..1
* for 1..1
* for.reference 1..1
* for ^short = "The Patient of the Request, set at creation"
* for ^comment = "Set at creation, in every pattern, and refers by Reference.reference to the Patient that ServiceRequest.subject refers to. The selection does not set it. Read access to the Patient follows Task.code fulfill (TA section Patient context and readability)."
* requester 1..1
* requester.identifier 1..1
* requester.identifier.system 1..1
* requester.identifier.system = $ura
* insert OwnerHealthcareService
* location only Reference(Location)
* location ^comment = "The reference identifies a Location as profiled by GF Addressing (NL-GF-Location), by the identifier from its AssignedId slice. See https://minvws.github.io/generiekefuncties-docs"
* location.type 1..1
* location.type = "Location"
* location.identifier 1..1
* location.identifier.system 1..1
* location.identifier.value 1..1
* location.identifier obeys twiin-aid-1
* location.identifier.assigner 1..1
* location.identifier.assigner.identifier 1..1
* location.identifier.assigner.identifier.system 1..1
* location.identifier.assigner.identifier.value 1..1
* insert TypeOfWorkInput
* input ^comment = "The Placer sets all entries of input, except the entries with type information-request: the Fulfiller MAY add and remove those, and only the Fulfiller sets them (TA section Write access)."
* input contains availableResource 0..* and availableQuery 0..* and informationRequest 0..*
* input[availableResource].type = TAWorkflowCS#available-resource
* input[availableResource].value[x] only Reference
* input[availableResource] ^short = "A resource at the Placer that the Placer makes available to the Fulfiller"
* input[availableQuery].type = TAWorkflowCS#available-query
* input[availableQuery].value[x] only string
* input[availableQuery] ^short = "A search, relative to the FHIR base of the Placer, that the Placer makes available to the Fulfiller"
* input[informationRequest].type = TAWorkflowCS#information-request
* input[informationRequest] ^short = "A request from the Fulfiller for information it needs from the Placer; reserved for the Fulfiller"
* input[informationRequest] ^comment = "The type information-request is reserved for the Fulfiller, which MAY add and remove such entries (TA section Write access)."
* status ^comment = "The Fulfiller MAY change only status, businessStatus, statusReason, executionPeriod, lastModified and output, and MAY add and remove entries of input with type information-request (TA section Write access). The Placer sets cancelled only before in-progress; after in-progress the Fulfiller sets cancelled after accepting a Cancellation Request Task (TA sections Status of the Coordination Task; After an accepted Cancellation Request)."
* statusReason ^short = "Reason for the status; required for rejected, failed and awaiting-information"
* statusReason ^comment = "SHALL be present when status is rejected or failed (twiin-ct-8), and SHALL be present with statusReason.text when businessStatus is awaiting-information (twiin-ct-9). SHOULD be present when status is cancelled (twiin-ct-5). not-selected is reserved for the Placer."
* executionPeriod ^comment = "executionPeriod.end is set when status moves from in-progress to completed, failed or cancelled."

Invariant: twiin-ct-1
Description: "The statuses draft, ready and on-hold are not used (TA section Status of the Coordination Task)."
Expression: "(status = 'draft' or status = 'ready' or status = 'on-hold').not()"
Severity: #error

Invariant: twiin-ct-2
Description: "statusReason not-selected is used only when the status is cancelled (TA section Reason for cancelling a non-selected candidate)."
Expression: "statusReason.coding.where(system = 'https://fhir.twiin.nl/ig/workflow/CodeSystem/ta-workflow' and code = 'not-selected').exists() implies status = 'cancelled'"
Severity: #error

Invariant: twiin-ct-3
Description: "When businessStatus is selected, code is fulfill (TA section Multiple Fulfillers Pattern)."
Expression: "businessStatus.coding.where(system = 'https://fhir.twiin.nl/ig/workflow/CodeSystem/ta-workflow' and code = 'selected').exists() implies (code.coding.where(system = 'http://hl7.org/fhir/CodeSystem/task-code' and code = 'fulfill').exists())"
Severity: #error

Invariant: twiin-ct-5
Description: "statusReason SHOULD be populated when the status is cancelled (TA section Summary of the profiles → Coordination Task)."
Expression: "status = 'cancelled' implies statusReason.exists()"
Severity: #warning

Invariant: twiin-ct-6
Description: "Task.for.identifier is not populated (TA section Patient context and readability)."
Expression: "for.identifier.empty()"
Severity: #warning

Invariant: twiin-ct-7
Description: "Work is started or completed only with Task.code fulfill (TA sections Recognizing the pattern that applies; Status of the Coordination Task)."
Expression: "(status = 'in-progress' or status = 'completed') implies code.coding.where(system = 'http://hl7.org/fhir/CodeSystem/task-code' and code = 'fulfill').exists()"
Severity: #error

Invariant: twiin-ct-8
Description: "statusReason is populated when the status is rejected or failed (TA sections Handling the End of a Coordination Task; Status of the Coordination Task)."
Expression: "(status = 'rejected' or status = 'failed') implies statusReason.exists()"
Severity: #error

Invariant: twiin-ct-9
Description: "statusReason with statusReason.text is populated when businessStatus is awaiting-information (TA sections Business status; Summary of the profiles → Coordination Task)."
Expression: "businessStatus.coding.where(system = 'https://fhir.twiin.nl/ig/workflow/CodeSystem/ta-workflow' and code = 'awaiting-information').exists() implies statusReason.text.exists()"
Severity: #error
