extends CanvasGroup

var soundnode
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Main/Play").grab_focus()
	if(Global.loadthedata()):
		get_node("Main/SFX").value = Global.sfxvolume
		get_node("Main/Music").value = Global.musicvolume
		get_node("Main/Debug").button_pressed = Global.debug 
		get_node("Main/Resolution").value = Global.resolution*180
		get_node("Main/hitsound").button_pressed = (Global.whichhitsound == 1)
		get_tree().root.content_scale_size = Vector2i(  Global.resolution*180 * 1.75,  Global.resolution*180)
		get_node("Main/Middleclickfunc").button_pressed = Global.middleclickmove
		get_node("Main/controler?").button_pressed = Global.mousecontrol
	else:
		get_tree().root.content_scale_size = Vector2i( get_node("Main/Resolution").value * 1.75, get_node("Main/Resolution").value)
		Global.resolution = get_node("Main/Resolution").value/180
	get_parent().zoom = Vector2(1,1)* (3.445/2 * get_node("Main/Resolution").value/180)
	get_node("Main").position.y = 0
	get_node("Main").position.x = 0
	
	
	for i in Global.file:
		print("Main/Challenges2/" + i)
		print(has_node("Main/Challenges2/" + i))
		if has_node("Main/Challenges2/" + i):
			
			get_node("Main/Challenges2/" + i).visible = Global.file[i] == 1
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Global.sfxvolume = get_node("Main/SFX").value
	get_node("Main/SFXLabel").text = "SFX :" + str(get_node("Main/SFX").value)
	Global.musicvolume = get_node("Main/Music").value
	get_node("Main/MusicLabel").text = "Music :" + str(get_node("Main/Music").value)
	Global.middleclickmove = get_node("Main/Middleclickfunc").button_pressed
	if Global.middleclickmove:
		get_node("Main/Middleclickfunclabeltext").text = "Middle Click - Move"
	else:
		get_node("Main/Middleclickfunclabeltext").text = "Middle Click - Aim"
	if get_node("Main/hitsound").button_pressed:
		Global.whichhitsound = 1
	else:
		Global.whichhitsound = 0
	
	pass


func _on_button_pressed():
	Global.debug = get_node("Main/Debug").button_pressed
	
	
	get_node("Main/Back4").grab_focus()
	
	Global.savethedata()
	#Global.movescene("res://scenes/level.tscn")
	get_node("Main").position = Vector2(-457.22,122.665)
	if !Global.mousecontrol:
		get_node("Main/Label3").text = "Left click to shoot.\nRight  click to rapid shoot."
		get_node("Main/Label3").scale = Vector2.ONE
	else:
		get_node("Main/Label3").scale = Vector2.ONE * 0.7
		get_node("Main/Label3").text = "Left stick to move. \nRight stick to aim.\nBumpers to shoot. \nTriggers to rapid shoot.\nHold left stick to speed up. \nHold right stick to slow down."
	pass # Replace with function body.


func _on_options_pressed():
	get_node("Main").position.y = 145.255
	get_node("Main/Back").grab_focus()
	pass # Replace with function body.


func _on_back_button_down():
	get_node("Main").position.y = 0
	get_node("Main").position.x = 0
	get_node("Main/Play").grab_focus()
	pass # Replace with function body.


func _on_check_button_pressed():
	Global.debug = get_node("Main/Debug").button_pressed
	pass # Replace with function body.


func _on_sfx_changed():
	if has_node(soundnode):
		soundnode.queue_free()
	pass # Replace with function body.


func _on_music_changed():
	pass # Replace with function body.





func _on_resolution_value_changed(value):
	get_tree().root.content_scale_size = Vector2i( get_node("Main/Resolution").value * 1.75, get_node("Main/Resolution").value)
	print(get_tree().root.content_scale_size )
	get_node("Main/Resolutionlabel").text = "Resolution: " + str(get_tree().root.content_scale_size.x) + "x" +str(get_tree().root.content_scale_size.y)
	get_parent().zoom = Vector2(1,1)* (3.445/2 * get_node("Main/Resolution").value/180)
	Global.resolution = get_node("Main/Resolution").value/180
	pass # Replace with function body.



	


func _on_hitsound_pressed():
	
		

	Global.sfxvolume = get_node("Main/SFX").value
	
	
	get_node("1").volume_db = linear_to_db( db_to_linear(1) * (Global.sfxvolume/100))
	get_node("0").volume_db = get_node("1").volume_db
	if !get_node("Main/hitsound").button_pressed:
		get_node("0").play()
	else:
		get_node("1").play()

	
	pass # Replace with function body.


func _on_challenges_pressed():
	get_node("Main").position.x = 222.015
	get_node("Main/Back2").grab_focus()
	pass # Replace with function body.


func _on_delete_save_file_pressed():
	
	
	DirAccess.remove_absolute(Global.SAVE_PATH)	
	get_tree().quit()
	
	

	pass # Replace with function body.


func _on_credits_pressed():
	get_node("Main").position.y = -131.945
	get_node("Main/Back3").grab_focus()
	pass # Replace with function body.


func _on_easy_mode_pressed():
	
	Global.dificulty = 1
	Global.movescene("res://scenes/level.tscn")
	pass # Replace with function body.


func _on_hard_mode_pressed():
	Global.dificulty = 2
	Global.movescene("res://scenes/level.tscn")
	pass # Replace with function body.


func _on_controler_pressed():

	Global.mousecontrol =  get_node("Main/controler?").button_pressed 

	pass # Replace with function body.
