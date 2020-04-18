extends Label

func _on_Player_state_changed(state):
    var state_name = get_parent().States.keys()[state]
    var action = get_parent().get_current_action()
    var action_name = get_parent().Actions.keys()[action["type"]]
    text = action_name + " / " + state_name
