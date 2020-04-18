extends Panel


# outbound signals
signal button_pressed

var BuildButton = preload("res://UI/BuildButton.gd")
var btn_font = preload("res://UI/DejaVuMono.tres")
onready var m_ui_buttons = get_node("VerticalLayout/BuildButtons")


func _ready():
    clear_buttons()
    add_buttons(["A", "B", "C"], ["D", "E"])


func add_buttons(unlocked: Array, locked: Array):
    clear_buttons()
    for name in unlocked:
        add_button(name, true)
    for name in locked:
        add_button(name, false)


func clear_buttons():
    for N in m_ui_buttons.get_children():
        m_ui_buttons.remove_child(N)


func add_button(name: String, unlocked: bool):
    var new_button = BuildButton.new()
    new_button.rect_min_size = Vector2(0, 60)
    new_button.text = name
    new_button.add_font_override("Font", btn_font)
    new_button.connect("button_pressed_with_label", self, "_on_button_pressed_with_label")
    new_button.disabled = !unlocked
    m_ui_buttons.add_child(new_button)

func _on_button_pressed_with_label(name: String):
    emit_signal("button_pressed", name)
