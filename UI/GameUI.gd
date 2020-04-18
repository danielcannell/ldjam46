extends Node2D


# outbound signals
signal build_requested

func _build_requested_repeater(build_id: String):
    emit_signal("build_requested", build_id)


# inbound slots

func on_status_change(status_id: String, status_val: float):
    var rpanel = get_node("CanvasLayer/MainControls/VerticalLayout/HorizontalLayout/RightPanel")
    rpanel.status_change(status_id, status_val)


func set_buildable_items(towers):
    var unlocked = []
    var locked = []
    for t in Globals.TOWERS:
        if Globals.TOWERS[t]['unlocked']:
            unlocked.append(t)
        else:
            locked.append(t)

    var lp = get_node("CanvasLayer/MainControls/VerticalLayout/HorizontalLayout/LeftPanel")
    lp.add_buttons(unlocked, locked)


func set_status_bars(bar_names):
    var rpanel = get_node("CanvasLayer/MainControls/VerticalLayout/HorizontalLayout/RightPanel")
    rpanel.set_progress_bars(bar_names)


# gory implementation

func _ready():
    var lp = get_node("CanvasLayer/MainControls/VerticalLayout/HorizontalLayout/LeftPanel")
    lp.connect("button_pressed", self, "_build_requested_repeater")
