extends Control


onready var rpanel = $VerticalLayout/HorizontalLayout/RightPanel
onready var lpanel = $VerticalLayout/HorizontalLayout/LeftPanel
onready var tutpanel = $VerticalLayout/HorizontalLayout/VBoxContainer/TutorialReviewPanel


signal build_requested(name)


func _ready():
    rpanel.connect("tutorial_show_toggle", self, "_on_tutorial_show_toggle")

func _on_tutorial_show_toggle(visible):
    tutpanel.visible = visible

func _on_tutorial_message_requested(message: String) -> void:
    rpanel.on_tutorial_message()
    tutpanel.set_message(message)

func _on_tutorial_progressed(percent_complete: float) -> void:
    rpanel.on_tutorial_progressed(percent_complete)

func _on_leftpanel_button_pressed(name):
    emit_signal("build_requested", name)
