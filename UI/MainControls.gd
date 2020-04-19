extends Control


onready var rpanel = $VerticalLayout/HorizontalLayout/RightPanel
onready var lpanel = $VerticalLayout/HorizontalLayout/LeftPanel
onready var tutpanel = $VerticalLayout/HorizontalLayout/VBoxContainer/TutorialReviewPanel


func _ready():
    rpanel.connect("tutorial_show_toggle", self, "_on_tutorial_show_toggle")

func _on_tutorial_show_toggle(visible):
    tutpanel.visible = visible

func on_tutorial_message(title: String, message: String) -> void:
    rpanel.on_tutorial_message()
    if title == null:
        title = "Hint..."
    tutpanel.set_message(title, message)
