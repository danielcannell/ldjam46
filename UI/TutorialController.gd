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
    Globals.TutorialEvents.BEGIN: "begin_message",
    Globals.TutorialEvents.WALK: "walk_message",
    Globals.TutorialEvents.FOOD_SPAWNED: "food_spawned_message",
    Globals.TutorialEvents.FOOD_PICKED_UP: "food_picked_up_message",
    Globals.TutorialEvents.MONSTER_FED: "monster_fed_message",
    Globals.TutorialEvents.MONSTER_V_HUNGRY: "monster_v_hungry_message",
}

const demo_message1 = "This is an tutorial [b]message[/b]."
const begin_message = "Welcome to the village. Your job is to defend your best mate, the local monster.\n\nClick anywhere on the map to walk to that location."
const walk_message  = "Nice one. you're going to be good at this, I can tell."
const food_spawned_message  = "Your dear friend the monster does get hungry. Looks like some curry & rice has turned up, walk around until you find it and the click it to pick it up."
const food_picked_up_message  = "Superbly done. Now if you walk over to the monster you can feed them. Just walk over there and wait a few seconds...."
const monster_fed_message = "Well done, I think he enjoyed that. You might have noticed that the hunger bar (top right) went down when you fed your friend. Make sure it doesn't fill up or you lose!"
const mosnter_v_hungry_message = "Uh oh, your monster is very very hungry! If his hunger is above 75% he'll start to get afraid..."


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

    var percent_complete := 100.0 * len(occurred) / len(Globals.TutorialEvents)
    emit_signal("tutorial_progressed", percent_complete)
