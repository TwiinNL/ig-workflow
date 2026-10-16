This page is informative. Many requirements of TA Workflow concern behaviour, access control or the relation between several resources, and cannot be checked by validating one resource against the artifacts in this guide. This page points to the TA sections that contain them; it does not restate them. The TA lists most of them in Rules that a profile cannot express.

| Topic | TA section |
|---|---|
| Hosting of the Coordination Task at the Placer | Design Choices; Coordination Task |
| Coordination Task only for a HealthcareService and topic with a Subscription, at the base URL at which the Task is hosted, with status active or error | Actors; Subscription |
| Task.owner and Task.location refer to a HealthcareService and a Location as profiled by GF Addressing (NL-GF-HealthcareService, NL-GF-Location), by the identifier from their AssignedId slice. | Summary of the profiles → Coordination Task, Cancellation Request Task; Search parameters |
| Owner identifier resolves to exactly one HealthcareService | Coordination Task; Subscription; Search parameters |
| Recording of the accountable organization and access control | Coordination Task; Write access |
| Elements the Fulfiller may change, and the reserved value not-selected | Write access |
| Version-aware updates, If-Match and 412 | Concurrent writes |
| Permitted status changes and who makes them | Status of the Coordination Task; Cancellation Request Task |
| Status requested at creation | Summary of the profiles |
| Selection: exactly one candidate, and only one whose Coordination Task has the status accepted, atomic update, cancelling the others | Multiple Fulfillers Pattern |
| No two open Coordination Tasks for the same Request owned by HealthcareServices of the same Fulfiller while either has Task.code request-fulfillment | Candidates of the same Fulfiller |
| ServiceRequest.performer unset until selection | Request; Multiple Fulfillers Pattern |
| ServiceRequest.code carries the code of the ActivityDefinition to which ServiceRequest.instantiatesCanonical refers, where that ActivityDefinition has a code | Request |
| Read access to the Request and the Patient before and after selection, unless the use case identifies the patient to candidates before selection; read access is withdrawn when the Placer cancels the candidate's Coordination Task | Patient context and readability |
| No information that identifies the patient before selection, unless the use case identifies the patient to candidates before selection | Patient context and readability; Sharing additional content |
| Task.for is empty while Task.code is request-fulfillment, unless the use case identifies the patient to candidates before selection | Patient context and readability |
| Cancellation Request Task only when the Coordination Task is in-progress | Cancellation Request Task |
| Same owner and type of work on a Cancellation Request Task as on its Coordination Task | Summary of the profiles → Cancellation Request Task; Cancellation Request Task; Type of work on the Task |
| Coordination Task to failed after an accepted Cancellation Request Task | After an accepted Cancellation Request |
| Who may create an Authorization Cancellation Request Task: a Fulfiller that has a Coordination Task with Task.code fulfill for the same Request, whose status is not cancelled or entered-in-error | Write access; Cancellation by the Fulfiller |
| Handling the end of a Coordination Task | Handling the End of a Coordination Task |
| Ids stable, opaque and unpredictable, and Task.identifier is opaque | Identifiers of Tasks and Subscriptions |
| Requirements on SubscriptionTopics of use cases | SubscriptionTopic; Use-case agreements under TA Notifications |
| The filter identifies exactly one HealthcareService | Subscription |
| channel.endpoint begins with the address of an Endpoint in HealthcareService.endpoint with payloadType Notification, compared per path segment | Subscription |
| One Subscription per HealthcareService, topic and base URL; endpoint; heartbeat interval | Subscription |
| No authorization value in notifications | Authorization value |
| Resynchronization by search | Resynchronization |
| Routing by the Fulfiller | Routing by the Fulfiller |
| Standard dataset and its searches | Retrieving the resources of a dataset |
| Changes to healthcare services | Changes to healthcare services |
| Recognizing the pattern that applies; the Placer's server rejects an update that moves Task.status to in-progress while Task.code is request-fulfillment | Recognizing the pattern that applies |
