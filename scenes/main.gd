extends Node2D

var width:int = Global.width
var height:int = Global.height
var altitude:float = Global.altitude

var seed:int = Global.seed

@export var max_zoom:float = 1
@export var min_zoom:float = 0.1

var speed = 150
var zoom_speed = 0.025

@export var atlas_height:int = 5
@export var atlas_heightfloor:int = 4
@export var texture_size = 32

var random = RandomNumberGenerator.new()
var cooldown = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Camera2D.limit_left = 0
	$Camera2D.limit_right = width * texture_size
	$Camera2D.limit_top = 0
	$Camera2D.limit_bottom = height * texture_size
	if seed == -1:
		seed = random.randi()
		#print(seed)
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
			var noise_value_processed = min(atlas_heightfloor,max(0,int(min(atlas_heightfloor,max(0,floor(((noise_value+1)/2)*atlas_height)))+(atlas_heightfloor*altitude))))
			#print(noise_value_processed)
			$TileMapLayer.set_cell(Vector2i(x,y),0,Vector2i(0,noise_value_processed))
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var vp_size = get_viewport().get_visible_rect().size
	#print((width*texture_size)*$Camera2D.zoom[0], (height*texture_size)*$Camera2D.zoom[1])
	if vp_size[0] < (width*texture_size)*min_zoom or vp_size[0] < (height*texture_size)*min_zoom:
		min_zoom -= 0.025
		min_zoom = max(0.2, min_zoom)
		var zoom = $Camera2D.zoom
		$Camera2D.zoom = Vector2(max(min_zoom,min(max_zoom,zoom.x)),max(min_zoom,min(max_zoom,zoom.y)))
	if vp_size[0] > (width*texture_size)*$Camera2D.zoom[0] or vp_size[0] > (height*texture_size)*$Camera2D.zoom[1]:
		min_zoom += 0.025
		var zoom = $Camera2D.zoom
		$Camera2D.zoom = Vector2(max(min_zoom,min(max_zoom,zoom.x)),max(min_zoom,min(max_zoom,zoom.y)))
	if cooldown == false:
		cooldown = true
		var direction = Input.get_vector("CamLeft", "CamRight", "CamUp", "CamDown")
		var zoom_dir = Input.get_axis("CamZoomOut","CamZoomIn")
		
		$Camera2D.position += direction * speed
		var zoom_amount = zoom_dir * zoom_speed
		var zoom = $Camera2D.zoom + Vector2(zoom_amount,zoom_amount)
		$Camera2D.zoom = Vector2(max(min_zoom+0.025,min(max_zoom,zoom.x)),max(min_zoom+0.025,min(max_zoom,zoom.y)))
		#print($Camera2D.zoom, max_zoom, min_zoom+0.025)
	
	if Input.is_action_just_pressed("Restart"):
		get_tree().change_scene_to_file("res://scenes/settings_menu.tscn")
		


func _on_input_cooldown_timeout() -> void:
	cooldown = false
