extends Node2D


# outbound signals
signal build_requested

func _build_requested_repeater(build_id: String):
    emit_signal("build_requested", build_id)


# inbound slots

func _on_status_change(status_id: String, status_val: float):
    var rpanel = get_node("CanvasLayer/MainControls/VerticalLayout/HorizontalLayout/RightPanel")
    rpanel.status_change(status_id, status_val)


func _on_buildable_items_set(unlocked: Array, locked: Array):
    var lp = get_node("CanvasLayer/MainControls/VerticalLayout/HorizontalLayout/LeftPanel")
    lp.add_buttons(unlocked, locked)


# gory implementation

func _ready():
    var lp = get_node("CanvasLayer/MainControls/VerticalLayout/HorizontalLayout/LeftPanel")
    lp.connect("button_pressed", self, "_build_requested_repeater")
