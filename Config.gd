extends Node

const MONSTER_MAX_FEAR := 100.0

const TOWER_BUILD_TIME_S: float = 5.0

const WAVE_DURATION_S: float = 30.0
const WAVE_GAP_S: float = 30.0
const WAVE_ENEMY_COUNTS : Array = [
    10, 20, 30, 50, 80, 130, 210, 340, 550, 890
]

const HUNGER_INC_DELAY: float = 5.0
const HUNGER_INC_AMOUNT: float = 0.05

const INITIAL_HUNGER: float = 0.25
const FEED_AMOUNT: float = 0.5
const FEED_TIME: float = 3.0
const HUNGER_FEAR_THRESHOLD: float = 0.75

const SAVE_LOAD_ENABLED: bool = true
