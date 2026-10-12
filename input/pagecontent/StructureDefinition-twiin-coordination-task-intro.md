### Type of work

The code for the type of work is defined by the use case, not by this IG. The slice `input:typeOfWork` therefore has the fixed `type` [type-of-work](CodeSystem-ta-workflow.html) and a `value[x]` of type CodeableConcept, but no ValueSet. A use case fixes the binding of the codes it allows on the slice `typeOfWork` in its own profile of this Coordination Task.
