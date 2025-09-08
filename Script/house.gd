extends Node2D

@onready var player = $"../Player"
@onready var score_label = $"../UI/HUD/ScoreLabel"
@onready var hud_marker = $"../UI/HUD/Marker"
@onready var package_giver = $"../PackageGiver"
@onready var area: Area2D = $Area2D
@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var sfx_player_1: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var sfx_player_2: AudioStreamPlayer2D = $AudioStreamPlayer2D2

@export_range(1, 4) var house_type: int = 1

var texture_regions: Dictionary = {
	1: Rect2i(112, 32, 48, 32), # normal
	2: Rect2i(64, 64, 48, 32), # blue
	3: Rect2i(112, 64, 48, 32), # green
	4: Rect2i(64, 32, 48, 32), # purple
}
var player_inside: bool = false
var is_on_screen: bool = false
var is_target_house: bool = false


func _ready() -> void:
	# connect signals
	player.action_pressed.connect(on_action_pressed)
	Global.package_changed.connect(on_package_changed)

	# change texture based on house type
	var sprite: Sprite2D = get_node_or_null("Sprite2D")
	if sprite == null:
		return
	sprite.region_enabled = true
	sprite.region_rect = texture_regions.get(house_type, Rect2i(112, 32, 48, 32))


func _on_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("Player entered area")
		player_inside = true
		

func _on_area_2d_body_exited(body:Node2D) -> void:
	if body.name == "Player":
		player_inside = false



func on_action_pressed() -> void:
	# get package node
	var package = Global.current_package

	# deliver package if player is inside and package is found
	if package != null:
		print("Package: ", str(package.package_id))
		if player_inside and player.has_package:
			if package.package_id == house_type:
				package.queue_free()
				Global.score += 100
				Global.set_current_package(null)
				player.has_package = false
				score_label.update_score(Global.score)
				print("Package delivered")
				
				# emit thumbs up particle effect
				particles.restart()
				# play delivery SFX (both audio nodes)
				if sfx_player_1 != null and sfx_player_1.stream != null:
					sfx_player_1.play()
				if sfx_player_2 != null and sfx_player_2.stream != null:
					sfx_player_2.play()

				# request new package
				package_giver.spawn_package()
			
			else:
				print("Package not delivered")


func _on_screen_entered():
	is_on_screen = true
	update_hud_marker_visibility()


func _on_screen_exited():
	is_on_screen = false
	update_hud_marker_visibility()


func on_package_changed() -> void:
	# house is target only if there's a current package and IDs match
	is_target_house = Global.current_package != null and Global.current_package.package_id == house_type
	update_hud_marker_visibility()


func update_hud_marker_visibility() -> void:
	if hud_marker == null:
		return

	# Hide when there is no active package
	if Global.current_package == null:
		hud_marker.visible = false
		return

	# Only the target house controls the HUD marker visibility
	if not is_target_house:
		return

	# Show only when this is the target house and it's off-screen
	hud_marker.visible = not is_on_screen
