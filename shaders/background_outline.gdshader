shader_type canvas_item;

uniform sampler2D mask_tex;
uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);
uniform float thickness = 2.0;
uniform bool hovered = false;

void fragment() {
    vec4 base = texture(TEXTURE, UV);
    float mask = texture(mask_tex, UV).r;

    vec4 final_color = base;

    if (hovered && mask > 0.5) {
        vec2 px = TEXTURE_PIXEL_SIZE * thickness;

        float edge =
            texture(mask_tex, UV + vec2(px.x, 0.0)).r +
            texture(mask_tex, UV + vec2(-px.x, 0.0)).r +
            texture(mask_tex, UV + vec2(0.0, px.y)).r +
            texture(mask_tex, UV + vec2(0.0, -px.y)).r;

        // If not fully surrounded → edge pixel
        if (edge < 4.0) {
            final_color = outline_color;
        }
    }

    COLOR = final_color;
}
