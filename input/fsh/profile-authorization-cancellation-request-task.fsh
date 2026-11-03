Profile: TwiinAuthorizationCancellationRequestTask
Parent: Task
Id: twiin-authorization-cancellation-request-task
Title: "Twiin Authorization Cancellation Request Task"
Description: "Authorization Cancellation Request Task under TA Workflow, used by a Fulfiller to ask the Placer to withdraw the Request itself (TA sections Summary of the profiles → Authorization Cancellation Request Task; Cancellation by the Fulfiller). COW IG defines no profile for this Task. requester and owner identify the Fulfiller and the Placer as organizations, by their URA."
* ^status = #draft
* ^experimental = false
* obeys twiin-acrt-1 and twiin-task-1
* code 1..1
* code = $task-code#abort
* intent = #proposal
* focus 1..1
* focus only Reference(TwiinWorkflowServiceRequest)
* requester 1..1
* requester.identifier 1..1
* requester.identifier.system 1..1
* requester.identifier.system = $ura
* owner 1..1
* owner.identifier 1..1
* owner.identifier.system 1..1
* owner.identifier.system = $ura
* reasonCode 1..1 MS
* reasonCode ^short = "The Fulfiller's reason for asking to withdraw the Request"
* reasonCode ^definition = "The reason of the Fulfiller for asking the Placer to withdraw the Request."
* statusReason ^short = "The Placer's reason for rejecting"
* statusReason ^definition = "The reason of the Placer for rejecting the request to withdraw the Request."

Invariant: twiin-acrt-1
Description: "The status is requested, accepted or rejected."
Expression: "status = 'requested' or status = 'accepted' or status = 'rejected'"
Severity: #error
