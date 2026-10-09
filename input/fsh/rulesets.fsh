// Task.owner of the Coordination Task and the Cancellation Request Task: a HealthcareService of
// GF Addressing, identified by the identifier from the AssignedId slice of NL-GF-HealthcareService.
RuleSet: OwnerHealthcareService
* owner 1..1
* owner only Reference($nl-gf-healthcareservice)
* owner.type 1..1
* owner.type = "HealthcareService"
* owner.identifier 1..1
* owner.identifier only $nl-gf-custodianassignedidentifier
* owner.identifier obeys twiin-aid-1

// Exactly one entry of Task.input with type type-of-work, carrying the type of work as a code.
RuleSet: TypeOfWorkInput
* input ^slicing.discriminator.type = #pattern
* input ^slicing.discriminator.path = "type"
* input ^slicing.rules = #open
* input ^slicing.description = "Slice on input.type"
* input contains typeOfWork 1..1
* input[typeOfWork].type = TAWorkflowCS#type-of-work
* input[typeOfWork].value[x] only CodeableConcept

Invariant: twiin-aid-1
Description: "The assigner of the identifier is not identified by a KvK number: a HealthcareService or Location whose AssignedId has a KvK assigner cannot be referred to under TA Workflow."
Expression: "assigner.identifier.where(system = 'http://kvk.nl').empty()"
Severity: #error

Invariant: twiin-task-1
Description: "When statusReason is populated, statusReason.text SHOULD be populated."
Expression: "statusReason.exists() implies statusReason.text.exists()"
Severity: #warning
