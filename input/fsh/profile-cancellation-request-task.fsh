Profile: TwiinCancellationRequestTask
Parent: $cow-cancellation-request-task
Id: twiin-cancellation-request-task
Title: "Twiin Cancellation Request Task"
Description: "Cancellation Request Task under TA Workflow, used by the Placer to ask the Fulfiller to stop work that has started (TA sections Preliminary description of the profiles → Cancellation Request Task; Cancellation Request Task; Type of work on the Task)."
* ^status = #draft
* ^experimental = false
* obeys twiin-crt-1 and twiin-task-1
* intent = #order
* focus only Reference(TwiinCoordinationTask)
* insert OwnerHealthcareService
* insert TypeOfWorkInput

Invariant: twiin-crt-1
Description: "The status is requested, accepted, rejected, cancelled or entered-in-error."
Expression: "status = 'requested' or status = 'accepted' or status = 'rejected' or status = 'cancelled' or status = 'entered-in-error'"
Severity: #error
