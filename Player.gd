extends CharacterBody2D

var lastrot = 0
var lightning = preload("res://lightning.tscn")
@onready var raycasttochecklightning = get_node("RayCast2D")
var canmove = 0
@onready var starFruitHPBar = get_node("../Camera2D/CanvasGroup/StarFruitHPbar") 
@onready var SelfHPBar = get_node("../Camera2D/CanvasGroup/RangerHPbar") 
@onready var hitbox =  get_node("Area2D")
var lightningcooldown = 0
var pushingrightmouse = false
var midlclick = false
var iframes = 0
var direction 
var directionr 
var rightstifk = 1
# Called when the node enters the scene tree for the first time.
func _ready():

	if Global.mousecontrol:
		midlclick = 1

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	iframes -= 1
	if !Global.mousecontrol:
		if Input.is_action_just_pressed("right mouse"):
			pushingrightmouse = true
		elif  Input.is_action_just_released("right mouse"):
			pushingrightmouse = false
		if len(hitbox.get_overlapping_bodies()) > 0:
			SelfHPBar.scale.x -= .0005
		if Input.is_action_just_pressed("middle click"):
			midlclick = true
		elif Input.is_action_just_released("middle click"):
			midlclick = false
		canmove -= 1
		lightningcooldown -= 1
		
		
		if canmove <= 0 and !pushingrightmouse and ((!midlclick and !Global.middleclickmove) or (midlclick and Global.middleclickmove)):
			if abs((get_global_mouse_position().x - position.x) + (get_global_mouse_position().y - position.y)) > 1.2:
				if abs((get_global_mouse_position().x - position.x) + (get_global_mouse_position().y - position.y)) > 1.2:
					lastrot = rotation
					look_at(get_global_mouse_position())
					if  ( rotation >= lastrot + 30 && rotation <= lastrot - 30 ):
						rotation = lastrot
			if Global.dist(position,get_global_mouse_position()) < 10:
				position = get_global_mouse_position()
			else:
				position += Vector2(cos(rotation), sin(rotation)) * 10
	else:
		canmove -= 1
		pushingrightmouse = false
		if Input.is_action_pressed("trigger"):
			pushingrightmouse = true
		
			
		if Input.is_action_pressed("rightstick"):
			rightstifk = .3
		else:
			rightstifk = 1
			
			
		
		
		if Input.is_action_just_pressed("pushstick"):
			midlclick = 1
		elif  Input.is_action_just_released("pushstick"):
			midlclick = .5
		if canmove <= 0:
			directionr =  Vector2(Input.get_joy_axis(0, 2), Input.get_joy_axis(0, 3))
			direction = Vector2(Input.get_joy_axis(0, 0), Input.get_joy_axis(0, 1))
			if !pushingrightmouse:
				if abs(direction.x) +abs(direction.y) > .5: 
					position += direction *5 * midlclick * rightstifk
			if abs(directionr.x) +abs(directionr.y) > .5: 
				look_at(position + directionr)
		
	
	
	
	position.x =clamp(position.x,-84,84)
	position.y = clamp(position.y,-46,46)
	if !pushingrightmouse and !Global.mousecontrol:
		if midlclick and !Global.middleclickmove:
			look_at(get_global_mouse_position())
		elif Global.middleclickmove and !midlclick and canmove <= 0:
			look_at(get_global_mouse_position())
	
	
	
	
	if( Input.is_action_just_pressed("bumper") or Input.is_action_just_pressed("left mouse") or pushingrightmouse)   and  canmove <= 0:
		canmove = 10
		if pushingrightmouse and !Input.is_action_just_pressed("left mouse") :
			Global.useautofire = 1
		Global.soundplay("res://sounds/smw_thunder.wav")
		if raycasttochecklightning.is_colliding() and raycasttochecklightning.get_collider().name == "StarFruit" :
			Global.starfruit.hurt(4)
			starFruitHPBar.scale.x -= .01
			
			if Global.starfruit.phase == 2:
				starFruitHPBar.scale.x -= .005
			starFruitHPBar.get_parent().get_node("starhp").text = str(int(starFruitHPBar.scale.x/.01)) + "%"
			
			Global.soundplay("res://sounds/thud.wav")
			
			spawnlightning(abs(raycasttochecklightning.get_collision_point().x - position.x) + abs(raycasttochecklightning.get_collision_point().y - position.y))
		else:
			if raycasttochecklightning.is_colliding():
				Global.starsHit += 1
				raycasttochecklightning.get_collider().hurt(4)
				raycasttochecklightning.get_collider().strike(rotation)
				spawnlightning(abs(raycasttochecklightning.get_collision_point().x - position.x) + abs(raycasttochecklightning.get_collision_point().y - position.y))	
				
					
			else:
				spawnlightning()
			
	pass
func _input(event):

	pass
func spawnlightning( distt = 999):
	var distlol = 0
	lightningcooldown = 20

	for r in 40:
		distlol += 4
		
		if distlol <= distt:
			var l = lightning.instantiate()
			get_tree().root.add_child(l)
			l.varorigpos = position + Vector2(cos(rotation), sin(rotation)) * (2 + r) * 3 + Vector2(cos(rotation + 90), sin(rotation + 90))
			l.position = l.varorigpos
			l.rotation = rotation
		

	
	return("")



func _on_area_2d_body_entered(body):
	if Global.dificulty == 2:
		if body.get_meta("Hurts",true):
			if Global.whichhitsound == 0:
				Global.soundplay("res://sounds/Ranger says Also.wav")
			else:
				Global.soundplay("res://sounds/hit2.wav")
			SelfHPBar.scale.x -= .01
			SelfHPBar.get_parent().get_node("rangerhp").text = str(int(SelfHPBar.scale.x/.01)) + "%"
			if SelfHPBar.scale.x < 0:
				if Global.starfruit.timething/60 <= 10:
					Global.diein10seconds = 1
					Global.savethedata()
				Global.movescene("res://scenes/main_menu.tscn")
	elif Global.dificulty == 1 and iframes <= 0:
		iframes = 60/2
		if body.get_meta("Hurts",true):
			if Global.whichhitsound == 0:
				Global.soundplay("res://sounds/Ranger says Also.wav")
			else:
				Global.soundplay("res://sounds/hit2.wav")
			SelfHPBar.scale.x -= .01
			SelfHPBar.get_parent().get_node("rangerhp").text = str(int(SelfHPBar.scale.x/.01)) + "%"
			if SelfHPBar.scale.x < 0:
				if Global.starfruit.timething/60 <= 10:
					Global.diein10seconds = 1
					Global.savethedata()
				Global.movescene("res://scenes/main_menu.tscn")
	pass # Replace with function body.
