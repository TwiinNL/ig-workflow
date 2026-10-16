Profile: TwiinWorkflowServiceRequest
Parent: ServiceRequest
Id: twiin-workflow-servicerequest
Title: "Twiin Workflow ServiceRequest"
Description: "The Request under TA Workflow (TA sections Summary of the profiles → ServiceRequest; Request; Patient context and readability). subject refers to a Patient and is not masked; code states the requested service; instantiatesCanonical MAY refer to the ActivityDefinition or PlanDefinition of the requested service."
* ^status = #draft
* ^experimental = false
* subject only Reference(Patient)
* subject obeys twiin-sr-1
* instantiatesCanonical 0..*
* code 1..1
* code ^short = "The requested service (TA Routing)"
* code ^definition = "code is required so that the Request can be routed also without a definition; where instantiatesCanonical refers to an ActivityDefinition that has a code, code carries that code."

Invariant: twiin-sr-1
Description: "subject is not masked with the extension data-absent-reason."
Expression: "descendants().where(url = 'http://hl7.org/fhir/StructureDefinition/data-absent-reason').empty()"
Severity: #error
