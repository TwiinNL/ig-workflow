Profile: TwiinCoordinationTask
Parent: $cow-coordination-task
Id: twiin-coordination-task
Title: "Twiin Coordination Task"
Description: "Coordination Task under TA Workflow (TA sections Preliminary description of the profiles → Coordination Task; Coordination Task; Status of the Coordination Task; Patient context and readability; Type of work on the Task; Sharing additional content; Search parameters; Codes of this TA)."
* ^status = #draft
* ^experimental = false
* obeys twiin-ct-1 and twiin-ct-2 and twiin-ct-3 and twiin-ct-4 and twiin-ct-5 and twiin-task-1
* intent = #order
* code from TAWorkflowTaskCodeVS (required)
* focus only Reference(TwiinWorkflowServiceRequest)
* for.identifier obeys twiin-ct-6
* authoredOn 1..1
* requester 1..1
* requester.identifier 1..1
* requester.identifier.system 1..1
* requester.identifier.system = $ura
* insert OwnerHealthcareService
* location only Reference($nl-gf-location)
* location.identifier 1..1
* location.identifier only $nl-gf-custodianassignedidentifier
* location.identifier obeys twiin-aid-1
* insert TypeOfWorkInput
* input contains supplementalResource 0..* and supplementalQuery 0..*
* input[supplementalResource].type = TAWorkflowCS#supplemental-resource
* input[supplementalResource].value[x] only Reference
* input[supplementalQuery].type = TAWorkflowCS#supplemental-query
* input[supplementalQuery].value[x] only string

Invariant: twiin-ct-1
Description: "The statuses draft, ready and on-hold are not used."
Expression: "(status = 'draft' or status = 'ready' or status = 'on-hold').not()"
Severity: #error

Invariant: twiin-ct-2
Description: "statusReason not-selected is used only when the status is cancelled."
Expression: "statusReason.coding.where(system = 'https://fhir.twiin.nl/ig/workflow/CodeSystem/ta-workflow' and code = 'not-selected').exists() implies status = 'cancelled'"
Severity: #error

Invariant: twiin-ct-3
Description: "When businessStatus is selected, code is fulfill and for is populated."
Expression: "businessStatus.coding.where(system = 'https://fhir.twiin.nl/ig/workflow/CodeSystem/ta-workflow' and code = 'selected').exists() implies (code.coding.where(system = 'http://hl7.org/fhir/CodeSystem/task-code' and code = 'fulfill').exists() and for.exists())"
Severity: #error

Invariant: twiin-ct-4
Description: "When code is request-fulfillment, no candidate has been selected and for is empty."
Expression: "code.coding.where(system = 'https://fhir.twiin.nl/ig/workflow/CodeSystem/ta-workflow' and code = 'request-fulfillment').exists() implies for.empty()"
Severity: #error

Invariant: twiin-ct-5
Description: "statusReason SHOULD be populated when the status is rejected or cancelled."
Expression: "(status = 'rejected' or status = 'cancelled') implies statusReason.exists()"
Severity: #warning

Invariant: twiin-ct-6
Description: "for.identifier SHOULD NOT carry the BSN."
Expression: "system != 'http://fhir.nl/fhir/NamingSystem/bsn'"
Severity: #warning
