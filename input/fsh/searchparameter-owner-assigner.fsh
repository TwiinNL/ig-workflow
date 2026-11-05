Instance: owner-assigner
InstanceOf: SearchParameter
Usage: #definition
Title: "Task owner-assigner"
Description: "The URA of the organization that assigned the identifier of the HealthcareService in Task.owner, which is the organization that provides that HealthcareService. Used to filter one Subscription for all HealthcareServices of an organization, and to search for the Tasks of that organization."
* url = "https://fhir.twiin.nl/ig/workflow/SearchParameter/owner-assigner"
* name = "OwnerAssigner"
* status = #draft
* experimental = false
* description = "The URA of the organization that assigned the identifier of the HealthcareService in Task.owner, which is the organization that provides that HealthcareService. Used to filter one Subscription for all HealthcareServices of an organization, and to search for the Tasks of that organization."
* code = #owner-assigner
* base = #Task
* type = #token
* expression = "Task.owner.identifier.assigner.identifier"
