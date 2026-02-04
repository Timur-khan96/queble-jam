shader_type canvas_item;

uniform sampler2D mask_texture;

void fragment() {
    vec4 dirt = texture(TEXTURE, UV);
    float mask = texture(mask_texture, UV).r;

    COLOR = vec4(dirt.rgb, dirt.a * mask);
}