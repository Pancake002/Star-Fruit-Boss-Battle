extends CharacterBody2D


var realrot = 0
var lolrotvelo = 0
var speed = 0
var ismoving = 0
var tempposhurt = Vector2.ZERO
var speedtoliveupto = 0
var type = 0
var starfruit 
var pivot 
var lol = 0
var listitem = 0
var offd = 0
var listlocation = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	if type == 1:

		speed = 0
		
		

	listlocation = Global.starfruit.bulletlist.size()-1
	if Global.starfruit.phase == 2:
		get_node("Sprite2D").texture = load("res://starcrack.png")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	

	
	
	
	if (Global.starfruit.prog == 200) or (Global.starfruit.prog == 2 and Global.starfruit.phase == 2 and type == 2) :
		if type != 1:
			type = 1
			speed = 0
			speedtoliveupto = 5
			modulate = Color.WHITE 
		if Global.starfruit.phase ==2 :
			
			Global.starfruit.shieldstars = {}
		
	if ismoving <= 0:
		rotate(lolrotvelo)
		position += Global.right(realrot) * speed
		if type != 2:
			if abs(position.x) > 109 or abs(position.y) > 65:

				queue_free()
		if type == 1:
			if speed < speedtoliveupto:
				speed += .1
			else:
				speed = speedtoliveupto
		elif type == 2:
			get_node("Sprite2D").modulate = Color.YELLOW 
			if lol <= 25:
				lol += .5
			position = Global.starfruit.position + Global.right(float (Global.starfruit.shieldrotkeeptrack + offd)) * lol/(5/Global.starfruit.scale.x)
			realrot += speed
			scale.x = 1.1/(5/Global.starfruit.scale.x)
			scale.y = scale.x
	else:
		position = tempposhurt + Vector2(randf_range(-1,1),randf_range(-1,1))
		ismoving -= 1
	pass
func hurt(a):
	ismoving = a
	tempposhurt = position
func strike(rot):
	
	if type != 2:
		Global.soundplay("res://sounds/star-bounce.wav")
	if type == 2:
		Global.starfruit.shieldstars.erase(name)
		Global.soundplay("res://sounds/spit.wav")
		speed = 0
		speedtoliveupto = 5
		type = 1
		realrot = rot + deg_to_rad( 180)
		Global.makeStarBullet( position.x,position.y,speedtoliveupto,realrot + deg_to_rad(5),realrot,lolrotvelo,1)
		Global.makeStarBullet( position.x,position.y,speedtoliveupto,realrot - deg_to_rad(5),realrot,lolrotvelo,1)
		modulate = Color.WHITE 
	if Global.starfruit.phase == 2:
		Global.soundplay("res://sounds/54.wav")
		queue_free()
	
	pass
