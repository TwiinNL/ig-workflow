CodeSystem: TAWorkflowCS
Id: ta-workflow
Title: "TA Workflow Codes"
Description: "Codes defined by TA Workflow for Task.code, Task.businessStatus, Task.statusReason and Task.input.type."
* ^status = #draft
* ^experimental = false
* ^content = #complete
* ^caseSensitive = true
* #request-fulfillment "Request fulfillment" "The Multiple Fulfillers Pattern applies and no candidate has been selected yet; the owner is invited to accept and, optionally, to bid, and may not yet start the work."
* #selected "Selected" "The Placer has selected the owner of this Task as the Fulfiller."
* #not-selected "Not selected" "The Placer has selected another candidate; the Coordination Task of this candidate is cancelled."
* #type-of-work "Type of work" "The entry carries the type of work."
* #supplemental-resource "Supplemental resource" "The entry refers, in valueReference, to one resource at the Placer that the Fulfiller may read beyond the standard dataset."
* #supplemental-query "Supplemental query" "The entry carries, in valueString, a search relative to the FHIR base of the Placer that the Fulfiller may perform beyond the standard dataset."

ValueSet: TAWorkflowTaskCodeVS
Id: ta-workflow-task-code
Title: "TA Workflow Task Code"
Description: "Codes for Task.code of the Coordination Task under TA Workflow."
* ^status = #draft
* ^experimental = false
* http://hl7.org/fhir/CodeSystem/task-code#fulfill
* TAWorkflowCS#request-fulfillment
