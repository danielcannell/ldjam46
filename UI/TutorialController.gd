extends Node2D

# member variables
var occurred = []

# outbound signals
signal tutorial_message_requested(message)
signal tutorial_progressed(percent_complete)

# ----------------------------------------------------------------------------
# Tutorial Messages - when a tutorial event just wants to show some text.
# ----------------------------------------------------------------------------
var messages = {
    Globals.TutorialEvents.DEMO_EVENT: "demo_message1",
}

const demo_message1 = "This is an tutorial [b]message[/b]."


# ----------------------------------------------------------------------------
# Tutorial Actions - when the tutorial event wants a custom handler function
# ----------------------------------------------------------------------------
var action_handlers = {
    Globals.TutorialEvents.DEMO_EVENT: "handle_demo_action_event",
}


func handle_demo_action_event():
    print("action occured.")


# ----------------------------------------------------------------------------
# Tutorial Code
# ----------------------------------------------------------------------------
func handle_tutorial_event(ev):
    if ev in occurred:
        return

    occurred.append(ev)

    if !Globals.tutorial_enabled:
        return

    for ms in messages:
        if ms == ev:
            emit_signal("tutorial_message_requested", get(messages[ms]))

    for h in action_handlers:
        if h == ev:
            call_deferred(action_handlers[h])

    var percent_complete = 100 * len(occurred) / len(Globals.TutorialEvents)
    emit_signal("tutorial_progressed", percent_complete)
