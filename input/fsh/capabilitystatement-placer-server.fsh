Alias: $exp = http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation

RuleSet: Expect(level)
* extension[0].url = $exp
* extension[0].valueCode = #{level}

RuleSet: TaskSearch(index, name, type, definition)
* rest[0].resource[0].searchParam[{index}].name = "{name}"
* rest[0].resource[0].searchParam[{index}].definition = "{definition}"
* rest[0].resource[0].searchParam[{index}].type = #{type}
* rest[0].resource[0].searchParam[{index}].extension[0].url = $exp
* rest[0].resource[0].searchParam[{index}].extension[0].valueCode = #SHALL

Instance: twiin-workflow-placer-server
InstanceOf: CapabilityStatement
Usage: #definition
Title: "Twiin Workflow Placer Server"
Description: "Requirements for the FHIR server of the Placer under TA Workflow (TA section Placer server capabilities). Imports the Twiin Subscription Server of TA Notifications for Subscription."
* url = "https://fhir.twiin.nl/ig/workflow/CapabilityStatement/twiin-workflow-placer-server"
* name = "TwiinWorkflowPlacerServer"
* title = "Twiin Workflow Placer Server"
* status = #draft
* experimental = false
* date = "2026-10-09"
* kind = #requirements
* imports = "https://fhir.twiin.nl/ig/notifications/CapabilityStatement/twiin-subscription-server|0.1.0-draft"
* fhirVersion = #4.0.1
* format[0] = #json
* patchFormat[0] = #application/json-patch+json
* patchFormat[0].extension[0].url = $exp
* patchFormat[0].extension[0].valueCode = #SHALL
* rest[0].mode = #server
* rest[0].documentation = "Subscription: see the imported Twiin Subscription Server (TA Notifications). Task, ServiceRequest and Patient: TA section Placer server capabilities."
// Task
* rest[0].resource[0].type = #Task
* rest[0].resource[0] insert Expect(SHALL)
* rest[0].resource[0].supportedProfile[0] = Canonical(TwiinCoordinationTask)
* rest[0].resource[0].supportedProfile[1] = Canonical(TwiinCancellationRequestTask)
* rest[0].resource[0].supportedProfile[2] = Canonical(TwiinAuthorizationCancellationRequestTask)
* rest[0].resource[0].versioning = #versioned-update
* rest[0].resource[0].interaction[0].code = #read
* rest[0].resource[0].interaction[0] insert Expect(SHALL)
* rest[0].resource[0].interaction[1].code = #search-type
* rest[0].resource[0].interaction[1] insert Expect(SHALL)
* rest[0].resource[0].interaction[2].code = #update
* rest[0].resource[0].interaction[2] insert Expect(SHALL)
* rest[0].resource[0].interaction[2].documentation = "Version-aware: the Fulfiller sends the version in If-Match; an update on a version that is no longer current is rejected with 412 Precondition Failed (TA section Concurrent writes)."
* rest[0].resource[0].interaction[3].code = #patch
* rest[0].resource[0].interaction[3] insert Expect(SHALL)
* rest[0].resource[0].interaction[3].documentation = "JSON Patch (application/json-patch+json), version-aware as update (TA section Concurrent writes)."
* rest[0].resource[0].interaction[4].code = #create
* rest[0].resource[0].interaction[4] insert Expect(SHALL)
* rest[0].resource[0].interaction[4].documentation = "Only for the Authorization Cancellation Request Task, created by the Fulfiller (TA section Write access)."
* insert TaskSearch(0, owner, reference, http://hl7.org/fhir/SearchParameter/Task-owner)
* rest[0].resource[0].searchParam[0].documentation = "Supported with the modifier :identifier, value `<system>|<value>` (TA section Search parameters)."
* insert TaskSearch(1, requester, reference, http://hl7.org/fhir/SearchParameter/Task-requester)
* rest[0].resource[0].searchParam[1].documentation = "Supported with the modifier :identifier, value `<system>|<value>` (TA section Search parameters)."
* insert TaskSearch(2, focus, reference, http://hl7.org/fhir/SearchParameter/Task-focus)
* rest[0].resource[0].searchParam[2].documentation = "TA section Resynchronization."
* insert TaskSearch(3, code, token, http://hl7.org/fhir/SearchParameter/Task-code)
* rest[0].resource[0].searchParam[3].documentation = "TA sections Resynchronization; Cancellation by the Fulfiller."
* insert TaskSearch(4, intent, token, http://hl7.org/fhir/SearchParameter/Task-intent)
* rest[0].resource[0].searchParam[4].documentation = "TA section Cancellation by the Fulfiller."
* insert TaskSearch(5, status, token, http://hl7.org/fhir/SearchParameter/Task-status)
* rest[0].resource[0].searchParam[5].documentation = "TA section Placer server capabilities."
* insert TaskSearch(6, business-status, token, http://hl7.org/fhir/SearchParameter/Task-business-status)
* rest[0].resource[0].searchParam[6].documentation = "TA section Placer server capabilities."
* insert TaskSearch(7, _lastUpdated, date, http://hl7.org/fhir/SearchParameter/Resource-lastUpdated)
* rest[0].resource[0].searchParam[7].documentation = "TA section Resynchronization."
// ServiceRequest
* rest[0].resource[1].type = #ServiceRequest
* rest[0].resource[1] insert Expect(SHALL)
* rest[0].resource[1].supportedProfile[0] = Canonical(TwiinWorkflowServiceRequest)
* rest[0].resource[1].interaction[0].code = #read
* rest[0].resource[1].interaction[0] insert Expect(SHALL)
// Patient
* rest[0].resource[2].type = #Patient
* rest[0].resource[2] insert Expect(SHALL)
* rest[0].resource[2].interaction[0].code = #read
* rest[0].resource[2].interaction[0] insert Expect(SHALL)
