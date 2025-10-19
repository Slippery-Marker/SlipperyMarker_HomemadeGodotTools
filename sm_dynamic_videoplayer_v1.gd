class_name videorandomizer
extends Node3D
#-----Variables-----#
enum _playertype {billboard=0,tv=1,external_media=2}
static var _shared_billboard_videopool:Array[VideoStream]
static var _billboard_videolist_initialization:bool=false 
static var _shared_billboard_videopool_size:int
var _billboard_videopool_pointer:int
var _video_player:VideoStreamPlayer
@export var billboard_video_pool:Array[VideoStream] #NOTE: When the script is attached to any node, video files can have their address assigned to this variable through drag and drop to the inspector tab with the node selected (and increasing the array size beforehand to open way for this) or by just clicking on the floder icon in the inspector menu to avoid hard coding the paths.
@export var player_type:_playertype=_playertype.billboard #NOTE: When the script is attached to any node, the needed functionality can be chosen through a drawer menu from the Inspector tab on the right.
#-----Ready Function-----#
func _ready() -> void:
	if !_billboard_videolist_initialization && !billboard_video_pool.is_empty():
		_shared_billboard_videopool.assign(billboard_video_pool) #NOTE: it's generally a good thing to have the video pool assigned to a global variable ('static' keyword before 'var') that can hold consistant data between instanciated versions of the tv, it helps with array errors down the line (mainly "Index Out of Bound" error)
		_billboard_videolist_initialization=!_billboard_videolist_initialization #NOTE: When this is set, it stops other instances of the node scene with this script attached to them from making mismatched, seperate versions of the array for themselves.
	match _playertype:
		0:
			_video_player=%VideoStreamPlayer #NOTE: %VideoStreamPlayer refers to the Node of the same name (and type) but "Access as Unique Name" is set to true. it's a good habit to set nodes like this (which is gonna have their name used alot in this program for example) to a variable of the same type as the node.(for example, you change the name of the node and come back to script, you'll have to change just one word in the script which is the line this comment is on (the name after %))
			_video_player.autoplay=true
			_video_player.volume_db=-80
			_video_player.finished.connect(_billboard_video_finished)
#-----Repeatable Tasks-----#
func _update_videopool_size(): #NOTE: instead of writing the whole update code everywhere, imma func it. (real usage: dynamic array size while in runtime (removal of array cells (example: my tv system's game jam version ensures video uniqueness per tape by removing the last video selected)))
	_shared_billboard_videopool_size=_shared_billboard_videopool.size()
func _video_randomizer(): #NOTE: in my origial code used in the game jam, i used whatever i found online. as i've tested just now, you do not need to use the "randomize()" function to get a new number, you just call this function.
	_update_videopool_size()
	_billboard_videopool_pointer=randi()%_shared_billboard_videopool_size
#-|-Billboard Specific-|-#
func _billboard_video_finished():
	_video_randomizer()
	_video_player.stream=_shared_billboard_videopool[_billboard_videopool_pointer]
func _tv_media_finished():
	pass
