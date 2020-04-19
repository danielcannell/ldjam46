extends Panel


# outbound signals
signal button_pressed(name)

var BuildButton = preload("res://UI/BuildButton.gd")
var btn_font = preload("res://UI/DejaVuMono.tres")
onready var m_ui_buttons = get_node("VerticalLayout/BuildButtons")
onready var wave_label = $VerticalLayout/WaveStatus/WaveLabel
onready var spawns_prg = $VerticalLayout/WaveStatus/SpawnsProgress
onready var kills_prg = $VerticalLayout/WaveStatus/KillsProgress


func _ready():
    clear_buttons()


func wave_start(wave_num: int, wave_max: int, num_spawns: int) -> void:
    wave_label.text = "Wave " + str(wave_num + 1) + " / " + str(wave_max)
    spawns_prg.value = 0
    spawns_prg.max_value = num_spawns
    kills_prg.value = 0
    kills_prg.max_value = num_spawns


func spawns_change(spawns: int) -> void:
    spawns_prg.value = spawns


func kills_change(kills: int) -> void:
    kills_prg.value = kills


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
