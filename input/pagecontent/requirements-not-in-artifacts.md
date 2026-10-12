This page is informative. Many requirements of TA Workflow concern behaviour, access control or the relation between several resources, and cannot be checked by validating one resource against the artifacts in this guide. This page points to the TA sections that contain them; it does not restate them. The TA lists most of them in Rules that a profile cannot express.

| Topic | TA section |
|---|---|
| Hosting of the Coordination Task at the Placer | Design Choices; Coordination Task |
| Coordination Task only for a HealthcareService and topic with a Subscription | Actors; Subscription |
| Owner identifier resolves to exactly one HealthcareService | Coordination Task; Subscription; Search parameters |
| Recording of the accountable organization and access control | Coordination Task; Write access |
| Elements the Fulfiller may change, and the reserved value not-selected | Write access |
| Version-aware updates, If-Match and 412 | Concurrent writes |
| Permitted status changes and who makes them | Status of the Coordination Task; Cancellation Request Task |
| Status requested at creation | Preliminary description of the profiles |
| Selection: exactly one candidate, atomic update, cancelling the others | Multiple Fulfillers Pattern |
| ServiceRequest.performer unset until selection | Request; Multiple Fulfillers Pattern |
| ServiceRequest.code carries the code of the ActivityDefinition | Request |
| Read access to the Request and the Patient before and after selection | Patient context and readability |
| No information that identifies the patient before selection | Patient context and readability; Sharing additional content |
| BSN in Patient.identifier | Patient context and readability |
| Cancellation Request Task only when the Coordination Task is in-progress | Cancellation Request Task |
| Same owner and type of work on a Cancellation Request Task as on its Coordination Task | Cancellation Request Task; Type of work on the Task |
| Coordination Task to failed after an accepted Cancellation Request Task | After an accepted Cancellation Request |
| Who may create an Authorization Cancellation Request Task | Write access; Cancellation by the Fulfiller |
| Handling the end of a Coordination Task | Handling the End of a Coordination Task |
| Ids stable, opaque and unpredictable | Identifiers of Tasks and Subscriptions |
| Requirements on SubscriptionTopics of use cases | SubscriptionTopic; Use-case agreements under TA Notifications |
| One Subscription per HealthcareService, topic and base URL; endpoint; heartbeat interval | Subscription |
| No authorization value in notifications | Authorization value |
| Resynchronization by search | Resynchronization |
| Routing by the Fulfiller | Routing by the Fulfiller |
| Standard dataset and its searches | Retrieving the resources of a dataset |
| Changes to healthcare services | Changes to healthcare services |
| Recognizing the pattern that applies; no work while code is request-fulfillment | Recognizing the pattern that applies |
