extends Node2D

@onready var player = $Player
@onready var package_giver = $PackageGiver
@onready var timer_bar: ProgressBar = $UI/HUD/TimerBar
@onready var pause_button: TextureButton = $UI/HUD/PauseButton
@onready var ui_layer: CanvasLayer = $UI

var pause_scene: PackedScene = preload("res://Scene/pause.tscn")
var pause_instance: Control = null
var game_over_scene: PackedScene = preload("res://Scene/game_over.tscn")
var game_over_instance: Control = null

const TOTAL_TIME := 60.0
var time_left := TOTAL_TIME


func _ready():
    # spawn a package when the game starts
    package_giver.spawn_package()

    # setup timer bar and spawn a package when the game starts
    if timer_bar != null:
        timer_bar.max_value = TOTAL_TIME
        timer_bar.value = TOTAL_TIME

    if pause_button != null:
        pause_button.pressed.connect(on_pause_pressed)


func _process(delta):
    # manage timer
    if time_left <= 0.0:
        on_time_up()
        return
    time_left = time_left - delta
    if timer_bar != null:
        timer_bar.value = time_left


func on_time_up():
    # Pause the game and handle game over
    get_tree().paused = true
    if game_over_instance == null:
        game_over_instance = game_over_scene.instantiate()
        if ui_layer != null:
            ui_layer.add_child(game_over_instance)


func on_pause_pressed():
    if pause_instance == null:
        pause_instance = pause_scene.instantiate()
        if ui_layer != null:
            ui_layer.add_child(pause_instance)
    get_tree().paused = true