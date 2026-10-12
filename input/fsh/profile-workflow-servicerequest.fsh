Profile: TwiinWorkflowServiceRequest
Parent: ServiceRequest
Id: twiin-workflow-servicerequest
Title: "Twiin Workflow ServiceRequest"
Description: "The Request under TA Workflow (TA sections Preliminary description of the profiles → ServiceRequest; Request; Patient context and readability). subject refers to a Patient and is not masked; instantiatesCanonical refers to the ActivityDefinition or PlanDefinition of the requested service."
* ^status = #draft
* ^experimental = false
* subject only Reference(Patient)
* subject obeys twiin-sr-1
* instantiatesCanonical 1..*

Invariant: twiin-sr-1
Description: "subject is not masked with the extension data-absent-reason."
Expression: "descendants().where(url = 'http://hl7.org/fhir/StructureDefinition/data-absent-reason').empty()"
Severity: #error
