extends Node2D

@onready var main = $".."
@onready var player = $"../Player"
@onready var sfx_pickup: AudioStreamPlayer = $AudioStreamPlayer

var has_package : bool = false
var current_package : Node2D = null


func _ready():
	$Area2D.body_entered.connect(_on_area_body_entered)


# spawn a package
func spawn_package() -> void:
	# randomize package type
	var rand_package = randi_range(1, 4)
	var new_package = preload("res://Scene/package.tscn").instantiate()

	main.add_child(new_package)
	new_package.global_position = self.global_position
	new_package.call_deferred("set_package_type", rand_package)
	has_package = true
	current_package = new_package


func _on_area_body_entered(body: Node) -> void:
	if current_package == null:
		return
	
	# package follow player
	if body.name == "Player":
		var marker: Marker2D = body.get_node("PackageOffset")
		current_package.start_follow(marker)
		Global.set_current_package(current_package)
		player.has_package = true
		has_package = false
		current_package = null
		sfx_pickup.play()