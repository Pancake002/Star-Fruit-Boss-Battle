extends Node

var starbullet = preload("res://starbullet.tscn")
var debug = true
@onready var starfruit 
var sfxvolume = 100
var musicvolume = 100
var mainmenu 
var savedata = {}
const SAVE_PATH = "res://savedata.epaicfiletype"
var savemusicvolume = 0
var resolution = 2.66667
var savefileinfo
var whichhitsound = 0
var timething2
var starsHit
var playerhp

var useautofire = 0
var savetemp

var winin130 = 0
var winwithouthavinganystars = 0
var winwithnoautofire = 0
var winatlowestresolution = 0
var winwithoutgettinghit = 0
var diein10seconds = 0

var file : Dictionary = {}

var middleclickmove = false
var dificulty = 0


var mousecontrol = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func dist(a, b):
	return(abs(b.x - a.x) + abs(b.y-a.y))

func makeStarBullet( x,y,speed,rotation_move,initial_rotation = 0,spin_speed = 0, type = 0):
	var l = starbullet.instantiate()
	get_node(".").add_child(l)
	l.position = Vector2(x,y)
	l.rotation = initial_rotation
	l.realrot = rotation_move
	l.lolrotvelo = spin_speed
	l.speed = speed
	l.type = type
	l.speedtoliveupto = speed
	if type == 1:
		l.speed = 0
	
	
	return(l)
	pass

func right(rot):
	return(Vector2(cos(rot), sin(rot)))
func lineargo(start,stop,inc):
	var h = start
	if h < stop:
		h += inc
		if h > stop:
			h = stop
	elif h > stop:
		h -= inc
		if h < stop:
			h = stop
	return(h)
	
func soundplay(sound ):
	if sound[sound.length()-1] == "/":
		sound.remove_at(sound.length()-1)
	var f = sound.split("/")[ sound.split("/").size()-1]
	for i in range(f.length()):
		if f[i] == ".":
			f[i] = "_"

	if starfruit.has_node("../sound/"+f) :
		var l = starfruit.get_node("../sound/" + f)
		l.stream = (load(sound))
		l.play()
		
	else:
		var l =AudioStreamPlayer.new()
		l.name = f
		starfruit.get_node("../sound/").add_child(l)
		l.stream = (load(sound))
		l.volume_db = linear_to_db( db_to_linear(l.volume_db) * (sfxvolume/100))
		l.name = f
		l.play()
	

func start():
	for i in get_children():
		i.queue_free()
	
	
	useautofire = 0
	starsHit = 0
	for i in starfruit.get_node("../sound").get_children():
		i.volume_db = linear_to_db( db_to_linear(i.volume_db) * (sfxvolume/100))
	adjmusicvolume()
	starfruit.get_node("../Camera2D").zoom = Vector2(1,1)* (3.445/2 * resolution)
func adjmusicvolume():
	var l = starfruit.get_node("../sound/Music/")
	l.volume_db = linear_to_db( db_to_linear(l.volume_db) * (musicvolume/100))
	savemusicvolume = linear_to_db( db_to_linear(l.volume_db) * (musicvolume/100))

func savethedata():
	savedata = {}
	savedata.merge({"sfxvolume":int(sfxvolume)})
	savedata.merge({"musicvolume":int(musicvolume)})
	savedata.merge({"debug":debug})
	savedata.merge({"resolution":resolution})
	savedata.merge({"whichhitsound":whichhitsound})
	savedata.merge({"winin130":winin130 })
	savedata.merge({"winwithouthavinganystars":winwithouthavinganystars })
	savedata.merge({"winwithnoautofire":winwithnoautofire})
	savedata.merge({"winatlowestresolution":winatlowestresolution })
	savedata.merge({"winwithoutgettinghit":winwithoutgettinghit })
	savedata.merge({"diein10seconds":diein10seconds })
	savedata.merge({"middleclickmove":middleclickmove})
	savedata.merge({"mousecontrol":mousecontrol})
	savefileinfo = var_to_str(savedata)
	savefileinfo[0] = ""
	savefileinfo[0] = ""
	savefileinfo[savefileinfo.length()-1] = ""
	savefileinfo[savefileinfo.length()-1] = ""
	var file = FileAccess.open(SAVE_PATH,FileAccess.WRITE)
	file.store_string(savefileinfo)
	file = savefileinfo
	
func loadthedata():
	if FileAccess.file_exists(SAVE_PATH):
		savefileinfo = str(FileAccess.open(SAVE_PATH,FileAccess.READ).get_as_text())
		savefileinfo = "{\n" + savefileinfo
		savefileinfo +=  "\n}"
		
		file  = str_to_var(savefileinfo)
		for i in file:
			set(i,file[i])
		

		return(true)
	else:

		return(false)
func movescene(s):
	
	for i in get_node(".").get_children():
		if i != self:
			i.queue_free()
	get_tree().change_scene_to_file(s)
