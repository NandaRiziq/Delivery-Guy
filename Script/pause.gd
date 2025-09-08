extends Control

@onready var resume_button: Button = $ResumeButton
@onready var main_menu_button: Button = $MainMenuButton


func _ready():
    process_mode = Node.PROCESS_MODE_WHEN_PAUSED
    if resume_button != null:
        resume_button.pressed.connect(on_resume_pressed)
    if main_menu_button != null:
        main_menu_button.pressed.connect(on_main_menu_pressed)


func on_resume_pressed():
    get_tree().paused = false
    queue_free()


func on_main_menu_pressed():
    get_tree().paused = false
    get_tree().change_scene_to_file("res://Scene/main_menu.tscn")


