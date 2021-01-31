shader_type canvas_item;

uniform vec4 col_mul = vec4(0.9, 0.1, 0.1, 0.0);

void fragment() {
	COLOR = texture(TEXTURE, UV);
    COLOR *= col_mul;
}