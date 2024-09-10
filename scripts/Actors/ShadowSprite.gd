@tool
class_name ShadowSprite extends Sprite2D
const TRANSFORM: Transform2D = Transform2D(Vector2(1, 0), Vector2(0.7, 0.3), Vector2(-23, 23))

@export var base_transform: Transform2D = Transform2D():
    set(val):
        base_transform = val
        transform = val

@export var sprite: Sprite2D: set = set_sprite
    

func set_sprite(val: Sprite2D) -> void:
    if sprite == val: return
    if sprite:
        sprite.frame_changed.disconnect(_on_frame_changed)
        sprite.texture_changed.disconnect(_on_texture_changed)

    sprite = val
    
    if sprite:
        sprite.frame_changed.connect(_on_frame_changed)
        sprite.texture_changed.connect(_on_texture_changed)
        texture = create_image_shadow(sprite.texture.get_image())
        hframes = sprite.hframes
        vframes = sprite.vframes
        frame = sprite.frame

    visible = sprite != null

func _enter_tree() -> void:
    if not get_parent() is Sprite2D: return

    var sprite: Sprite2D = get_parent()
    sprite.frame_changed.connect(_on_frame_changed.bind(sprite))
    sprite.texture_changed.connect(_on_texture_changed.bind(sprite), CONNECT_DEFERRED)
    texture = create_image_shadow(sprite.texture.get_image())
    hframes = sprite.hframes
    vframes = sprite.vframes
    frame = sprite.frame


func _exit_tree() -> void:
    if not get_parent() is Sprite2D: return

    var sprite: Sprite2D = get_parent()
    sprite.frame_changed.disconnect(_on_frame_changed)
    sprite.texture_changed.disconnect(_on_texture_changed)
    
    texture = null
    hframes = 1
    vframes = 1
    frame = 0


func _on_frame_changed(sprite: Sprite2D) -> void:
    flip_h = sprite.flip_h
    frame = sprite.frame


func _on_texture_changed(sprite: Sprite2D) -> void:
    texture = create_image_shadow(sprite.texture.get_image())


func create_image_shadow(img: Image) -> Texture2D:
    if img.is_empty() or img.is_invisible(): return null
    var shadow: Image = Image.create(img.get_width(), img.get_height(), false, img.get_format())
    for x: int in img.get_width():
        for y: int in img.get_height():
            shadow.set_pixel(x, y, Color(1, 1, 1, img.get_pixel(x, y).a))

    return ImageTexture.create_from_image(shadow)

func _get_configuration_warnings() -> PackedStringArray:
    var warnings := PackedStringArray()
    if not get_parent() is Sprite2D:
        warnings.append("Shadow is not child of Sprite2D.")
    return warnings


func _notification(what: int) -> void:
    match what:
        NOTIFICATION_PARENTED:
            update_configuration_warnings()
