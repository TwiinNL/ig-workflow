// Task.owner of the Coordination Task and the Cancellation Request Task: a HealthcareService, as
// profiled by GF Addressing, identified by the identifier from its AssignedId slice.
RuleSet: OwnerHealthcareService
* owner 1..1
* owner only Reference(HealthcareService)
* owner ^comment = "The reference identifies a HealthcareService as profiled by GF Addressing (NL-GF-HealthcareService), by the identifier from its AssignedId slice. See https://minvws.github.io/generiekefuncties-docs"
* owner.type 1..1
* owner.type = "HealthcareService"
* owner.identifier 1..1
* owner.identifier.system 1..1
* owner.identifier.value 1..1
* owner.identifier obeys twiin-aid-1
* owner.identifier.assigner 1..1
* owner.identifier.assigner.identifier 1..1
* owner.identifier.assigner.identifier.system 1..1
* owner.identifier.assigner.identifier.value 1..1

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
Description: "The assigner of the identifier is not identified by a KvK number (TA section Search parameters)."
Expression: "assigner.identifier.where(system = 'http://kvk.nl').empty()"
Severity: #error

Invariant: twiin-task-1
Description: "When statusReason is populated, statusReason.text SHOULD be populated (TA section Summary of the profiles)."
Expression: "statusReason.exists() implies statusReason.text.exists()"
Severity: #warning
