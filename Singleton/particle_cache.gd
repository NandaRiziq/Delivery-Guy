extends CanvasLayer

var material = preload("res://particle.tres")


func _ready():
    var particles_instance = GPUParticles2D.new()
    particles_instance.set_process_material(material)
    particles_instance.one_shot = true
    particles_instance.set_modulate(Color(1, 1, 1, 0))
    particles_instance.set_emitting(true)
    self.add_child(particles_instance)



