extends Sprite2D

@onready var house = get_parent()
var tween: Tween


func _ready():
	# Initially hide the marker
	visible = false
	
	# Connect to global package changes
	Global.package_changed.connect(_on_package_changed)
	
	# Check initial state
	check_visibility()


func _on_package_changed():
	check_visibility()


func check_visibility():
	var should_show = false
	
	# Check if there's a current package and if house type matches package ID
	if Global.current_package != null:
		should_show = (house.house_type == Global.current_package.package_id)
	
	# Show marker and start animation
	if should_show and not visible:
		visible = true
		start_animation()

	# Hide marker and stop animation
	elif not should_show and visible:
		visible = false
		stop_animation()


func start_animation():
	if tween != null:
		tween.kill()
	
	tween = create_tween().set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position:y", position.y + 3, 0.5)
	tween.tween_property(self, "position:y", position.y - 3, 0.5)


func stop_animation():
	if tween != null:
		tween.kill()
		tween = null
