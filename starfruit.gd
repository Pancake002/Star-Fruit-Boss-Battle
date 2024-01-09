extends CharacterBody2D

var prog = 0
var lol = 0
var speed = 0
var direction = 0
var whichway = 0
@onready var ranger =  get_node("../Player")
var tempintlol = 3
var ismoving = 0
var tempposhurt : Vector2 = Vector2.ZERO
var savposforshake: Vector2 = Vector2.ZERO
var fakesaverot = 0
var shieldstars : Dictionary = {}
var lol2 = 0
var anothervariableyay = 0
var shieldrotkeeptrack = 0
var phase = 1
var chainlist: = []
var speedoffset = 1
var bulletlist = []
var timething : float = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.starfruit = self
	position = Vector2(0,-71)

	Global.start()
	
	
	
	
	
	
			#d.get_node("PinJoint2D").node_a= links[0].get_path()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timething += 1
	
	get_node("../sound/Ranger says Also_wav").pitch_scale = randf_range(1-.1,1.1	)
	
	
	if Global.debug:
		
		if Input.is_action_just_pressed("ui_accept") :
			prog += 1
			lol = 0
		if Input.is_action_just_pressed("backspace") :
			prog = 202
		elif Input.is_action_just_pressed("ui_r_button"):
			
			Global.movescene("res://scenes/level.tscn")
		elif Input.is_action_just_pressed("nextphasedebug"):
			if phase == 1:
				ranger.starFruitHPBar.scale.x = .500000000001
			else:
				ranger.starFruitHPBar.scale.x = .01
				ranger.starFruitHPBar.get_parent().get_node("starhp").text = str(int(ranger.starFruitHPBar.scale.x/.01)) + "%"
			
		elif Input.is_action_just_pressed("esc"):
			Global.movescene("res://scenes/main_menu.tscn")
			
	
	if ismoving <= 0:
		match prog:
			0:
				if position.y < -15:
					position.y += .3 * speedoffset
				else:
					lol += 1
					if lol > 10:
						Global.soundplay("res://sounds/spit.wav")
						for i in range(360/20):
							
							Global.makeStarBullet(position.x,position.y,2,i,i,5 * sign(i- 360/20) )
							prog = 1
							lol = 0
			1:
				lol += 1
				if lol > 5:
					Global.soundplay("res://sounds/spit.wav")
					for i in range(360/20 + 5):
						
						Global.makeStarBullet(position.x,position.y,2,i + 5,i,5 * sign(i- 360/20) )
					prog = 2
					lol = 0
			2:
				if lol == 0:
					direction = 5
					whichway = randi_range(0, 1) * 2 - 1

					
				direction += whichway * .1 * speedoffset
				position.x += .5 * speedoffset
				if lol > 380:
					position.y += .2 * speedoffset
				switch()
				position += Global.right(direction) * speed / speedoffset

				if speed < 2:
					speed += .1 * speedoffset
				lol += 1
				if lol % int(30/speedoffset) == 0 or lol % int(35/speedoffset) == 0 :
					look_at(ranger.position)
					Global.soundplay("res://sounds/spit.wav")
					var l = Global.makeStarBullet(position.x,position.y,1,rotation ,3,3  )
					l.scale /= 2
					var huh = Global.right(rotation + 90)*2
					l = Global.makeStarBullet(position.x + huh.x,position.y +huh.y,1,rotation ,3,3  )
					l.scale /= 2
					huh = Global.right(rotation  -90)*2
					l = Global.makeStarBullet(position.x + huh.x,position.y +huh.y,1,rotation ,3,3  )
					l.scale /= 2
					rotation = 0
					if phase == 2:
						look_at(ranger.position)
						rotate(deg_to_rad(randf_range(-360,360)))
						Global.soundplay("res://sounds/spit.wav")
						l = Global.makeStarBullet(position.x,position.y,1,rotation ,3,3  )
						l.scale /= 2
						huh = Global.right(rotation + 90)*2
						l = Global.makeStarBullet(position.x + huh.x,position.y +huh.y,1,rotation ,3,3  )
						l.scale /= 2
						huh = Global.right(rotation  -90)*2
						l = Global.makeStarBullet(position.x + huh.x,position.y +huh.y,1,rotation ,3,3  )
						l.scale /= 2
						rotation = 0
						
				if lol > 1000:
					lol = 0
					tempintlol = speed
					prog = 3
			3:
				if speed <= 0:
					if position.x > 59:
							position.x -= .1 * speedoffset
					if position.y < 0:
						position.y += .1* speedoffset
				if lol == 0:
					speed -= .05
					direction += whichway * .1 * speedoffset
					position.x += .5 * (speed/tempintlol) * speedoffset
					position.y += .2 * (speed/tempintlol) * speedoffset
					switch()
					position += Global.right(direction) * speed * speedoffset
					if speed <= 0:
						lol += 1
						if position.x > 59:
							position.x -= .1
						if position.y > 0:
							position.y -= .1
				elif lol < 10:
					lol += 1
				elif lol < 300:
					lol += 1
					
					if int(lol) % int(10/speedoffset) == 1:
						Global.soundplay("res://sounds/spit.wav")
						look_at(ranger.position)

						for i in range(-5,5,1):
							
							
							var l = Global.makeStarBullet(position.x + transform.y.x * i/2 ,position.y + transform.y.y * i/2,1,rotation - deg_to_rad(i*2)   ,3,3  )
							l.scale /= 1.5
							
						rotation = 0
				else:
					prog = 4
					lol = 0
					
			4:
				if lol == 0:
					savposforshake = position
				lol += 1
				if lol < 34:
					position = savposforshake + Vector2(randf_range(-lol/3,lol/3),randf_range(-lol/3,lol/3)) * speedoffset
				else:
					position = savposforshake
					look_at(ranger.position)
					var l = Global.makeStarBullet(position.x,position.y,5,rotation   ,3,3,1  )
					l.scale *= 7 
					if phase ==2:
						l = Global.makeStarBullet(position.x,position.y,5,rotation + deg_to_rad(20)  ,3,3,1  )
						l.scale *= 7 
						l = Global.makeStarBullet(position.x,position.y,5,rotation - deg_to_rad(20)  ,3,3,1  )
						l.scale *= 7 
					prog = 5
					lol = 0
					Global.soundplay("res://sounds/spit.wav")
					
			5:
				lol += 1
				if lol > 10:
					rotation = 0
					lol = 0
					prog = 6
			6:
				
				if lol == 0:
					look_at(ranger.position)
					savposforshake = transform.x
					rotation = 0
					speed = 0
					fakesaverot = rotation
					tempintlol = 0
				lol += 1
				if speed < 5:
					speed += .001 * speedoffset
				else:
					speed = 5
				position += savposforshake * speed * speedoffset
				fakesaverot += deg_to_rad(4)
				if lol % int(20/speedoffset) == 1:
					Global.soundplay("res://sounds/spit.wav")
					var l = Global.makeStarBullet(position.x,position.y,1.1,deg_to_rad(rad_to_deg(fakesaverot) + 90) ,3,3 ,1 )
					
				elif  lol % int(10/speedoffset) == 1:
					Global.soundplay("res://sounds/spit.wav")
					var l = Global.makeStarBullet(position.x,position.y,1.1,deg_to_rad(rad_to_deg(fakesaverot) -90) ,3,3,1  )
					
				if switch():
					tempintlol += 1 * speedoffset
					pass
				if tempintlol > 3:
					prog = 7
			7:
				look_at(Vector2(0,0))
				position = Vector2(Global.lineargo(position.x,0,2),Global.lineargo(position.y,0,2* speedoffset))
				rotation = 0
				if position.x == position.y and position.y == 0:
					Global.soundplay("res://sounds/spit.wav")
					for i in range(0,361,15):
						if shieldstars.has("shield" + str(i)) != true:
							var l =Global.makeStarBullet(position.x,position.y,.05,deg_to_rad(i) ,3,.1,2  )
							print(l)
							l.scale *= 1.1
							l.name = "shield" + str(i)
							l.offd = deg_to_rad(i)
							shieldstars.merge( {l.name : l})
						
					prog = 8
			8:
				lol += 1 
				if lol > 130:
					prog = 9
					lol = 0
					speed = 0
			9:
				if lol == 0:
					
					lol2 = 0
					anothervariableyay = 0
				anothervariableyay += 1 * speedoffset
				if speed < 1:
					speed += .005 * speedoffset
				else:
					speed = 1
				print(speed)
				lol += deg_to_rad( 3/1.1* (speedoffset) )
				lol2 += deg_to_rad( 6/1.1 * (speedoffset))
				position = Vector2(Global.right(lol/3.5).x * 70 ,Global.right(lol2/1.5).x * 40 ) * speed
				switch()
				
				direction = 0
				position.x 
				if int( rad_to_deg(lol)*2) % int(80/speedoffset) == 1:
					Global.soundplay("res://sounds/spit.wav")
					Global.makeStarBullet(position.x,position.y,.8,deg_to_rad(0),.2,.2,1  )
				elif int( rad_to_deg(lol)*2) % int(60/speedoffset) == 1:
					Global.soundplay("res://sounds/spit.wav")
					Global.makeStarBullet(position.x,position.y,.8,deg_to_rad(90),.2,.2,1  )
				elif int( rad_to_deg(lol)*2) % int(40/speedoffset) == 1:
					Global.soundplay("res://sounds/spit.wav")
					Global.makeStarBullet(position.x,position.y,.8,deg_to_rad(90*2),.2,.2,1  )
				elif int( rad_to_deg(lol)*2) % int(20/speedoffset) == 1:
					Global.soundplay("res://sounds/spit.wav")
					Global.makeStarBullet(position.x,position.y,.8,deg_to_rad(90*3),.2,.2,1  )
				print(anothervariableyay)
				if  anothervariableyay > 1200:
					prog = 10
				pass
			10:
				if speed > 0:
					speed -= .05*speedoffset
				lol += deg_to_rad( 3/1.1*speedoffset)
				lol2 += deg_to_rad( 6/1.1*speedoffset)
				position = Vector2(Global.right(lol/3.5).x * 70 ,Global.right(lol2/1.5).x * 40 ) * speed
				switch()
				if speed <= 0:
					prog = 1
			200:
				ranger.starFruitHPBar.scale.x = .5
				ismoving = 3
				if lol == 0:
					shieldstars = {}
					anothervariableyay = 1
				phase = 2
						
				
				lol += 1
				
				
				if lol > 20:
					if scale.x > 3:
						scale -= Vector2(.05,.05)
					else:
						scale.x = 3
						scale.y = scale.x
				if lol > 30:
					if anothervariableyay > .65:
						anothervariableyay -= .01
					else:
						anothervariableyay = .65
					modulate = Color(1,anothervariableyay,anothervariableyay)
				
				
				var l = get_node("../sound/Music/")
				l.volume_db = linear_to_db(db_to_linear( Global.savemusicvolume)/(lol))
				l.pitch_scale -= .1
				
				if lol > 60:
					modulate = Color(1,.65,.65)
					speedoffset = 1.5
					prog = 201
					l.pitch_scale = 1
					lol = 0
					l.volume_db = Global.savemusicvolume
					scale = Vector2(3,3)
					prog= 0
					get_node("../sound/Music/").stream = load("res://sounds/1NF3$@!0N (Electric Zoo Remix) - SiIvaGunner_ King for Another Day.mp3")
					get_node("../sound/Music/").play()
					
			201:
				if lol == 0:
					savposforshake = position
					ranger.canmove = 99999
					get_node("../sound/Music/").pitch_scale = 8
					ranger.get_node("Area2D").get_node("CollisionShape2D").disabled = true

				position = savposforshake + Vector2(randf_range(-5,5),randf_range(-5,5))
				lol +=1
				get_node("../sound/Music/").pitch_scale -=.07
				if get_node("../sound/Music/").pitch_scale < 1:
					get_node("../sound/Music/").volume_db = linear_to_db(0)
				if lol > 40:
					
					
					get_node("../sound/Music/").volume_db = linear_to_db(0)
					modulate = Color.WHITE
					prog = 202
					lol = 0
					speed = 0
					
			202:
				lol += 1
				if lol > 50:
					speed -= .2
					position.y += speed
				if lol > 120:
					Global.timething2 = timething/60
					Global.playerhp = int(ranger.SelfHPBar.scale.x/.01)
					
					Global.movescene("res://scenes/win_sceene.tscn")
	else:
		position = tempposhurt + Vector2(randf_range(-1,1),randf_range(-1,1))
		ismoving -= 1
		
		if ismoving <= 0:
			position = tempposhurt
		var j = randf_range(-5,5)
		if len(shieldstars.keys()) > 0:
			for i in shieldstars.keys():
				shieldrotkeeptrack += deg_to_rad(j)
	shieldrotkeeptrack += .05		
	print(bulletlist)
	if ranger.starFruitHPBar.scale.x <= 0 and prog != 201:
		ranger.starFruitHPBar.scale.x = 0
		prog = 201
		lol = 0
	if phase == 2 and prog != 200 and  prog != 201:
		
		
		if ranger.starFruitHPBar.scale.x < .13:
			speedoffset += .001
			get_node("../sound/Music/").pitch_scale += 0.0003
				
	pass

func switch():
	var thing = false
	if abs(position.x) > 109:
		position.x = -position.x
		thing = true
	if abs(position.y) > 65:
		position.y = -position.y
		thing = true
	return(thing)

func hurt(a):

	ismoving = a
	tempposhurt = position
	if ranger.starFruitHPBar.scale.x <= .5 and phase == 1:
		
		position = tempposhurt
		
		
		lol = 0
		prog = 200
