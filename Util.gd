@tool
extends EditorScript
const FRAME_LENGTH: float = .15
const START_FRAME: int = 0
const TOTAL_FRAMES: int = 8
const ANIMATIONS:= {
	"air_idle": 16,
	"attack": 51,
	"idleA":41,
	"idleB":21,
	"jump":61,
	"land":21,
	"run": 41,
	"walk":31,
	}


const WOLF_DIR:="res://art/wolf_remake/"
const WOLF_ANIMATIONS : AnimationLibrary = preload("res://resources/animations/wolf_animations.tres")
const CHARACTER_ANIMATIONS : AnimationLibrary = preload("res://resources/animations/character_animations.res")

const SPRITES: PackedStringArray = ["Skin", "Boots", "Torso", "Hair"]
const ANIMATION_FRAMES: PackedInt32Array = [5,8,8,4,4,6,9]
const NAMES: PackedStringArray = ["idle", "walk", "run", "jump", "fall", "attack", "die"]


func _run() -> void:
	var scene: = get_scene()
	for i in 11:
		printt(i, "%3.3f" % ease(float(i)/10.0, 1.8))
	



func create_property_animation(
	nodes: PackedStringArray, 
	start_frame: int = 0, 
	frame_count: int = 1, 
	frame_length: float = .15,
	anim: Animation = Animation.new(),
	texture: Texture = null,
	) -> Animation:
	
	anim.length = frame_count * frame_length
	anim.loop_mode = Animation.LOOP_LINEAR
	
	for node: String in nodes:
		var track_index: int = anim.add_track(Animation.TYPE_VALUE, )
		
		if texture:
			var texture_track: int = anim.add_track(Animation.TYPE_VALUE, )
			anim.track_set_path(texture_track, "%s:texture" % [node])
			anim.track_insert_key(texture_track, 0.00, texture)
			
		anim.track_set_path(track_index, "%s:frame" % [node,])
		anim.value_track_set_update_mode(track_index, Animation.UPDATE_DISCRETE)
		for i: int in frame_count:
			anim.track_insert_key(track_index, i*frame_length, start_frame + i,)
			
	return anim

func add_animation(name: StringName, animation: Animation, lib: AnimationLibrary = CHARACTER_ANIMATIONS) -> void:
	if lib.has_animation(name):
		lib.remove_animation(name)
		
	lib.add_animation(name, animation)

func create_sprite_frames(
	name: StringName, 
	texture: Texture = null,
	start_frame: int = 0, 
	frame_count: int = 1, 
	frame_length: float = .066666,
	frame_size: Vector2 = Vector2(80, 64),
	w_frames: int = 10, h_frames: int = 7,
	sprite_frames: SpriteFrames = SpriteFrames.new() ) -> SpriteFrames:
	
	if sprite_frames.has_animation(name):
		sprite_frames.clear(name)
	else:
		sprite_frames.add_animation(name)
		
	var atlas_tex: AtlasTexture = AtlasTexture.new()
	atlas_tex.atlas = texture
	for i: int in frame_count:
		var frame: int = i + start_frame
		var rect_pos: Vector2 = Vector2(frame % w_frames, frame / h_frames)*frame_size
		atlas_tex.region = Rect2(rect_pos, frame_size)
		sprite_frames.set_frame(name, i, atlas_tex, )
	
	return sprite_frames

func get_sheet_textures(texture: Texture2D, w_frames: int = 10, h_frames: int = 7, frames: PackedInt32Array = []) -> Array[Array]:
	
	var frame_size: Vector2 = Vector2(texture.get_width()/w_frames,texture.get_height()/h_frames)
	var result: Array[Array] = []
	result.resize(h_frames)
	for y: int in h_frames:
		var atlas_textures: Array[AtlasTexture] = []
		atlas_textures.resize(w_frames)
		for x: int in w_frames:
			atlas_textures[x] = AtlasTexture.new()
			atlas_textures[x].region = Rect2(x * frame_size.x, y * frame_size.y, frame_size.x, frame_size.y)
			
	return result
