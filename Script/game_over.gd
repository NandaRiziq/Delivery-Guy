extends Control

@onready var score_label: Label = $Score
@onready var best_score_label: Label = $BestScore
@onready var retry_button: Button = $RetryButton
@onready var main_menu_button: Button = $MainMenuButton


func _ready():
    process_mode = Node.PROCESS_MODE_WHEN_PAUSED
    var is_new_best: bool = Global.update_high_score(Global.score)
    if score_label != null:
        score_label.text = "Score: " + str(Global.score)
    if best_score_label != null:
        best_score_label.visible = is_new_best
    if retry_button != null:
        retry_button.pressed.connect(_on_retry)
    if main_menu_button != null:
        main_menu_button.pressed.connect(_on_main_menu)


func _on_retry():
    get_tree().paused = false
    get_tree().change_scene_to_file("res://Scene/main.tscn")


func _on_main_menu():
    get_tree().paused = false
    get_tree().change_scene_to_file("res://Scene/main_menu.tscn")


