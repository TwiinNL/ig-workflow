CodeSystem: TAWorkflowCS
Id: ta-workflow
Title: "TA Workflow Codes"
Description: "Codes used by TA Workflow."
* ^status = #draft
* ^content = #complete
* #request-fulfillment "Request fulfillment" "The Multiple Fulfillers Pattern applies and no candidate has been selected yet; the owner is invited to accept and, optionally, to bid, and may not yet start the work."
* #selected "Selected" "The Placer has selected the owner of this Task as the Fulfiller."
* #type-of-work "Type of work" "The entry carries the type of work."

ValueSet: TAWorkflowTaskCodeVS
Id: ta-workflow-task-code
Title: "TA Workflow Task Code"
Description: "Codes for Task.code of the Coordination Task under TA Workflow."
* ^status = #draft
* http://hl7.org/fhir/CodeSystem/task-code#fulfill
* TAWorkflowCS#request-fulfillment
