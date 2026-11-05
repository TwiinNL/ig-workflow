Profile: TwiinWorkflowSubscription
Parent: $twiin-subscription
Id: twiin-workflow-subscription
Title: "Twiin Workflow Subscription"
Description: "Subscription under TA Workflow, on top of the Twiin Subscription of TA Notifications (TA sections Summary of the profiles → Subscription; Subscription). The payload mode is id-only, the filter is `owner:identifier=[system]|[value]` (one HealthcareService) or `owner-assigner=[system]|[value]` (all HealthcareServices of one organization, by its URA), and a heartbeat period is required."
* ^status = #draft
* ^experimental = false
* criteria.extension[filterCriteria] 1..1
* criteria.extension[filterCriteria] obeys twiin-wsub-1
* criteria.extension[filterCriteria] ^short = "owner:identifier=[system]|[value] or owner-assigner=[system]|[value]"
* criteria.extension[filterCriteria] ^comment = "Either owner:identifier=[system]|[value] with the identifier of the HealthcareService, or owner-assigner=[system]|[value] with the URA of the organization that provides the HealthcareServices (search parameter owner-assigner). Per organization, topic and base URL, a Fulfiller has either one Subscription per HealthcareService or one Subscription for the organization, not both."
* channel.endpoint 1..1
* channel.endpoint ^comment = "Begins with the address of an Endpoint with payloadType Notification in HealthcareService.endpoint, or, for a Subscription on owner-assigner, in Organization.endpoint, compared per path segment."
* channel.extension[heartbeatPeriod] 1..1
* channel.payload.extension[content].valueCode = #id-only

Invariant: twiin-wsub-1
Description: "The filter is of the form owner:identifier=[system]|[value] or owner-assigner=[system]|[value] (TA section Subscription)."
Expression: "value.ofType(string).matches('^(owner:identifier|owner-assigner)=[^|\\\\s]+[|][^|\\\\s]+$')"
Severity: #error
