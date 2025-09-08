extends Control

@onready var play_button: Button = $PlayButton
@onready var score_label: Label = $Score


func _ready():
    if play_button != null:
        play_button.pressed.connect(_on_play_pressed)
    if score_label != null:
        score_label.text = "High Score: " + str(Global.get_high_score())


func _on_play_pressed():
    get_tree().paused = false
    get_tree().change_scene_to_file("res://Scene/main.tscn")


