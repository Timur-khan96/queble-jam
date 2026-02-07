shader_type canvas_item;
uniform bool invert = false;

void fragment() {
    vec4 c = texture(TEXTURE, UV);
    if (invert) {
        c.rgb = vec3(1.0) - c.rgb;
    }
    COLOR = c;
}