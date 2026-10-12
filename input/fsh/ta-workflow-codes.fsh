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

ValueSet: TAWorkflowStatusReasonVS
Id: ta-workflow-status-reason
Title: "TA Workflow Status Reason"
Description: "Codes for Task.statusReason of the Coordination Task under TA Workflow. Extensible: a use case or a Fulfiller MAY use other reasons, for instance when it rejects a Task; not-selected is reserved for the Placer."
* ^status = #draft
* ^experimental = false
* TAWorkflowCS#not-selected

ValueSet: TAWorkflowBusinessStatusVS
Id: ta-workflow-business-status
Title: "TA Workflow Business Status"
Description: "Codes for Task.businessStatus of the Coordination Task under TA Workflow. Extensible: a use case MAY define further values; selected is set by the Placer only."
* ^status = #draft
* ^experimental = false
* TAWorkflowCS#selected
