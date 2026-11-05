This page is informative. Many requirements of TA Workflow concern behaviour, access control or the relation between several resources, and cannot be checked by validating one resource against the artifacts in this guide. This page points to the TA sections that contain them; it does not restate them. The TA lists most of them in Rules that a profile cannot express.

| Topic | TA section |
|---|---|
| Hosting of the Coordination Task at the Placer | Design Choices; Coordination Task |
| Coordination Task only for a HealthcareService and topic with a Subscription, at the base URL at which the Task is hosted, with status active or error | Actors; Subscription |
| Task.owner and Task.location refer to a HealthcareService and a Location as profiled by GF Addressing (NL-GF-HealthcareService, NL-GF-Location), by the identifier from their AssignedId slice. | Summary of the profiles → Coordination Task, Cancellation Request Task; Search parameters |
| Owner identifier resolves to exactly one HealthcareService | Coordination Task; Subscription; Search parameters |
| Recording of the accountable organization and access control | Coordination Task; Write access |
| Elements the Fulfiller may change (status, businessStatus, statusReason, executionPeriod, lastModified and output, and adding and removing entries of Task.input with type information-request), and the reserved values: the code selected in Task.businessStatus and the code not-selected in Task.statusReason are reserved for the Placer, the type information-request in Task.input for the Fulfiller | Write access |
| Version-aware updates, If-Match and 412 | Concurrent writes |
| Permitted status changes and who makes them: the Placer sets cancelled only before in-progress; after in-progress the Fulfiller sets cancelled after accepting a Cancellation Request Task | Status of the Coordination Task; Cancellation Request Task |
| executionPeriod.end set when the status moves from in-progress to completed, failed or cancelled | Summary of the profiles → Coordination Task |
| Status requested at creation | Summary of the profiles |
| Selection: exactly one candidate, and only one whose Coordination Task has the status accepted, atomic update, cancelling the others | Multiple Fulfillers Pattern |
| No two open Coordination Tasks for the same Request owned by HealthcareServices of the same Fulfiller while either has Task.code request-fulfillment | Candidates of the same Fulfiller |
| ServiceRequest.performer unset until selection | Request; Multiple Fulfillers Pattern |
| ServiceRequest.code carries the code of the ActivityDefinition to which ServiceRequest.instantiatesCanonical refers, where that ActivityDefinition has a code | Request |
| Read access: a candidate may read the Request from the creation of its Coordination Task; read access to the Patient follows Task.code fulfill (not businessStatus selected), unless the use case identifies the patient to candidates before selection; read access is withdrawn when the Placer cancels the candidate's Coordination Task | Patient context and readability |
| Until selection, no data that directly identifies the patient in the Request, and no information that identifies the patient elsewhere, unless the use case identifies the patient to candidates before selection | Patient context and readability; Sharing additional content |
| Task.for is empty while Task.code is request-fulfillment, unless the use case identifies the patient to candidates before selection | Patient context and readability |
| Cancellation Request Task only when the Coordination Task is in-progress | Cancellation Request Task |
| Same owner and type of work on a Cancellation Request Task as on its Coordination Task | Summary of the profiles → Cancellation Request Task; Cancellation Request Task; Type of work on the Task |
| Coordination Task to cancelled (not failed) after an accepted Cancellation Request Task | After an accepted Cancellation Request |
| Who may create an Authorization Cancellation Request Task: a Fulfiller that has a Coordination Task with Task.code fulfill for the same Request, whose status is not cancelled or entered-in-error | Write access; Cancellation by the Fulfiller |
| Handling the end of a Coordination Task | Handling the End of a Coordination Task |
| Ids stable, opaque and unpredictable, and Task.identifier is opaque | Identifiers of Tasks and Subscriptions |
| Requirements on SubscriptionTopics of use cases, including the filters owner:identifier and owner-assigner (on Task.owner.identifier.assigner.identifier) | SubscriptionTopic; Use-case agreements under TA Notifications |
| The filter `owner:identifier` identifies exactly one HealthcareService; the filter `owner-assigner` carries the URA of the organization that provides the HealthcareServices | Subscription; Search parameters |
| channel.endpoint begins with the address of an Endpoint with payloadType Notification in HealthcareService.endpoint, or, for a Subscription on owner-assigner, in Organization.endpoint, compared per path segment | Subscription |
| Per organization, topic and base URL either one Subscription per HealthcareService or one Subscription for the organization (which also serves HealthcareServices registered later), not both; endpoint; heartbeat interval | Subscription |
| No authorization value in notifications | Authorization value |
| Resynchronization by search | Resynchronization |
| Routing by the Fulfiller | Routing by the Fulfiller |
| Standard dataset as a guideline, not a requirement; the Placer states per Request what it makes available in entries with type available-resource or available-query; the Placer's server supports the reads and searches behind those entries, not the searches of the dataset itself | Retrieving the resources of a dataset; Sharing additional content |
| ServiceRequest.priority: the Placer SHOULD populate it and the Fulfiller SHALL process it when present; Task.priority is not used | Summary of the profiles → ServiceRequest |
| Changes to healthcare services | Changes to healthcare services |
| Recognizing the pattern that applies; the Placer's server rejects an update that moves Task.status to in-progress while Task.code is request-fulfillment | Recognizing the pattern that applies |
