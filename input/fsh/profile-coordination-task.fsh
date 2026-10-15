Profile: TwiinCoordinationTask
Parent: $cow-coordination-task
Id: twiin-coordination-task
Title: "Twiin Coordination Task"
Description: "Coordination Task under TA Workflow (TA sections Summary of the profiles → Coordination Task; Coordination Task; Status of the Coordination Task; Patient context and readability; Type of work on the Task; Sharing additional content; Search parameters; Codes of this TA)."
* ^status = #draft
* ^experimental = false
* obeys twiin-ct-1 and twiin-ct-2 and twiin-ct-3 and twiin-ct-5 and twiin-ct-6 and twiin-ct-7 and twiin-task-1
* intent = #order
* code from TAWorkflowTaskCodeVS (required)
* statusReason from TAWorkflowStatusReasonVS (extensible)
* businessStatus from TAWorkflowBusinessStatusVS (extensible)
* focus only Reference(TwiinWorkflowServiceRequest)
* authoredOn 1..1
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
* input contains supplementalResource 0..* and supplementalQuery 0..*
* input[supplementalResource].type = TAWorkflowCS#supplemental-resource
* input[supplementalResource].value[x] only Reference
* input[supplementalQuery].type = TAWorkflowCS#supplemental-query
* input[supplementalQuery].value[x] only string

Invariant: twiin-ct-1
Description: "The statuses draft, ready and on-hold are not used (TA section Status of the Coordination Task)."
Expression: "(status = 'draft' or status = 'ready' or status = 'on-hold').not()"
Severity: #error

Invariant: twiin-ct-2
Description: "statusReason not-selected is used only when the status is cancelled (TA section Reason for cancelling a non-selected candidate)."
Expression: "statusReason.coding.where(system = 'https://fhir.twiin.nl/ig/workflow/CodeSystem/ta-workflow' and code = 'not-selected').exists() implies status = 'cancelled'"
Severity: #error

Invariant: twiin-ct-3
Description: "When businessStatus is selected, code is fulfill and for is populated (TA sections Multiple Fulfillers Pattern; Patient context and readability)."
Expression: "businessStatus.coding.where(system = 'https://fhir.twiin.nl/ig/workflow/CodeSystem/ta-workflow' and code = 'selected').exists() implies (code.coding.where(system = 'http://hl7.org/fhir/CodeSystem/task-code' and code = 'fulfill').exists() and for.exists())"
Severity: #error

Invariant: twiin-ct-5
Description: "statusReason SHOULD be populated when the status is rejected or cancelled (TA section Summary of the profiles → Coordination Task)."
Expression: "(status = 'rejected' or status = 'cancelled') implies statusReason.exists()"
Severity: #warning

Invariant: twiin-ct-6
Description: "Task.for.identifier is not populated (TA section Patient context and readability)."
Expression: "for.identifier.empty()"
Severity: #warning

Invariant: twiin-ct-7
Description: "Work is started or completed only with Task.code fulfill (TA sections Recognizing the pattern that applies; Status of the Coordination Task)."
Expression: "(status = 'in-progress' or status = 'completed') implies code.coding.where(system = 'http://hl7.org/fhir/CodeSystem/task-code' and code = 'fulfill').exists()"
Severity: #error
