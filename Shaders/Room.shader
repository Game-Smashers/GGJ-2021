shader_type canvas_item;

uniform float darkness : hint_range(0, 1);
uniform vec4 col_mul = vec4(1, 1, 1, 1);

void fragment() {
	COLOR = texture(TEXTURE, UV) * darkness;
    COLOR *= col_mul;
}