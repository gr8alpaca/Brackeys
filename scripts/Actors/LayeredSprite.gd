@tool
class_name LayeredSprite extends Sprite2D

const SHADOW_TRANSFORM: Transform2D = Transform2D(Vector2(1, 0), Vector2(0.7, 0.3), Vector2(-23, 23))
const SHADOW_MODULATE: Color = Color(0, 0, 0, 0.515)

@export var texture_layers: Array[Texture2D] = []: set = set_textures


@export var shadow_transform: Transform2D = SHADOW_TRANSFORM:
	set(val): shadow.transform = val
	get: return shadow.transform


@export var shadow_modulate: Color = SHADOW_MODULATE:
	set(val): shadow.modulate = val
	get: return shadow.modulate


var shadow: Sprite2D = Sprite2D.new()

func _init() -> void:
	add_child(shadow)
	shadow.show_behind_parent = true
	shadow.transform = SHADOW_TRANSFORM
	shadow.modulate = SHADOW_MODULATE
	for prop: StringName in [&"hframes", &"vframes", &"flip_h", &"flip_v", &"frame", &"frame_coords", &"vframes"]:
		shadow.set(prop, get(prop))
		

func set_textures(val: Array[Texture2D]) -> void:
	texture_layers = val
	texture_from_layers(filter_layers(texture_layers))


func change_texture_image(img: Image) -> void:
	if not img:
		texture = null
		shadow.texture = null
		return

	shadow_from_image(texture.get_image())


func texture_from_layers(layers: Array[Texture2D]) -> void:
	var images: Array[Image] = map_to_images(layers)
	if images.is_empty():
		texture = null
		return

	var base_image: Image = Image.new()
	base_image.copy_from(images.pop_front())
	var image_size: Vector2i = base_image.get_size()
	for i: int in images.size():
		base_image.blend_rect(images[i], Rect2i(Vector2i.ZERO, image_size), Vector2i.ZERO)

	texture = ImageTexture.create_from_image(base_image)
	shadow_from_image(base_image)


func shadow_from_image(img: Image) -> void:
	if img.is_empty() or img.is_invisible():
		shadow.texture = null
		return
	
	var shadow_img: Image = Image.create(img.get_width(), img.get_height(), false, img.get_format())
	for x: int in img.get_width():
		for y: int in img.get_height():
			shadow_img.set_pixel(x, y, Color(1, 1, 1, img.get_pixel(x, y).a))

	shadow.texture = ImageTexture.create_from_image(shadow_img)


func filter_layers(layers: Array[Texture2D]) -> Array[Texture2D]:
	if not layers or layers.is_empty(): return []
	var filtered_layers: Array[Texture2D] = []
	var texture_size: Vector2 = Vector2.ZERO
	for tex: Texture2D in layers:
		if not tex:
			continue
		if not texture_size:
			texture_size = tex.get_size()
		elif texture_size != tex.get_size():
			continue
		filtered_layers.append(tex)

	return filtered_layers


func map_to_images(layers: Array[Texture2D]) -> Array[Image]:
	var images: Array[Image] = []
	images.resize(layers.size())
	for i: int in layers.size():
		images[i] = Image.new()
		images[i].copy_from(layers[i].get_image())
	return images


func _set(property: StringName, value: Variant) -> bool:
	if not shadow: return false

	match property:
		&"hframes", &"vframes", &"flip_h", &"flip_v", &"frame", &"frame_coords", &"vframes":
			shadow.set(property, value)
			# shadow.set(property.trim_prefix("shadow_"), value)

	return false