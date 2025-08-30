extends Node2D

@export var width = 250
@export var height = 250

@export var seed = -1

var random = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if seed == -1:
		seed = random.randi()
		print(seed)
	var noise = NoiseTexture2D.new()
	var fast_noise = FastNoiseLite.new()
	fast_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	fast_noise.frequency = 0.01
	fast_noise.seed = seed
	noise.width = width
	noise.height = height
	noise.noise = fast_noise
	$Noise.texture = noise
	var vp_size = get_viewport().get_visible_rect().size
	$Noise.position =  Vector2(vp_size[0]*0.5,vp_size[1]*0.5)
	
	await noise.changed

	for x in width:
		for y in height:
			var noise_value = fast_noise.get_noise_2d(float(x),float(y))
			#print(noise_value)
			var noise_value_processed = floor(((noise_value+1)/2)*5)
			#print(noise_value_processed)
			$TileMapLayer.set_cell(Vector2i(x,y),0,Vector2i(0,noise_value_processed))
			
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Restart"):
		get_tree().change_scene_to_file("res://scenes/main.tscn")
