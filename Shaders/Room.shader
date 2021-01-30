shader_type canvas_item;

uniform float darkness : hint_range(0, 1);

void fragment() {
	COLOR = texture(TEXTURE, UV) * darkness;
    //COLOR = vec4(1.0, 0.0, 0.0, 1.0);
}