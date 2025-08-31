extends Control

func _ready():
	pass
	
func _process(delta):
	if Input.is_action_just_pressed("Restart"):
		get_tree().change_scene_to_file("res://scenes/main.tscn")
		
	var screen_size = get_viewport()
	if screen_size:
		screen_size = screen_size.get_visible_rect().size
		$BG.size = screen_size


func _on_input_width_input_text_submitted(new_text: String) -> void:
	var convert = int(new_text)
	print(convert)
	if convert < 1:
		$Main/InputWidth/InputWidthInput.text = "Please input a valid width"
	else :
		$Main/InputWidth/InputWidthInput.text = str(convert)
		Global.width = convert
	


func _on_input_height_input_text_submitted(new_text: String) -> void:
	var convert = int(new_text)
	print(convert)
	if convert < 1:
		$Main/InputHeight/InputHeightInput.text = "Please input a valid height"
	else :
		$Main/InputHeight/InputHeightInput.text = str(convert)
		Global.height = convert


func _on_input_seed_input_text_submitted(new_text: String) -> void:
	var convert = int(new_text)
	print(convert)
	if convert == 0 and not new_text == "0":
		$Main/InputSeed/InputSeedInput.text = "Please input a valid seed"
	else :
		if convert < 0:
			convert = -1
		$Main/InputSeed/InputSeedInput.text = str(convert)
		Global.seed = convert


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_input_altitude_input_text_submitted(new_text: String) -> void:
	var convert = float(new_text)
	print(convert)
	if convert < -1 or convert > 1 or (convert == 0 and not new_text == "0"):
		$Main/InputAltitude/InputAltitudeInput.text = "Please input a valid offset"
	else :
		$Main/InputAltitude/InputAltitudeInput.text = str(convert)
		Global.altitude = convert
