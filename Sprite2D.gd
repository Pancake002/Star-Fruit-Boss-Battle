extends Sprite2D
var timetodis = 0
var varorigpos = Vector2(0,0)
var nextrotlolthing1 = 0
var nextrotlolthing2 = 0
var alphalol = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	varorigpos = position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	timetodis += 1
	if timetodis < 10:
		if nextrotlolthing1 == 0:
			nextrotlolthing1 = randi_range(1,3)
			
			position = varorigpos + Vector2(randf_range(-.2,.2),randf_range(-.2,.2))
		if nextrotlolthing2 == 0:
			nextrotlolthing2 = randi_range(1,3)
			if modulate == Color.YELLOW:
				modulate = Color.WHITE
			else:
				modulate =  Color.YELLOW
		
		nextrotlolthing1 -= 1
		nextrotlolthing2 -= 1
	elif timetodis < 25:


		self_modulate.a -=.1
	elif timetodis > 9:
		queue_free()
	
	pass

