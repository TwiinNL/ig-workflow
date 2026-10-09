Profile: TwiinWorkflowSubscription
Parent: $twiin-subscription
Id: twiin-workflow-subscription
Title: "Twiin Workflow Subscription"
Description: "Subscription under TA Workflow, on top of the Twiin Subscription of TA Notifications (TA section Subscription). The payload mode is id-only, the filter is `owner:identifier=<system>|<value>`, and a heartbeat period is required."
* ^status = #draft
* ^experimental = false
* criteria.extension[filterCriteria] 1..1
* criteria.extension[filterCriteria] obeys twiin-wsub-1
* channel.extension[heartbeatPeriod] 1..1
* channel.payload.extension[content].valueCode = #id-only

Invariant: twiin-wsub-1
Description: "The filter has the form owner:identifier=[system]|[value]."
Expression: "value.ofType(string).matches('^owner:identifier=[^| ]+[|][^| ]+$')"
Severity: #error
