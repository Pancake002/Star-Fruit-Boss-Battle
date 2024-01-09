extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	if Global.timething2 <= 90:
		Global.winin130 = 1
	if Global.starsHit < 20:
		Global.winwithouthavinganystars = 1
	if Global.useautofire == 0:
		Global.winwithnoautofire = 1
	if Global.resolution <= 0.27800001:
		Global.winatlowestresolution = 1
	if Global.playerhp == 100:
		Global.winwithoutgettinghit = 1
	
	
	get_node("Camera2D").zoom = Vector2(1,1)* (3.445/2 * Global.resolution)
	get_node("winsong").volume_db = linear_to_db( (Global.musicvolume/100)- .5) 
	get_node("info").text = "- With " + str(Global.playerhp) + "% HP!\n"
	var seconds = (int(Global.timething2) % int(60))
	var minutes = int(int(Global.timething2/60)%int(60))
	var miliseconds =str(abs(round(( round(Global.timething2)-Global.timething2)*1000)))
	#May add miliseconds later

	get_node("info").text += "- In " + str(minutes) +":"+str((seconds))+"."+miliseconds+ "!\n"
	get_node("info").text += "- And you hit " +str( Global.starsHit) + " stars!"
	
	
	Global.savethedata()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	Global.movescene("res://scenes/main_menu.tscn")
	pass # Replace with function body.
