extends Node2D


# args: (which: Globals.BARS, level: float)
signal status_changed


var enemies: Array

onready var tower_builder: Node2D = $TowerBuilder
onready var tm: TileMap = $Map/TileMap
onready var monster: Node2D = $YSort/Monster
onready var player: Player = $YSort/Player


func on_build_requested(kind):
    tower_builder.on_build_requested(kind)


func _on_monster_fear_changed(fear: float) -> void:
    emit_signal("status_changed", "Fear", fear / Globals.MONSTER_MAX_FEAR)


func get_enemies_near(pos: Vector2, radius: float) -> Array:
    # TODO
    return []


func _init() -> void:
    Globals.playfield = self


func _ready():
    assert(monster.connect("fear_changed", self, "_on_monster_fear_changed") == 0)

    assert(tower_builder.connect("build", player, "build") == 0)
    assert(tower_builder.connect("build_complete", self, "build_complete") == 0)
    assert(player.connect("building", tower_builder, "building") == 0)
    assert(player.connect("state_changed", tower_builder, "_on_player_state_changed") == 0)


func build_complete():
    player.move(player.position)
